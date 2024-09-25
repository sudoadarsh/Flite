enum Operation {
  /// Automatically deletes or updates the referencing row when the referenced row is deleted or updated.
  cascade('CASCADE'),

  /// Sets the foreign key column to null when the referenced row is deleted or updated.
  setNull('SET NULL'),

  /// Sets the foreign key column to its default value when the referenced row is deleted or updated.
  setDefault('SET DEFAULT'),

  /// Prevents deletion or update of the referenced row if it has referencing rows.
  restrict('RESTRICT'),

  /// Takes no action on deletion or update of the referenced row.
  noAction('NO ACTION');

  final String value;

  const Operation(this.value);

  static Operation fromString(final String value) {
    return Operation.values.firstWhere(
      (final Operation operation) => operation.value == value,
      orElse: () => Operation.cascade,
    );
  }

  @override
  String toString() => name;
}

/// Annotation used to mark a field as a foreign key.
///
/// Allows for specifying how the foreign key relationship should behave when the
/// referenced data is updated or deleted in the parent table.
///
/// Example:
/// ```dart
/// @Foreign(
///   'posts', // References the 'posts' table.
///   'post_id', // The referenced column is 'post_id'.
///   onDelete: Operation.setNull, // On delete, set the foreign key column to null.
///   onUpdate: Operation.restrict, // On update, restrict changes.
/// )
/// final int postId;
/// ```
class Foreign {
  /// The name of the table that this field references.
  final String table;

  /// The column in the referenced table to match. If null, the annotated field name will be used.
  final String? column;

  /// Defines the action to take when the referenced row is deleted. Defaults to `CASCADE`.
  final Operation onDelete;

  /// Defines the action to take when the referenced row is updated. Defaults to `CASCADE`.
  final Operation onUpdate;

  const Foreign(
    this.table, [
    this.column,
    this.onDelete = Operation.cascade,
    this.onUpdate = Operation.cascade,
  ]);
}
