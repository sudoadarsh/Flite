// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_model.dart';

// **************************************************************************
// Generator: SchemaBuilder
// **************************************************************************

extension VehicleModelFliteExtension on VehicleModel {
  /// The name of the table.
  String get table => 'VehicleModel';

  /// The SQLite schema for creating the `VehicleModel` table.
  static String get schema {
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

  /// Create the `VehicleModel` table.
  static Future<void> init(final Database database) async {
    return FliteProvider.create_(database, schema);
  }

  /// Deserializes a Json into a `VehicleModel`.
  static VehicleModel deserialize(final Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      manufacturerId: json['manufacturerId'],
      countryId: json['countryId'],
    );
  }

  /// Serializes the `VehicleModel` into Json.
  Map<String, dynamic> serialize() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'manufacturerId': manufacturerId,
      'countryId': countryId
    };
  }

  /// Inserts into the table and returns the id of the last created row.
  Future<int> insert(final InsertParameters params) async {
    return insert_(table, serialize(), params);
  }

  /// Update the rows of the table and returns the number of changes made.
  Future<int> update(final UpdateParameters params) async {
    return update_(table, serialize(), params);
  }
}
