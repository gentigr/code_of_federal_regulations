enum UnitChangeOperation {
  addition(1),
  deletion(-1),
  modification(0);

  const UnitChangeOperation(this.code);

  final int code;

  @override
  String toString() {
    switch (this) {
      case UnitChangeOperation.addition:
        return '+';
      case UnitChangeOperation.deletion:
        return '-';
      case UnitChangeOperation.modification:
        return '±';
    }
  }
}
