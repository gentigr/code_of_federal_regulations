import 'dart:async';
// import 'dart:html';
import 'dart:io';

import 'package:code_of_federal_regulations/src/regulation_nodes/regulation_elements/appendix.dart';
import 'package:code_of_federal_regulations/src/regulation_nodes/regulation_elements/chapter.dart';
import 'package:code_of_federal_regulations/src/regulation_nodes/regulation_elements/code_of_federal_regulations.dart';
import 'package:code_of_federal_regulations/src/regulation_nodes/no_logic_regulation_node.dart';
import 'package:code_of_federal_regulations/src/regulation_nodes/regulation_element.dart';
import 'package:code_of_federal_regulations/src/regulation_nodes/regulation_document.dart';
import 'package:code_of_federal_regulations/src/regulation_nodes/regulation_elements/part.dart';
import 'package:code_of_federal_regulations/src/regulation_nodes/regulation_elements/section.dart';
import 'package:code_of_federal_regulations/src/regulation_nodes/regulation_elements/subchapter.dart';
import 'package:code_of_federal_regulations/src/regulation_nodes/regulation_elements/subject_group.dart';
import 'package:code_of_federal_regulations/src/regulation_nodes/regulation_elements/subpart.dart';
import 'package:code_of_federal_regulations/src/regulation_nodes/regulation_elements/subtitle.dart';
import 'package:code_of_federal_regulations/src/regulation_nodes/regulation_elements/title.dart';
import 'package:code_of_federal_regulations/src/unit_change_operation.dart';
import 'package:xml/xml.dart';

class RegulationNode {
  final XmlNode node;
  final List<RegulationNode> children;

  const RegulationNode(this.node, this.children);

  const RegulationNode.withoutChildren(XmlNode node) : this(node, const []);

  RegulationNode.withChildren(XmlNode node)
      : this(node, _collectRegulationNodes(node.children));

  factory RegulationNode.fromXmlNode(XmlNode node) {
    switch (node.nodeType) {
      case XmlNodeType.ELEMENT:
        return RegulationNode.fromXmlElement(node as XmlElement);
      case XmlNodeType.DOCUMENT:
        return RegulationNode.fromXmlDocument(node as XmlDocument);
      default:
        return NoLogicRegulationNode(node);
    }
  }

  factory RegulationNode.fromXmlElement(XmlElement element) {
    print(element.name.toString());
    // print(element.attributes);
    switch (element.name.toString()) {
      case 'ECFR':
        return CodeOfFederalRegulations.fromXmlElement(element);
      case 'DIV1':
        return Title.fromXmlElement(element);
      case 'DIV2':
        return Subtitle.fromXmlElement(element);
      case 'DIV3':
        return Chapter.fromXmlElement(element);
      case 'DIV4':
        return Subchapter.fromXmlElement(element);
      case 'DIV5':
        return Part.fromXmlElement(element);
      case 'DIV6':
        return Subpart.fromXmlElement(element);
      case 'DIV7':
        return SubjectGroup.fromXmlElement(element);
      case 'DIV8':
        return Section.fromXmlElement(element);
      case 'DIV9':
        return Appendix.fromXmlElement(element);
      default:
        return RegulationElement(element);
    }
  }

  factory RegulationNode.fromXmlDocument(XmlDocument document) {
    return RegulationDocument.fromXmlDocument(document);
  }

  @override
  String toString() {
    return children.join();
  }

  static List<RegulationNode> _collectRegulationNodes(List<XmlNode> nodes) {
    return nodes
        .where((p0) => !_containsOnlySpecialSymbols(p0))
        .map((e) => RegulationNode.fromXmlNode(e))
        .toList();
  }

  static bool _containsOnlySpecialSymbols(XmlNode node) {
    return node.toString().replaceAll('\n', '').isEmpty;
  }
}
