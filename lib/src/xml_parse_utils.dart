import 'package:xml/xml.dart';

class XmlParseUtils {
  static String getRequiredAttr(XmlElement element, String name) {
    String? attribute = element.getAttribute(name);
    if (attribute == null) {
      throw XmlParserException("${element.name} must have '$name' attribute");
    }
    return attribute;
  }
}
