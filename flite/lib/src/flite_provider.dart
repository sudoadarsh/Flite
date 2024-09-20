import 'package:flite/flite.dart';
import 'package:flite/src/parameters/insert_parameters.dart';
import 'package:flite/src/parameters/update_parameters.dart';
import 'parameters/delete_parameters.dart';
import 'parameters/read_parameters.dart';

abstract class FliteProvider {
  /// The name of the table.
  String get table;

  /// Read from the table.
  Future<List<Map<String, dynamic>>> flRead({
    required ReadParameters params,
  }) async {
    return Flite.database.query(
      table,
      columns: params.columns,
      distinct: params.distinct,
      where: params.where,
      whereArgs: params.whereArgs,
      groupBy: params.groupBy,
      having: params.having,
      orderBy: params.orderBy,
      limit: params.limit,
      offset: params.offset,
    );
  }

  /// Insert into table and returns the id of the inserted row.
  Future<int> flInsert({required InsertParameters parameters}) async {
    return Flite.database.insert(
      table,
      parameters.json,
      conflictAlgorithm: parameters.conflictAlgorithm,
      nullColumnHack: parameters.nullColumnHack,
    );
  }

  /// Updates the table and returns the number of changes made.
  Future<int> flUpdate({required UpdateParameters parameters}) {
    return Flite.database.update(
      table,
      parameters.json,
      where: parameters.where,
      whereArgs: parameters.whereArgs,
      conflictAlgorithm: parameters.conflictAlgorithm,
    );
  }

  /// Deletes row from the table and returns the number of rows affected.
  Future<int> flClear({required DeleteParameters parameters}) async {
    return Flite.database.delete(
      table,
      where: parameters.where,
      whereArgs: parameters.whereArgs,
    );
  }
}
