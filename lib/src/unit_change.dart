import 'package:code_of_federal_regulations/src/regulation_unit.dart';
import 'package:diff_match_patch/diff_match_patch.dart';

class UnitChange {
  RegulationUnit? src;
  RegulationUnit? dst;
  List<Diff> changes;

  UnitChange(this.src, this.dst, this.changes);

  UnitChange.fromAddition(this.dst): src = null, changes = List.empty();

  UnitChange.fromDeletion(this.src): dst = null, changes = List.empty();
}