// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_model.dart';

// **************************************************************************
// Generator: SchemaBuilder
// **************************************************************************

enum VehicleModelKeys { id, name, description, manufacturerId, countryId }

class VehicleModelProvider extends FliteProvider {
  FliteDatabase? _database;

  @override
  FliteDatabase get database {
    assert(_database != null, 'Initialize the VehicleModelProvider.');
    return _database!;
  }

  @override
  String get table => 'VehicleModel';

  @override
  String get schema {
    return '''CREATE TABLE IF NOT EXISTS VehicleModel(
		id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
		name TEXT NOT NULL,
		description TEXT,
		manufacturerId INTEGER,
		countryId INTEGER,
		FOREIGN KEY (manufacturerId) REFERENCES Manufacturer(id) ON DELETE CASCADE ON UPDATE RESTRICT,
		FOREIGN KEY (countryId) REFERENCES Country(id) ON DELETE CASCADE ON UPDATE CASCADE
		''';
  }

  Future<void> init(final FliteDatabase database) async {
    await flInit(database);
    _database = database;
    return;
  }

  Future<List<Map<String, dynamic>>> read({
    required ReadParameters parameters,
  }) async {
    return flRead(parameters: parameters);
  }

  Future<int> insert({
    required Map<String, dynamic> json,
    ConflictAlgorithm? conflictAlgorithm,
    String? nullColumnHack,
  }) async {
    return flInsert(
      json: json,
      conflictAlgorithm: conflictAlgorithm,
      nullColumnHack: nullColumnHack,
    );
  }

  Future<int> update({
    required Map<String, dynamic> json,
    String? where,
    List<Object?>? whereArgs,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    return flUpdate(
      json: json,
      where: where,
      whereArgs: whereArgs,
      conflictAlgorithm: conflictAlgorithm,
    );
  }

  Future<int> delete({String? where, List<Object?>? whereArgs}) async {
    return flDelete(where: where, whereArgs: whereArgs);
  }

  Future<void> transaction({
    required List<TransactionParameters<Map<String, dynamic>>> parameters,
  }) async {
    return await database.transaction((txn) async {
      for (final TransactionParameters<Map<String, dynamic>> parameter
          in parameters) {
        switch (parameter.type) {
          case TransactionType.insert:
            await txn.insert(
              table,
              parameter.data ?? const {},
              conflictAlgorithm: parameter.conflictAlgorithm,
              nullColumnHack: parameter.nullColumnHack,
            );
          case TransactionType.update:
            await txn.update(
              table,
              parameter.data ?? const {},
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
