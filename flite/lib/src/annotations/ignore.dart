/// Annotation used to mark a field to be ignored in the generated SQL create query.
///
/// When this annotation is applied to a field, the field will be excluded from
/// the generated create query. This can be useful for fields that should not be stored in the database.
///
/// Example usage:
/// ```dart
/// @Ignore()
/// final String transientData;
/// ```
/// Alternatively, you can use the global constant:
/// ```dart
/// @ignore
/// final String transientData;
/// ```
class Ignore {
  const Ignore();
}

const Ignore ignore = Ignore();
