library flite;

export 'src/annotations/annotations.dart';
export 'src/parameters/parameters.dart';
export 'src/flite_provider.dart';

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
