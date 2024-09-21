import 'package:flite/flite.dart';
import 'package:sqflite/sqlite_api.dart';

abstract class FliteProvider {
  /// The name of the table.
  String get table;

  /// Read from the table.
  Future<List<Map<String, dynamic>>> flRead({
    required ReadParameters parameters,
  }) async {
    return Flite.database.query(
      table,
      columns: parameters.columns,
      distinct: parameters.distinct,
      where: parameters.where,
      whereArgs: parameters.whereArgs,
      groupBy: parameters.groupBy,
      having: parameters.having,
      orderBy: parameters.orderBy,
      limit: parameters.limit,
      offset: parameters.offset,
    );
  }

  /// Insert into table and returns the id of the inserted row.
  Future<int> flInsert({
    required Map<String, dynamic> json,
    ConflictAlgorithm? conflictAlgorithm,
    String? nullColumnHack,
  }) async {
    return Flite.database.insert(
      table,
      json,
      conflictAlgorithm: conflictAlgorithm,
      nullColumnHack: nullColumnHack,
    );
  }

  /// Updates the table and returns the number of changes made.
  Future<int> flUpdate({
    required Map<String, dynamic> json,
    String? where,
    List<Object?>? whereArgs,
    ConflictAlgorithm? conflictAlgorithm,
  }) {
    return Flite.database.update(
      table,
      json,
      where: where,
      whereArgs: whereArgs,
      conflictAlgorithm: conflictAlgorithm,
    );
  }

  /// Deletes row from the table and returns the number of rows affected.
  Future<int> flDelete({String? where, List<Object?>? whereArgs}) async {
    return Flite.database.delete(table, where: where, whereArgs: whereArgs);
  }
}
