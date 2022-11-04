import 'dart:async';
import 'dart:io';

import 'package:code_of_federal_regulations/src/code_of_federal_regulations.dart';
import 'package:code_of_federal_regulations/src/unit_change_operation.dart';

void main() async {
  Future<CodeOfFederalRegulations> ecfr20220916 =
      File('/tmp/title-14-at-2022-09-16.xml')
          .readAsString()
          .then((String contents) {
    return parse(contents);
  });
  Future<CodeOfFederalRegulations> ecfr20221017 =
      File('/tmp/title-14-at-2022-10-17.xml')
          .readAsString()
          .then((String contents) {
    return parse(contents);
  });
  (await ecfr20220916).compareTo(await ecfr20221017).forEach((change) {
    if (change.operation == UnitChangeOperation.modification) {
      print("${change.operation}: ${change.dst!.key}");
    } else if (change.operation == UnitChangeOperation.deletion) {
      print("${change.operation}: ${change.src!.key}");
    } else if (change.operation == UnitChangeOperation.addition) {
      print("${change.operation}: ${change.dst!.key}");
    }
  });
}

CodeOfFederalRegulations parse(String content) {
  var ecfr = CodeOfFederalRegulations.fromXmlString(content);
  print(ecfr.content.units[0].toString().substring(0, 50));
  return ecfr;
}
