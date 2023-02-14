import 'dart:async';
// import 'dart:html';
import 'dart:io';

import 'package:code_of_federal_regulations/src/regulation_nodes/regulation_elements/code_of_federal_regulations.dart';
import 'package:code_of_federal_regulations/src/unit_change_operation.dart';
import 'package:xml/xml.dart';
import 'package:code_of_federal_regulations/src/regulation_node.dart';


class RegulationElement extends RegulationNode {
  final XmlElement element;
  RegulationElement(this.element) : super.withChildren(element);

  @override
  String toString() {
    return element.outerXml;
  }
}