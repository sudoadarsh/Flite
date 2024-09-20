class DeleteParameters {
  /// The optional WHERE clause to apply when deleting. Passing null
  /// will delete all rows.
  final String? where;

  /// The ?s in the where clause will be replaced by the values from [whereArgs].
  final List<Object?>? whereArgs;

  const DeleteParameters({this.where, this.whereArgs});
}
