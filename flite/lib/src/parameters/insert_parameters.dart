import 'package:sqflite/sqlite_api.dart';

class InsertParameters {
  /// The data to be recorded.
  final Map<String, dynamic> json;

  /// Provides a way to specify a column name when inserting an empty row or when
  /// all the provided values are null.
  final String? nullColumnHack;

  /// Insert or update conflict resolver.
  final ConflictAlgorithm? conflictAlgorithm;

  InsertParameters(
      {required this.json, this.nullColumnHack, this.conflictAlgorithm});
}
