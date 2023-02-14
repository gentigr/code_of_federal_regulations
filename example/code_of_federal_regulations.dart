import 'dart:async';
// import 'dart:html';
import 'dart:io';

import 'package:code_of_federal_regulations/src/regulation_nodes/regulation_elements/code_of_federal_regulations.dart';
import 'package:code_of_federal_regulations/src/unit_change_operation.dart';
import 'package:xml/xml.dart';

import 'package:code_of_federal_regulations/src/regulation_nodes/regulation_elements/code_of_federal_regulations.dart';
import 'package:code_of_federal_regulations/src/regulation_nodes/no_logic_regulation_node.dart';
import 'package:code_of_federal_regulations/src/regulation_nodes/regulation_element.dart';
import 'package:code_of_federal_regulations/src/regulation_nodes/regulation_document.dart';
import 'package:code_of_federal_regulations/src/regulation_nodes/regulation_elements/title.dart';
import 'package:code_of_federal_regulations/src/unit_change_operation.dart';
import 'package:xml/xml.dart';

void main() async {
  // Future<CodeOfFederalRegulations> ecfr20220916 =
  Future<void> ecfr20220916 =
      File('/tmp/title-14-at-2022-09-16-cut.xml')
          .readAsString()
          .then((String contents) {
    return parse(contents);
  });
  // Future<CodeOfFederalRegulations> ecfr20221017 =
  //     File('/tmp/title-14-at-2022-10-17.xml')
  //         .readAsString()
  //         .then((String contents) {
  //   return parse(contents);
  // });
  // (await ecfr20220916).compareTo(await ecfr20221017).forEach((change) {
  //   if (change.operation == UnitChangeOperation.modification) {
  //     print("${change.operation}: ${change.dst!.key}");
  //   } else if (change.operation == UnitChangeOperation.deletion) {
  //     print("${change.operation}: ${change.src!.key}");
  //   } else if (change.operation == UnitChangeOperation.addition) {
  //     print("${change.operation}: ${change.dst!.key}");
  //   }
  // });
}













//
// class CodeOfFederalRegulationsDocument {
//   final List<RegulationNode> parts;
//
//   const CodeOfFederalRegulationsDocument(this.parts);
//
//   factory CodeOfFederalRegulationsDocument.fromXmlDoc(XmlDocument document) {
//     print(document.nodeType);
//     return CodeOfFederalRegulationsDocument(document.children
//     .where((p0) => !containsOnlySpecialSymbols(p0))
//     .map((e) => RegulationNode.fromXmlNode(e))
//         .toList());
//   }
//
//   factory CodeOfFederalRegulationsDocument.fromXmlDocAsString(String document) {
//     return CodeOfFederalRegulationsDocument.fromXmlDoc(XmlDocument.parse(document));
//   }
//
//   @override
//   String toString() {
//     return parts.join();
//   }
// }

// CodeOfFederalRegulations
void parse(String content) {
  var xmlDocument = XmlDocument.parse(content);

  // print(xmlDocument.toXmlString(pretty: true));
  // var children = xmlDocument.children;
      // .where((p0) => !containsOnlySpecialSymbols(p0)).toList();
      // .map((e) => e.no .nodeType));
      // .map((e) => print("->${e.toString().codeUnits}<-")));
  // print((children[2] as XmlElement).name);
  // print(children[0].outerXml);

  // var container = CodeOfFederalRegulationsDocument.fromXmlDocAsString(content);
  var container = RegulationDocument.fromXmlDocument(xmlDocument);
  // print(container.toString());
  print(content.replaceAll('\n', '').compareTo(container.toString().replaceAll('\n', '')));

  // var ecfr = CodeOfFederalRegulations.fromXml(xmlDocument);
  // print(ecfr.content.units[0].toString().substring(0, 50));
  // return ecfr;
}
