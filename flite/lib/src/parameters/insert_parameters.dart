import 'package:sqflite/sqlite_api.dart' show ConflictAlgorithm;

/// Parameters used for insert operation in SQLite.
class InsertParameters {
  /// Specifies the conflict resolution algorithm to use if there is a conflict
  /// when updating a row.
  final ConflictAlgorithm? conflictAlgorithm;

  /// Specifies a column to explicitly insert a NULL value when the values map is empty.
  /// It is typically used when trying to insert a completely empty row into a table.
  final String? nullColumnHack;

  InsertParameters({this.conflictAlgorithm, this.nullColumnHack});
}
