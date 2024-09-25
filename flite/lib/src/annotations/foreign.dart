enum CascadeOperation {
  cascade('CASCADE'),
  setNull('SET NULL'),
  setDefault('SET DEFAULT'),
  restrict('RESTRICT'),
  noAction('NO ACTION');

  final String value;

  const CascadeOperation(this.value);

  static CascadeOperation fromString(final String value) {
    return CascadeOperation.values.firstWhere(
      (final CascadeOperation operation) => operation.value == value,
      orElse: () => CascadeOperation.cascade,
    );
  }

  @override
  String toString() => name;
}

class Foreign {
  /// The table of be referenced.
  final String table;

  /// The column to be referenced from the [table]. If null, the annotated field name will be considered.
  final String? column;

  /// The delete cascade operation.
  final CascadeOperation onDelete;

  /// The update cascade operation.
  final CascadeOperation onUpdate;

  const Foreign(
    this.table,
    this.column, [
    this.onDelete = CascadeOperation.cascade,
    this.onUpdate = CascadeOperation.cascade,
  ]);
}
