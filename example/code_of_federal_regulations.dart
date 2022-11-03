import 'package:code_of_federal_regulations/src/code_of_federal_regulations.dart';
import 'package:code_of_federal_regulations/src/regulation_unit.dart';
import 'package:code_of_federal_regulations/src/unit_descriptor.dart';
import 'package:xml/xml.dart';
import 'package:diff_match_patch/diff_match_patch.dart';

import 'dart:io';
import 'dart:async';

void main() async {
  Future<CodeOfFederalRegulations> ecfr20220916 = File('/tmp/title-14-at-2022-09-16.xml').readAsString().then((String contents) {
    return parse(contents);
  });
  Future<CodeOfFederalRegulations> ecfr20221017 = File('/tmp/title-14-at-2022-10-17.xml').readAsString().then((String contents) {
    return parse(contents);
  });
  compare(await ecfr20220916, await ecfr20221017);
}

void compare(CodeOfFederalRegulations src, CodeOfFederalRegulations dst) {
  compareUnit("", src.content, dst.content);
}

void compareUnit(String keyPrefix, RegulationUnit src, RegulationUnit dst) {
  var srcMap = {for (var u in src.units) u.number : u};
  var dstMap = {for (var u in dst.units) u.number : u};

  var srcSet = srcMap.keys.toSet();
  var dstSet = dstMap.keys.toSet();

  // check for deleted sections
  var deleted = srcSet.difference(dstSet).forEach((number) {
    print("deleted $keyPrefix::$number");
  });

  // check for added sections
  var added = dstSet.difference(srcSet).forEach((number) {
    print("added $keyPrefix::$number");
  });

  // compare existing sections
  // TODO: handle case when section becomes descendant
  // TODO: handle case when section becomes parent
  // TODO: handle case when section moves around
  srcSet.intersection(dstSet).forEach((number) {
    if (leavesUnitTypeNames.contains(srcMap[number].type) &&
        leavesUnitTypeNames.contains(dstMap[number].type)) {
      // end node / leave to compare content
      if (srcMap[number].element.toString().compareTo(dstMap[number].element.toString()) != 0) {
        print("modified: $keyPrefix::$number");
        DiffMatchPatch dmp = DiffMatchPatch();
        List<Diff> d = dmp.diff(srcMap[number].element.toString(), dstMap[number].element.toString());
        // List<Diff> d = dmp.diff('Hello World.', 'Goodbye World.');
        // Result: [(-1, "Hell"), (1, "G"), (0, "o"), (1, "odbye"), (0, " World.")]
        dmp.diffCleanupSemantic(d);
        // Result: [(-1, "Hello"), (1, "Goodbye"), (0, " World.")]
        print(d);
      }
    } else {
      // intermediate node, proceed recursively deeper
      compareUnit("$keyPrefix::$number", srcMap[number], dstMap[number]);
    }
  });
}

String getRequiredAttr(XmlElement element, String name) {
  String? attribute = element.getAttribute(name);
  if (attribute == null) {
    throw XmlParserException("${element.name} must have '$name' attribute");
  }
  return attribute;
}


CodeOfFederalRegulations parse(String content) {
  var ecfr = CodeOfFederalRegulations.fromString(content);
  print(ecfr.content.units[0].toString().substring(0, 50));
  return ecfr;
}
