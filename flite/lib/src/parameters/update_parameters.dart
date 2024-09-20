import 'package:sqflite/sqlite_api.dart';

class UpdateParameters {
  /// The data to be recorded.
  final Map<String, dynamic> json;

  /// Insert or update conflict resolver.
  final ConflictAlgorithm? conflictAlgorithm;

  /// The clause to apply when updating. Passing null will update all rows.
  final String? where;

  /// The ?s in the where clause, which will be replaced by the values from [whereArgs].
  final List<Object>? whereArgs;

  const UpdateParameters(
      {required this.json, this.where, this.conflictAlgorithm, this.whereArgs});
}
