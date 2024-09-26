// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_model.dart';

// **************************************************************************
// Generator: SchemaBuilder
// **************************************************************************

extension VehicleModelFliteExtension on VehicleModel {
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

  static VehicleModel deserialize(final Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      manufacturerId: json['manufacturerId'],
      countryId: json['countryId'],
    );
  }

  Map<String, dynamic> serialize() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'manufacturerId': manufacturerId,
      'countryId': countryId
    };
  }
}
