import 'package:xml/xml.dart';

class XmlParseUtils {
  static String getRequiredAttr(XmlElement element, String name) {
    String? attribute = element.getAttribute(name);
    if (attribute == null) {
      throw XmlParserException("${element.name} must have '$name' attribute");
    }
    return attribute;
  }

  static XmlElement getRequiredChild(XmlDocument document, String name) {
    XmlElement? element = document.getElement(name);
    if (element == null) {
      throw XmlParserException("The XML document must have '$name' child");
    }
    return element;
  }
}
