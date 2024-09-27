/// Annotation used to define a schema for a SQLite table.
///
/// This annotation marks a Dart class as a representation of a table in the SQLite database.
/// The fields of the class will be treated as columns.
///
/// Example usage:
/// ```dart
/// @Schema(name: 'users')
/// class User with FliteProvider {
///   @primary
///   final int id;
///
///   final String name;
///
///   final int? age;
///
///   @ignore
///   String? temporaryData;
///
///   User(this.id, this.name, this.age);
/// }
/// ```
class Schema {
  /// The name of the table.
  final String? name;
  const Schema({this.name});
}
