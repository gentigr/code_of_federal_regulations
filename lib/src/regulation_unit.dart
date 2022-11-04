import 'package:code_of_federal_regulations/src/unit_change.dart';
import 'package:code_of_federal_regulations/src/unit_descriptor.dart';
import 'package:code_of_federal_regulations/src/xml_parse_utils.dart';
import 'package:xml/xml.dart';
import 'package:diff_match_patch/diff_match_patch.dart';

class RegulationUnit {
  // fields
  String contentKey;

  String number;
  String type;
  XmlElement element;
  var units = [];

  // getters/setters

  // constructors
  RegulationUnit(this.contentKey, this.number, this.type, this.units, this.element);

  factory RegulationUnit.fromXmlDocument(XmlDocument document) {
    var element = XmlParseUtils.getRequiredChild(document, cfrDocumentHeadTag);
    var units = _getDescendantUnitsByType(cfrContentStartKeyword, getTypeNameByTag(cfrDocumentHeadTag), element);
    return RegulationUnit(cfrContentStartKeyword, cfrContentStartKeyword, getTypeNameByTag(cfrDocumentHeadTag), units, element);
  }

  factory RegulationUnit.fromXmlUnit(String parentContentKey, String type, XmlElement element) {
    String number = XmlParseUtils.getRequiredAttr(element, 'N');
    String contentKey = "$parentContentKey::$number";
    var units = _getDescendantUnitsByType(contentKey, type, element);
    return RegulationUnit(contentKey, number, type, units, element);
  }

  // methods/functions
  List<UnitChange> compareTo(RegulationUnit dst) {
    var srcUnits = {for (var u in units) u.number : u};
    var dstUnits = {for (var u in dst.units) u.number : u};

    var srcKeys = srcUnits.keys.toSet();
    var dstKeys = dstUnits.keys.toSet();

    // check for deleted sections
    var deletions = srcKeys
        .difference(dstKeys)
        .map((number) {
          print("-: ${srcUnits[number].contentKey}");
          return UnitChange.fromDeletion(srcUnits[number]);
        })
        .toList();

    // check for added sections
    var additions = dstKeys
        .difference(srcKeys)
        .map((number) {
          print("+: ${dstUnits[number].contentKey}");
          return UnitChange.fromAddition(dstUnits[number]);
        })
        .toList();

    // compare existing sections
    // TODO: handle case when section becomes descendant
    // TODO: handle case when section becomes parent
    // TODO: handle case when section moves around
    var modifications = srcKeys.intersection(dstKeys).map((number) {
      if (_isLeafUnit(srcUnits[number])
          && _isLeafUnit(dstUnits[number])) {
        // end node / leave to compare content
        if (srcUnits[number].element.toString().compareTo(dstUnits[number].element.toString()) != 0) {
          print("±: ${dstUnits[number].contentKey}");
          DiffMatchPatch dmp = DiffMatchPatch();
          List<Diff> changes = dmp.diff(srcUnits[number].element.toString(), dstUnits[number].element.toString());
          // List<Diff> d = dmp.diff('Hello World.', 'Goodbye World.');
          // Result: [(-1, "Hell"), (1, "G"), (0, "o"), (1, "odbye"), (0, " World.")]
          dmp.diffCleanupSemantic(changes);
          // Result: [(-1, "Hello"), (1, "Goodbye"), (0, " World.")]
          // print(d);
          return UnitChange(srcUnits[number], dstUnits[number], changes);
        }
        return UnitChange(null, null, List.empty());
      // } else {
      //   // intermediate node, proceed recursively deeper
      //   srcUnits[number].compareTo(dstUnits[number]);
      } else {
        return UnitChange(null, null, List.empty());
      }
    }).toList();
    //
    // var childrenChanges = srcKeys.intersection(dstKeys).where(
    //         (number) => !(_isLeafUnit(srcUnits[number])
    //             && _isLeafUnit(dstUnits[number]))).map((number) {
    //               print("$contentKey::$number");
    //               print("${srcKeys.intersection(dstKeys)}");
    //   return srcUnits[number].compareTo(dstUnits[number]);
    // })
    //     .reduce((value, element) => value + element)
    //     .toList();

    var childrenChanges = <UnitChange>[];
    srcKeys.intersection(dstKeys).where(
            (number) => !(_isLeafUnit(srcUnits[number])
            && _isLeafUnit(dstUnits[number]))).forEach((number) {
      // print("$contentKey::$number");
      // print("${srcKeys.intersection(dstKeys)}");
      childrenChanges.addAll(srcUnits[number].compareTo(dstUnits[number]));
    });
    return deletions + additions + modifications + childrenChanges;
  }

  static bool _isLeafUnit(RegulationUnit unit) {
    return leavesUnitTypeNames.contains(unit.type);
  }

  @override
  String toString() {
    if (leavesUnitTypeNames.contains(type)) {
      return element.toString();
    }
    return units.join('\n');
  }

  static List<RegulationUnit> _getDescendantUnitsByType(
      String contentKey, String type, XmlElement element) {
    var units = <RegulationUnit>[];
    var descendantTags = schema[type]!.descendants;
    for (var descendantTag in descendantTags) {
      for (var xmlElement in element.findAllElements(descendantTag)) {
        units.add(RegulationUnit.fromXmlUnit(
            contentKey, getTypeNameByTag(descendantTag), xmlElement));
      }
    }
    if (units.isEmpty &&
        type != leavesParentUnitTypeName &&
        descendantTags.isNotEmpty) {
      units = _getDescendantUnitsByType(
          contentKey, schema[getTypeNameByTag(descendantTags[0])]!.type, element);
    }
    return units;
  }
}