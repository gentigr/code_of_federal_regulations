import 'dart:async';
// import 'dart:html';
import 'dart:io';

import 'package:code_of_federal_regulations/src/regulation_nodes/regulation_elements/code_of_federal_regulations.dart';
import 'package:code_of_federal_regulations/src/unit_change_operation.dart';
import 'package:xml/xml.dart';
import 'package:code_of_federal_regulations/src/regulation_node.dart';


class RegulationDocument extends RegulationNode {
  final XmlDocument document;
  // final List<RegulationNode> parts;

  RegulationDocument(this.document) : super.withChildren(document);

  factory RegulationDocument.fromXmlDocument(XmlDocument document) {
    // return RegulationDocument(document, document.children
    //     .where((p0) => !containsOnlySpecialSymbols(p0))
    //     .map((e) => RegulationNode.fromXmlNode(e))
    //     .toList());
    return RegulationDocument(document);
  }

// @override
// String toString() {
//   return children.join();
// }
}