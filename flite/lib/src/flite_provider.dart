import 'package:flite/flite.dart';
import 'package:sqflite/sqlite_api.dart';

abstract class FliteProvider {
  /// The name of the table.
  String get table;

  /// The database.
  FliteDatabase get database => Flite.database;

  /// Read from the table.
  Future<List<Map<String, dynamic>>> flRead({
    required ReadParameters parameters,
  }) async {
    return database.query(
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
    return database.insert(
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
    return database.update(
      table,
      json,
      where: where,
      whereArgs: whereArgs,
      conflictAlgorithm: conflictAlgorithm,
    );
  }

  /// Deletes row from the table and returns the number of rows affected.
  Future<int> flDelete({String? where, List<Object?>? whereArgs}) async {
    return database.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<void> tx<T extends Object>({
    required List<TransactionParameters<T>> parameters,
  }) async {
    return await database.transaction((final Transaction txn) async {
      for (final TransactionParameters parameter in parameters) {
        switch (parameter.type) {
          case TransactionType.insert:
            await txn.insert(
              table,
              parameter.data as Map<String, dynamic>,
              conflictAlgorithm: parameter.conflictAlgorithm,
              nullColumnHack: parameter.nullColumnHack,
            );
          case TransactionType.update:
            await txn.update(
              table,
              parameter.data as Map<String, dynamic>,
              conflictAlgorithm: parameter.conflictAlgorithm,
              where: parameter.where,
              whereArgs: parameter.whereArgs,
            );
          case TransactionType.delete:
            await txn.delete(
              table,
              where: parameter.where,
              whereArgs: parameter.whereArgs,
            );
        }
      }
    });
  }
}
