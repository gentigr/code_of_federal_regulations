import 'package:code_of_federal_regulations/src/unit_descriptor.dart';
import 'package:xml/xml.dart';

class RegulationUnit {
  // fields
  RegulationUnit? parent;

  String number;
  String type;
  XmlElement element;
  var units = [];

  // getters/setters

  // constructors
  RegulationUnit(this.parent, this.number, this.type, this.units, this.element);

  factory RegulationUnit.fromXml(
      RegulationUnit? parent, String type, XmlElement element) {
    String number = element.getAttribute("N") ?? "";
    var units = _getDescendantUnitsByType(parent, type, element);
    return RegulationUnit(parent, number, type, units, element);
  }

  // methods/functions
  @override
  String toString() {
    if (leavesUnitTypeNames.contains(type)) {
      return element.toString();
    }
    return units.join("\n");
  }

  static List<RegulationUnit> _getDescendantUnitsByType(
      RegulationUnit? parent, String type, XmlElement element) {
    var units = <RegulationUnit>[];
    var descendantTags = schema[type]!.descendants;
    for (var descendantTag in descendantTags) {
      for (var xmlElement in element.findAllElements(descendantTag)) {
        units.add(RegulationUnit.fromXml(
            parent, getTypeNameByTag(descendantTag), xmlElement));
      }
    }
    if (units.isEmpty &&
        type != leavesParentUnitTypeName &&
        descendantTags.isNotEmpty) {
      units = _getDescendantUnitsByType(
          parent, schema[getTypeNameByTag(descendantTags[0])]!.type, element);
    }
    return units;
  }
}