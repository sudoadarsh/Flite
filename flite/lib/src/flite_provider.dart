import 'package:sqflite/sqlite_api.dart' show Database;

mixin FliteProvider on Object {
  /// Create the table.
  Future<void> create_(final Database database, final String schema) async {
    return database.execute(schema);
  }
}
