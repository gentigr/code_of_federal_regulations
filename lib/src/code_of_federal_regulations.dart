// TODO: Put public facing types in this file.
import 'package:code_of_federal_regulations/src/regulation_unit.dart';
import 'package:xml/xml.dart';

/// Checks if you are awesome. Spoiler: you are.
class CodeOfFederalRegulations {
  RegulationUnit content;

  CodeOfFederalRegulations(this.content);

  factory CodeOfFederalRegulations.fromString(String content) {
    final document = XmlDocument.parse(content);
    var element = document.getElement("ECFR")!;
    return CodeOfFederalRegulations(
        RegulationUnit.fromXml(null, "", "CFR", element));
  }

  void compareTo(CodeOfFederalRegulations dst) {
    content.compareTo("", dst.content);
  }
}