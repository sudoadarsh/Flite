import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:flite/flite.dart';
import 'package:source_gen/source_gen.dart';
part 'helper.dart';

class SchemaBuilder extends GeneratorForAnnotation<Schema> {
  /// The dart class.
  String? _dartClass;

  /// The table name.
  String? _table;

  /// The tabs.
  static const String _tabs = "\t\t";

  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    _Assertions.check(element);
    element as ClassElement;

    _dartClass = element.name.toString();
    // Set the table name.
    final ConstantReader reader = annotation.read("name");
    _table = reader.isString ? reader.stringValue : _dartClass;

    // The string buffer.
    final StringBuffer buffer = StringBuffer();

    // Extension Start.
    buffer.write("extension ${_dartClass}FliteExtension on $_dartClass {");
    buffer.write(_createSchema(element));
    buffer.write(_createDeserialize(element));
    buffer.write(_createSerialize(element));
    // Extension End.
    buffer.write("}");
    return buffer.toString();
  }

  /// Create the Deserialize method.
  String _createDeserialize(final ClassElement element) {
    final StringBuffer buffer = StringBuffer();
    buffer.write(
      "static $_dartClass deserialize(final Map<String, dynamic> json) {",
    );
    buffer.write("return $_dartClass(");
    for (final FieldElement field in element.fields) {
      buffer.write("${field.name} : json['${field.name}']");
      buffer.write(",");
    }
    buffer.write(");}");
    return buffer.toString();
  }

  /// Create the SQLite schema.
  String _createSchema(final ClassElement element) {
    // The primary key checker.
    const TypeChecker primaryKeyChecker = TypeChecker.fromRuntime(Primary);
    // The ignore key checker.
    const TypeChecker ignoreKey = TypeChecker.fromRuntime(Ignore);
    // The foreign key checker.
    const TypeChecker foreignKeyChecker = TypeChecker.fromRuntime(Foreign);

    // The string buffer.
    final StringBuffer buffer = StringBuffer();
    buffer.write("static String get schema {");
    buffer.write("return '''CREATE TABLE IF NOT EXISTS $_table(");

    final Map<String, Foreign> foreignKeys = <String, Foreign>{};

    final List<FieldElement> fields = element.fields;
    for (int index = 0; index < fields.length; index++) {
      final FieldElement field = fields.elementAt(index);
      // Don't consider the field if annotated with IgnoreKey.
      if (ignoreKey.hasAnnotationOfExact(field)) continue;

      buffer.write("\n$_tabs${field.name} ");
      // The sqlite type.
      final String sqliteType = _sqliteType(field.type);
      buffer.write(sqliteType);
      // Check if the field is required or not.
      final bool isRequired;
      isRequired = field.type.nullabilitySuffix != NullabilitySuffix.question;

      // Check if the field is a primary key or not.
      if (primaryKeyChecker.hasAnnotationOfExact(field)) {
        final DartObject? obj = primaryKeyChecker.firstAnnotationOfExact(field);
        final bool autoIncrement;
        autoIncrement = obj?.getField("autoIncrement")?.toBoolValue() ?? true;
        if (sqliteType != "INTEGER" && autoIncrement) {
          throw StateError(
            "Auto-increment is only applicable to primary keys of type INTEGER",
          );
        }
        buffer.write(" PRIMARY KEY${autoIncrement ? " AUTOINCREMENT" : ""}");
      } else if (foreignKeyChecker.hasAnnotationOfExact(field)) {
        final DartObject? obj = foreignKeyChecker.firstAnnotationOfExact(field);
        final String? table = obj?.getField("table")?.toStringValue();
        final String? column = obj?.getField("column")?.toStringValue();
        final DartObject? onDelete = obj?.getField("onDelete");
        final DartObject? onUpdate = obj?.getField("onUpdate");
        foreignKeys[field.name] = Foreign(
          table!,
          column,
          Operation.values.elementAt(_enumIndex(onDelete)),
          Operation.values.elementAt(_enumIndex(onUpdate)),
        );
      }
      if (isRequired) buffer.write(" NOT NULL");
      if (index != fields.length - 1) buffer.write(",");
    }

    if (foreignKeys.isNotEmpty) {
      buffer.writeln(",");
      for (int index = 0; index < foreignKeys.length; index++) {
        if (index != 0) buffer.write(",\n");
        final MapEntry<String, Foreign> entry;
        entry = foreignKeys.entries.elementAt(index);
        buffer.write("${_tabs}FOREIGN KEY (${entry.key})");
        buffer.write(" REFERENCES ${entry.value.table}(${entry.value.column})");
        buffer.write(
          " ON DELETE ${entry.value.onDelete.value} ON UPDATE ${entry.value.onUpdate.value}",
        );
      }
    }

    buffer.write("\n$_tabs''';}");
    return buffer.toString();
  }

  /// Create the Serialize method.
  String _createSerialize(final ClassElement element) {
    final StringBuffer buffer = StringBuffer();
    buffer.write("Map<String, dynamic> serialize() {");
    final Map<String, String> fields = <String, String>{};
    for (final FieldElement field in element.fields) {
      fields["'${field.name}'"] = field.name;
    }
    buffer.write("return $fields;");
    buffer.write("}");
    return buffer.toString();
  }

  /// Get the sqlite type from the dart type.
  String _sqliteType(final DartType dartType) {
    final String baseType = dartType.getDisplayString();
    final String sqliteType;
    switch (baseType) {
      case "int" || "int?":
        sqliteType = "INTEGER";
      case "String" || "String?":
        sqliteType = "TEXT";
      case "Double" || "Double?":
        sqliteType = "REAL";
      default:
        throw StateError("The dart type $dartType is unsupported.");
    }
    return sqliteType;
  }

  /// Get the enum index from DartObject.
  int _enumIndex(final DartObject? object) {
    return object?.getField("index")?.toIntValue() ?? 0;
  }
}
