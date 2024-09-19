import 'package:sqflite/sqlite_api.dart';

typedef FliteDatabase = Database;

abstract final class Flite {
  /// The database.
  static FliteDatabase get database {
    assert(
      _database != null,
      "Configure Flite before using generated Providers",
    );
    return _database!;
  }

  static FliteDatabase? _database;
}
