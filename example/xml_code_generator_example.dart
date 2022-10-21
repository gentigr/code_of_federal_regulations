import 'package:xml_code_generator/xml_code_generator.dart';
import 'package:xml/xml.dart';

import 'dart:io';
import 'dart:async';
import 'dart:convert';

void main() {
  var awesome = Awesome();
  print('awesome: ${awesome.isAwesome}');
  File('/tmp/title-34.xml').readAsString().then((String contents) {
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

class SubTitle {
  // fields
  String number;
  XmlElement element;

  // getters/setters

  // constructors
  SubTitle(this.number, this.element);

  factory SubTitle.empty(XmlElement element) {
    return SubTitle("", element);
  }

  factory SubTitle.fromXml(XmlElement element) {
    String number = getMustHaveAttr(element, "N");
    return SubTitle(number, element);
  }

  // methods/functions
  @override
  String toString() {
    return element.toString();
  }
}

class Title {
  // fields
  int number;
  var subTitles = [];

  // getters/setters

  // constructors
  Title(this.number, this.subTitles);

  factory Title.fromXml(XmlElement element) {
    int number = int.parse(getMustHaveAttr(element, "N"));
    var subTitles = [];
    for(var subTitleElement in element.findAllElements("DIV2")) {
      subTitles.add(SubTitle.fromXml(subTitleElement));
    }
    if (subTitles.isEmpty) {
      subTitles.add(SubTitle.empty(element));
    }
    return Title(number, subTitles);
  }

  // methods/functions
  @override
  String toString() {
    return subTitles.join("\n");
  }
}

class CodeOfFederalRegulations {
  var titles = [];

  CodeOfFederalRegulations(XmlElement element) {
    for(var titleElement in element.findAllElements("DIV1")) {
      titles.add(Title.fromXml(titleElement));
    }
  }

  factory CodeOfFederalRegulations.fromString(String content) {
    final document = XmlDocument.parse(content);
    return CodeOfFederalRegulations(document.getElement("ECFR")!);
  }
}

void parse(String content) {
  var ecfr = CodeOfFederalRegulations.fromString(content);
  print(ecfr.titles[0].toString().substring(0, 200));
}