
class UnitDescriptor {
  String type;
  String tag;
  var descendants = <String>[];
  UnitDescriptor(this.type, this.tag, this.descendants);
}

var unitTypes = [
  UnitDescriptor('CFR', 'ECFR', ['DIV1']),
  UnitDescriptor('TITLE', 'DIV1', ['DIV2']),
  UnitDescriptor('SUBTITLE', 'DIV2', ['DIV3']),
  UnitDescriptor('CHAPTER', 'DIV3', ['DIV4']),
  UnitDescriptor('SUBCHAPTER', 'DIV4', ['DIV5']),
  UnitDescriptor('PART', 'DIV5', ['DIV6']),
  UnitDescriptor('SUBPART', 'DIV6', ['DIV7']),
  UnitDescriptor('SUBJGRP', 'DIV7', ['DIV8', 'DIV9']),
  UnitDescriptor('SECTION', 'DIV8', []),
  UnitDescriptor('APPENDIX', 'DIV9', [])
];

const cfrDocumentHeadTag = 'ECFR';

const cfrGlobalPrefix = 'cfr';

var leavesUnitTypeNames = ['SECTION', 'APPENDIX'];
var leavesParentUnitTypeName = 'SUBJGRP';

var schema = {for (var e in unitTypes) e.type: e};

String getTypeNameByTag(String tag) {
  return unitTypes.firstWhere((element) => element.tag == tag).type;
}