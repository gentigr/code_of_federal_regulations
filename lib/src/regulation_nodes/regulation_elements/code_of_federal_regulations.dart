// TODO: Put public facing types in this file.
import 'package:code_of_federal_regulations/src/regulation_unit.dart';
import 'package:code_of_federal_regulations/src/unit_change.dart';
import 'package:xml/xml.dart';
import 'dart:async';
// import 'dart:html';
import 'dart:io';

import 'package:code_of_federal_regulations/src/regulation_nodes/regulation_elements/code_of_federal_regulations.dart';
import 'package:code_of_federal_regulations/src/unit_change_operation.dart';
import 'package:xml/xml.dart';
import 'package:code_of_federal_regulations/src/regulation_nodes/regulation_element.dart';

/// Checks if you are awesome. Spoiler: you are.
// class CodeOfFederalRegulations {
//   RegulationUnit content;
//
//   CodeOfFederalRegulations(this.content);
//
//   factory CodeOfFederalRegulations.fromXml(XmlDocument document) {
//     // print
//     return CodeOfFederalRegulations(RegulationUnit.fromXmlDocument(document));
//   }
//
//   // factory CodeOfFederalRegulations.fromXmlString(String content) {
//   //   return CodeOfFederalRegulations.fromXml(XmlDocument.parse(content));
//   // }
//
//   // List<UnitChange> compareTo(CodeOfFederalRegulations dst) {
//   //   return content.compareTo(dst.content);
//   // }
// }

class CodeOfFederalRegulations extends RegulationElement {
  // final List<RegulationNode> parts;

  CodeOfFederalRegulations(XmlElement element) : super(element);

  factory CodeOfFederalRegulations.fromXmlElement(XmlElement element) {
    return CodeOfFederalRegulations(element);
    // return CodeOfFederalRegulations(element, element.children
    // .where((p0) => !containsOnlySpecialSymbols(p0))
    // .map((e) => RegulationNode.fromXmlNode(e))
    // .toList());
  }
// @override
// String toString() {
//   // print('hi');
//   // print(element.children.length);
//   // print(element.children.map((p0) => print("t: $p0-<")));
//   return element.outerXml;
// }
}
