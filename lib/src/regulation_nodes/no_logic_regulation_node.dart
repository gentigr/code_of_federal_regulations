import 'dart:async';
// import 'dart:html';
import 'dart:io';

import 'package:code_of_federal_regulations/src/regulation_nodes/regulation_elements/code_of_federal_regulations.dart';
import 'package:code_of_federal_regulations/src/unit_change_operation.dart';
import 'package:xml/xml.dart';
import 'package:code_of_federal_regulations/src/regulation_node.dart';

// cannot have children / the node that can't be processed
class NoLogicRegulationNode extends RegulationNode {
  const NoLogicRegulationNode(XmlNode node) : super.withoutChildren(node);

  @override
  String toString() {
    return node.outerXml;
  }
}