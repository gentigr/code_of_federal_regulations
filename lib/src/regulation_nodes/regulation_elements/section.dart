import 'dart:async';
// import 'dart:html';
import 'dart:io';

import 'package:code_of_federal_regulations/src/regulation_nodes/regulation_elements/code_of_federal_regulations.dart';
import 'package:code_of_federal_regulations/src/unit_change_operation.dart';
import 'package:xml/xml.dart';
import 'package:code_of_federal_regulations/src/regulation_nodes/regulation_element.dart';


class Section extends RegulationElement {
  // final List<RegulationNode> parts;

  Section(XmlElement element) : super(element);

  factory Section.fromXmlElement(XmlElement element) {
    return Section(element);
    // return Title(element, element.children
    //     .where((p0) => !containsOnlySpecialSymbols(p0))
    //     .map((e) => RegulationNode.fromXmlNode(e))
    //     .toList());
  }
// @override
// String toString() {
//   // print('hi');
//   // print(element.children.length);
//   // print(element.children.map((p0) => print("t: $p0-<")));
//   return element.outerXml;
// }
}