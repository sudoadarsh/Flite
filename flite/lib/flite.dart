library flite;

export 'src/annotations/ignore_field.dart';
export 'src/annotations/primary_key.dart';
export 'src/annotations/schema.dart';
export 'src/annotations/from_json.dart';
export 'src/annotations/to_json.dart';

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
