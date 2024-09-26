import 'package:sqflite/sqlite_api.dart' show ConflictAlgorithm;

/// Parameters for updating data in SQLite.
class UpdateParameters {
  /// The WHERE clause to filter which rows to update.
  final String? where;

  /// Arguments for the WHERE clause.
  final List<Object?>? whereArgs;

  /// Specifies the conflict resolution algorithm to use if there is a conflict
  /// when updating a row.
  final ConflictAlgorithm? conflictAlgorithm;

  UpdateParameters({this.where, this.whereArgs, this.conflictAlgorithm});
}
