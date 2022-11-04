// TODO: Put public facing types in this file.
import 'package:code_of_federal_regulations/src/regulation_unit.dart';
import 'package:code_of_federal_regulations/src/unit_change.dart';
import 'package:xml/xml.dart';

/// Checks if you are awesome. Spoiler: you are.
class CodeOfFederalRegulations {
  RegulationUnit content;

  CodeOfFederalRegulations(this.content);

  factory CodeOfFederalRegulations.fromXml(XmlDocument document) {
    return CodeOfFederalRegulations(RegulationUnit.fromXmlDocument(document));
  }

  factory CodeOfFederalRegulations.fromXmlString(String content) {
    return CodeOfFederalRegulations.fromXml(XmlDocument.parse(content));
  }

  List<UnitChange> compareTo(CodeOfFederalRegulations dst) {
    return content.compareTo(dst.content);
  }
}
