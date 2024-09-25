/// Annotation used to mark a field as the primary key.
///
/// This annotation defines a field as the primary key for the table, with options
/// to specify whether the key is required and if it should auto-increment.
///
/// By default, the primary key is required and auto-incremented.
///
/// Example usage:
/// ```dart
/// @Primary(autoIncrement: false)
/// final int id;
/// ```
/// Alternatively, you can use the global constant:
/// ```dart
/// @primary
/// final int id;
/// ```
class Primary {
  /// Whether the primary key is required (default is `true`).
  final bool required;
  // Whether the primary key auto-increments (default is `true`).
  final bool autoIncrement;
  const Primary({this.required = true, this.autoIncrement = true});
}

const Primary primary = Primary();
