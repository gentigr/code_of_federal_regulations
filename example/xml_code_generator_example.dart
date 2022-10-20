import 'package:xml_code_generator/xml_code_generator.dart';
import 'package:xml/xml.dart';

import 'dart:io';
import 'dart:async';

void main() {
  var awesome = Awesome();
  print('awesome: ${awesome.isAwesome}');
  File('/tmp/title-14.xml').readAsString().then((String contents) {
    parse(contents);
  });
}

String getMustHaveAttr(XmlElement element, String name) {
  String? attribute = element.getAttribute(name);
  if (attribute == null) {
    throw XmlParserException("${element.name} must have '$name' attribute");
  }
  return attribute;
}

class Title {
  // fields
  int number;
  XmlElement element;

  // getters/setters

  // constructors
  Title(this.number, this.element);

  factory Title.fromXml(XmlElement element) {
    int number = int.parse(getMustHaveAttr(element, "N"));
    return Title(number, element);
  }

  // methods/functions
  @override
  String toString() {
    return element.toString();
  }
}

class CodeOfFederalRegulations {
  var titles = {};

  CodeOfFederalRegulations(XmlElement element) {
    for(var titleElement in element.findAllElements("DIV1")) {
      var title = Title.fromXml(titleElement);
      titles[title.number] = title;
    }
  }

  factory CodeOfFederalRegulations.fromString(String content) {
    final document = XmlDocument.parse(content);
    return CodeOfFederalRegulations(document.getElement("ECFR")!);
  }
}

void parse(String content) {
  var ecfr = CodeOfFederalRegulations.fromString(content);
  print(ecfr.titles[14].toString().substring(0, 200));
}