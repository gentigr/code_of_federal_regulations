import 'package:xml_code_generator/xml_code_generator.dart';
import 'package:xml/xml.dart';

import 'dart:io';
import 'dart:async';
import 'dart:convert';

void main() {
  var awesome = Awesome();
  print('awesome: ${awesome.isAwesome}');
  File('/tmp/title-34.xml').readAsString().then((String contents) {
    parse(contents);
  });
}

String getRequiredAttr(XmlElement element, String name) {
  String? attribute = element.getAttribute(name);
  if (attribute == null) {
    throw XmlParserException("${element.name} must have '$name' attribute");
  }
  return attribute;
}

class UnitDescriptor {
  String type;
  String tag;
  var descendants = <String>[];
  UnitDescriptor(this.type, this.tag, this.descendants);
}

var unitTypes = [
  UnitDescriptor('CFR', 'ECFR', ['DIV1']),
  UnitDescriptor('TITLE', 'DIV1', ['DIV2']),
  UnitDescriptor('SUBTITLE', 'DIV2', ['DIV3']),
  UnitDescriptor('CHAPTER', 'DIV3', ['DIV4']),
  UnitDescriptor('SUBCHAPTER', 'DIV4', ['DIV5']),
  UnitDescriptor('PART', 'DIV5', ['DIV6']),
  UnitDescriptor('SUBPART', 'DIV6', ['DIV7']),
  UnitDescriptor('SUBJGRP', 'DIV7', ['DIV8', 'DIV9']),
  UnitDescriptor('SECTION', 'DIV8', []),
  UnitDescriptor('APPENDIX', 'DIV9', [])
];

var leavesUnitTypeNames = ['SECTION', 'APPENDIX'];
var leavesParentUnitTypeName = 'SUBJGRP';

var schema = {for (var e in unitTypes) e.type: e};

String getTypeNameByTag(String tag) {
  return unitTypes.firstWhere((element) => element.tag == tag).type;
}

class RegulationUnit {
  // fields
  RegulationUnit? parent;

  String type;
  XmlElement element;
  var units = [];

  // getters/setters

  // constructors
  RegulationUnit(this.parent, this.type, this.units, this.element);

  factory RegulationUnit.fromXml(
      RegulationUnit? parent, String type, XmlElement element) {
    var units = _getDescendantUnitsByType(parent, type, element);
    return RegulationUnit(parent, type, units, element);
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

class CodeOfFederalRegulations {
  RegulationUnit content;

  CodeOfFederalRegulations(this.content);

  factory CodeOfFederalRegulations.fromString(String content) {
    final document = XmlDocument.parse(content);
    var element = document.getElement("ECFR")!;
    return CodeOfFederalRegulations(
        RegulationUnit.fromXml(null, "CFR", element));
  }
}

void parse(String content) {
  var ecfr = CodeOfFederalRegulations.fromString(content);
  print(ecfr.content.units[0].toString().substring(0, 50));
}
