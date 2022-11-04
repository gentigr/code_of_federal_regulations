import 'package:code_of_federal_regulations/src/unit_change.dart';
import 'package:code_of_federal_regulations/src/unit_descriptor.dart';
import 'package:code_of_federal_regulations/src/xml_parse_utils.dart';
import 'package:xml/xml.dart';

class RegulationUnit {
  // fields
  String key;

  String type;
  XmlElement element;
  var units = <RegulationUnit>[];

  // getters/setters
  String get number {
    return key.substring(key.lastIndexOf(':'));
  }

  // constructors
  RegulationUnit(this.key, this.type, this.units, this.element);

  factory RegulationUnit.fromXmlDocument(XmlDocument document) {
    var element = XmlParseUtils.getRequiredChild(document, cfrDocumentHeadTag);
    var typeName = getTypeNameByTag(cfrDocumentHeadTag);
    var units = _getDescendantUnitsByType(cfrGlobalPrefix, typeName, element);
    return RegulationUnit(cfrGlobalPrefix, typeName, units, element);
  }

  factory RegulationUnit.fromXmlUnit(
      String parentKey, String type, XmlElement element) {
    String number = XmlParseUtils.getRequiredAttr(element, 'N');
    String key = "$parentKey::$number";
    var units = _getDescendantUnitsByType(key, type, element);
    return RegulationUnit(key, type, units, element);
  }

  // methods/functions
  List<UnitChange> compareTo(RegulationUnit dst) {
    var srcUnits = _numberToRegulationUnitMap(units);
    var dstUnits = _numberToRegulationUnitMap(dst.units);

    var srcKeys = srcUnits.keys.toSet();
    var dstKeys = dstUnits.keys.toSet();

    // check for deleted sections
    var deletions = srcKeys
        .difference(dstKeys)
        .map((n) => UnitChange.fromDeletion(srcUnits[n]))
        .toList();

    // check for added sections
    var additions = dstKeys
        .difference(srcKeys)
        .map((n) => UnitChange.fromAddition(dstUnits[n]))
        .toList();

    // compare existing sections
    // TODO: handle case when section becomes descendant
    // TODO: handle case when section becomes parent
    // TODO: handle case when section moves around
    var modifications = srcKeys
        .intersection(dstKeys)
        // pick leaf unit which is eligible for content comparison
        .where((n) => _isLeafUnit(srcUnits[n]!) && _isLeafUnit(dstUnits[n]!))
        // pick unit which has content differences
        .where((n) => _isContentDifferent(srcUnits[n]!, dstUnits[n]!))
        .map((n) => UnitChange.fromModification(srcUnits[n], dstUnits[n]))
        .toList();

    var childrenChanges =
        _collectDescendantChanges(srcKeys, dstKeys, srcUnits, dstUnits);

    return deletions + additions + modifications + childrenChanges;
  }

  @override
  String toString() {
    if (leavesUnitTypeNames.contains(type)) {
      return element.toString();
    }
    return units.join('\n');
  }

  static List<RegulationUnit> _getDescendantUnitsByType(
      String key, String type, XmlElement element) {
    var units = <RegulationUnit>[];
    var descendantTags = schema[type]!.descendants;
    for (var descendantTag in descendantTags) {
      for (var xmlElement in element.findAllElements(descendantTag)) {
        units.add(RegulationUnit.fromXmlUnit(
            key, getTypeNameByTag(descendantTag), xmlElement));
      }
    }
    if (units.isEmpty &&
        type != leavesParentUnitTypeName &&
        descendantTags.isNotEmpty) {
      units = _getDescendantUnitsByType(
          key, schema[getTypeNameByTag(descendantTags[0])]!.type, element);
    }
    return units;
  }

  static bool _isContentDifferent(RegulationUnit src, RegulationUnit dst) {
    return src.element.toString().compareTo(dst.element.toString()) != 0;
  }

  static Map<String, RegulationUnit> _numberToRegulationUnitMap(
      List<RegulationUnit> units) {
    return {for (var u in units) u.number: u};
  }

  static List<UnitChange> _collectDescendantChanges(
      Set<String> srcKeys,
      Set<String> dstKeys,
      Map<String, RegulationUnit> srcUnits,
      Map<String, RegulationUnit> dstUnits) {
    var childrenChanges = <UnitChange>[];
    srcKeys
        .intersection(dstKeys)
        .where((number) =>
            !(_isLeafUnit(srcUnits[number]!) && _isLeafUnit(dstUnits[number]!)))
        .forEach((number) {
      // intermediate node, proceed recursively deeper
      childrenChanges.addAll(srcUnits[number]!.compareTo(dstUnits[number]!));
    });
    return childrenChanges;
  }

  static bool _isLeafUnit(RegulationUnit unit) {
    return leavesUnitTypeNames.contains(unit.type);
  }
}
