import 'package:flite/src/parameters/insert_parameters.dart';
import 'package:flite/src/parameters/update_parameters.dart';
import 'package:sqflite/sqlite_api.dart' show Database;

/// Mix your Schema Dart class with this.
mixin FliteProvider on Object {
  /// The database.
  static Database? _db;

  /// Create the table.
  static Future<void> create_(final Database db, final String schema) async {
    if (_db != null) return;
    await db.execute(schema);
    _db = db;
  }

  /// Insert into the table.
  Future<int> insert_(
    final String table,
    final Map<String, dynamic> json,
    final InsertParameters params,
  ) {
    _assert;
    return _db!.insert(
      table,
      json,
      conflictAlgorithm: params.conflictAlgorithm,
      nullColumnHack: params.nullColumnHack,
    );
  }

  /// Update the table.
  Future<int> update_(
    final String table,
    final Map<String, dynamic> json,
    final UpdateParameters params,
  ) {
    _assert;
    return _db!.update(
      table,
      json,
      conflictAlgorithm: params.conflictAlgorithm,
      where: params.where,
      whereArgs: params.whereArgs,
    );
  }

  /// Assertions.
  void get _assert {
    assert(_db != null, "Call the `init()` method before performing CRUD.");
  }
}
