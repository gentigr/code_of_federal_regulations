import 'package:code_of_federal_regulations/src/unit_descriptor.dart';
import 'package:code_of_federal_regulations/src/xml_parse_utils.dart';
import 'package:xml/xml.dart';
import 'package:diff_match_patch/diff_match_patch.dart';

class RegulationUnit {
  // fields
  RegulationUnit? parent;
  String contentKey;

  String number;
  String type;
  XmlElement element;
  var units = [];

  // getters/setters

  // constructors
  RegulationUnit(this.parent, this.contentKey, this.number, this.type, this.units, this.element);

  factory RegulationUnit.fromHeadXml(XmlElement element) {
    String number = "cfr";
    String contentKey = number;
    var units = _getDescendantUnitsByType(null, contentKey, "CFR", element);
    return RegulationUnit(null, contentKey, number, "CFR", units, element);

  }

  factory RegulationUnit.fromUnitXml(
      RegulationUnit? parent, String parentContentKey, String type, XmlElement element) {
    String number = XmlParseUtils.getRequiredAttr(element, "N");
    String contentKey = "$parentContentKey::$number";
    var units = _getDescendantUnitsByType(parent, contentKey, type, element);
    return RegulationUnit(parent, contentKey, number, type, units, element);
  }

  // methods/functions
  void compareTo(String keyPrefix, RegulationUnit dst) {
    var src = this;
    var srcMap = {for (var u in src.units) u.number : u};
    var dstMap = {for (var u in dst.units) u.number : u};

    var srcSet = srcMap.keys.toSet();
    var dstSet = dstMap.keys.toSet();

    // check for deleted sections
    var deleted = srcSet.difference(dstSet).forEach((number) {
      print("deleted $keyPrefix::$number");
      print("deleted $contentKey");
    });

    // check for added sections
    var added = dstSet.difference(srcSet).forEach((number) {
      print("added $keyPrefix::$number");
      print("added ${dstMap[number].contentKey}");
    });

    // compare existing sections
    // TODO: handle case when section becomes descendant
    // TODO: handle case when section becomes parent
    // TODO: handle case when section moves around
    srcSet.intersection(dstSet).forEach((number) {
      if (leavesUnitTypeNames.contains(srcMap[number].type) &&
          leavesUnitTypeNames.contains(dstMap[number].type)) {
        // end node / leave to compare content
        if (srcMap[number].element.toString().compareTo(dstMap[number].element.toString()) != 0) {
          print("modified: $keyPrefix::$number");
          DiffMatchPatch dmp = DiffMatchPatch();
          List<Diff> d = dmp.diff(srcMap[number].element.toString(), dstMap[number].element.toString());
          // List<Diff> d = dmp.diff('Hello World.', 'Goodbye World.');
          // Result: [(-1, "Hell"), (1, "G"), (0, "o"), (1, "odbye"), (0, " World.")]
          dmp.diffCleanupSemantic(d);
          // Result: [(-1, "Hello"), (1, "Goodbye"), (0, " World.")]
          // print(d);
        }
      } else {
        // intermediate node, proceed recursively deeper
        srcMap[number].compareTo("$keyPrefix::$number", dstMap[number]);
      }
    });
  }

  @override
  String toString() {
    if (leavesUnitTypeNames.contains(type)) {
      return element.toString();
    }
    return units.join("\n");
  }

  static List<RegulationUnit> _getDescendantUnitsByType(
      RegulationUnit? parent, String contentKey, String type, XmlElement element) {
    var units = <RegulationUnit>[];
    var descendantTags = schema[type]!.descendants;
    for (var descendantTag in descendantTags) {
      for (var xmlElement in element.findAllElements(descendantTag)) {
        units.add(RegulationUnit.fromUnitXml(
            parent, contentKey, getTypeNameByTag(descendantTag), xmlElement));
      }
    }
    if (units.isEmpty &&
        type != leavesParentUnitTypeName &&
        descendantTags.isNotEmpty) {
      units = _getDescendantUnitsByType(
          parent, contentKey, schema[getTypeNameByTag(descendantTags[0])]!.type, element);
    }
    return units;
  }
}