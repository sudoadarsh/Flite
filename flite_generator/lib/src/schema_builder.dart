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
  String? dartClass;

  /// The table name.
  String? table;

  /// Whether fromJson method is available or not.
  bool fromJson = false;

  /// Whether toJson method is available or not.
  bool toJson = false;

  /// The tabs.
  String tabs = "\t\t";

  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    _Assertions.check(element);
    fromJson = _Assertions.fromJsonConstructorCheck(element as ClassElement);
    toJson = _Assertions.toJsonMethodCheck(element);

    dartClass = element.name.toString();
    // Set the table name.
    final ConstantReader reader = annotation.read("name");
    table = reader.isString ? reader.stringValue : dartClass;

    // The string buffer.
    final StringBuffer buffer = StringBuffer();

    // Create the enum.
    buffer.write(_createEnum(element));

    // Provider Start.
    buffer.write("class ${table?.sentence}Provider extends FliteProvider {");
    buffer.writeln("FliteDatabase? _database;\n");
    buffer.write(_createDatabaseGetter);
    buffer.writeln("$_createTableGetter\n");
    buffer.write(_createSchema(element));
    buffer.write(_createInit);
    buffer.write(_createRead);
    buffer.write(_createInsert);
    buffer.write(_createUpdate);
    buffer.write(_createDelete);
    buffer.write(_createTransaction);
    // Provider End.
    buffer.write("}");
    return buffer.toString();
  }

  String _createEnum(final ClassElement element) {
    final StringBuffer buffer = StringBuffer();
    buffer.write("enum ${table?.sentence}Keys {");
    final List<FieldElement> fields = element.fields;
    for (int index = 0; index < fields.length; index++) {
      buffer.write(
        "${fields[index].name}${index != (fields.length - 1) ? "," : ""}",
      );
    }
    buffer.write("}");
    return buffer.toString();
  }

  String get _createDatabaseGetter {
    final StringBuffer buffer = StringBuffer();
    buffer.writeln("@override");
    buffer.write("FliteDatabase get database {");
    buffer.write(
      "assert(_database != null, 'Initialize the ${table?.sentence}Provider.');",
    );
    buffer.write("return _database!; }");
    return buffer.toString();
  }

  String _createSchema(final ClassElement element) {
    // The primary key checker.
    const TypeChecker primaryKeyChecker = TypeChecker.fromRuntime(PrimaryKey);
    // The ignore key checker.
    const TypeChecker ignoreKey = TypeChecker.fromRuntime(IgnoreKey);
    // The foreign key checker.
    const TypeChecker foreignKeyChecker = TypeChecker.fromRuntime(ForeignKey);

    // The string buffer.
    final StringBuffer buffer = StringBuffer();
    buffer.writeln("@override");
    buffer.write("String get schema {");
    buffer.write("return '''CREATE TABLE IF NOT EXISTS $table(");

    final Map<String, ForeignKey> foreignKeys = <String, ForeignKey>{};

    final List<FieldElement> fields = element.fields;
    for (int index = 0; index < fields.length; index++) {
      final FieldElement field = fields.elementAt(index);
      // Don't consider the field if annotated with IgnoreKey.
      if (ignoreKey.hasAnnotationOfExact(field)) continue;

      buffer.write("\n$tabs${field.name} ");
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
        foreignKeys[field.name] = ForeignKey(
          table!,
          column,
          CascadeOperation.values.elementAt(_enumIndex(onDelete)),
          CascadeOperation.values.elementAt(_enumIndex(onUpdate)),
        );
      }
      if (isRequired) buffer.write(" NOT NULL");
      if (index != fields.length - 1) buffer.write(",");
    }

    if (foreignKeys.isNotEmpty) {
      buffer.writeln(",");
      for (int index = 0; index < foreignKeys.length; index++) {
        if (index != 0) buffer.write(",\n");
        final MapEntry<String, ForeignKey> entry;
        entry = foreignKeys.entries.elementAt(index);
        buffer.write("${tabs}FOREIGN KEY (${entry.key})");
        buffer.write(" REFERENCES ${entry.value.table}(${entry.value.column})");
        buffer.write(
          " ON DELETE ${entry.value.onDelete.value} ON UPDATE ${entry.value.onUpdate.value}",
        );
      }
    }

    buffer.write("\n$tabs''';}");
    return buffer.toString();
  }

  String get _createInit {
    final StringBuffer buffer = StringBuffer();
    buffer.write("Future<void> init(final FliteDatabase database) async {");
    buffer.write("await flInit(database);");
    buffer.write("_database = database;");
    buffer.write("return; }");
    return buffer.toString();
  }

  String get _createTableGetter {
    final StringBuffer buffer = StringBuffer();
    buffer.writeln("@override");
    buffer.write("String get table => '$table';");
    return buffer.toString();
  }

  String get _createRead {
    final StringBuffer buffer = StringBuffer();
    if (fromJson) {
      buffer.write(
        "Future<List<$dartClass>> read({required ReadParameters parameters}) async {",
      );
      buffer.write(
        "final List<Map<String, dynamic>> data = await flRead(parameters: parameters,);",
      );
      buffer.write(
        "return data.map((final Map<String, dynamic> json) => $dartClass.fromJson(json)).toList();",
      );
    } else {
      buffer.write(
        "Future<List<Map<String, dynamic>>> read({required ReadParameters parameters,}) async {",
      );
      buffer.write("return flRead(parameters: parameters);");
    }

    buffer.write("}");
    return buffer.toString();
  }

  String get _createInsert {
    final StringBuffer buffer = StringBuffer();
    if (toJson) {
      buffer.write(
        "Future<int> insert({required $dartClass data, ConflictAlgorithm? conflictAlgorithm, String? nullColumnHack,}) async {",
      );
    } else {
      buffer.write(
        "Future<int> insert({required Map<String, dynamic> json, ConflictAlgorithm? conflictAlgorithm, String? nullColumnHack,}) async {",
      );
    }
    buffer.write(
      "return flInsert(json: ${toJson ? 'data.toJson()' : 'json'}, conflictAlgorithm: conflictAlgorithm, nullColumnHack: nullColumnHack,);",
    );
    buffer.write("}");
    return buffer.toString();
  }

  String get _createUpdate {
    final StringBuffer buffer = StringBuffer();
    if (toJson) {
      buffer.write(
        "Future<int> update({required $dartClass data, String? where, List<Object?>? whereArgs, ConflictAlgorithm? conflictAlgorithm,}) async {",
      );
    } else {
      buffer.write(
        "Future<int> update({required Map<String, dynamic> json, String? where, List<Object?>? whereArgs, ConflictAlgorithm? conflictAlgorithm,}) async {",
      );
    }
    buffer.write(
      "return flUpdate(json: ${toJson ? 'data.toJson()' : 'json'}, where: where, whereArgs: whereArgs, conflictAlgorithm: conflictAlgorithm,);",
    );
    buffer.write("}");
    return buffer.toString();
  }

  String get _createDelete {
    final StringBuffer buffer = StringBuffer();
    buffer.write(
      "Future<int> delete({String? where, List<Object?>? whereArgs}) async {",
    );
    buffer.write("return flDelete(where: where, whereArgs: whereArgs);");
    buffer.write("}");
    return buffer.toString();
  }

  String get _createTransaction {
    final StringBuffer buffer = StringBuffer();
    // The generic type.
    final String? genericType = toJson ? dartClass : "Map<String, dynamic>";
    buffer.write(
      "Future<void> transaction({required List<TransactionParameters<$genericType>> parameters,}) async {",
    );
    buffer.write("return await database.transaction((txn) async {");
    buffer.write(
      "for (final TransactionParameters<$genericType> parameter in parameters) {",
    );
    buffer.write('''
      switch (parameter.type) {
          case TransactionType.insert:
            await txn.insert(
              table,
              ${toJson ? "parameter.data?.toJson()" : "parameter.data"}  ?? const {},
              conflictAlgorithm: parameter.conflictAlgorithm,
              nullColumnHack: parameter.nullColumnHack,
            );
          case TransactionType.update:
            await txn.update(
              table,
              ${toJson ? "parameter.data?.toJson()" : "parameter.data"}  ?? const {},
              conflictAlgorithm: parameter.conflictAlgorithm,
              where: parameter.where,
              whereArgs: parameter.whereArgs,
            );
          case TransactionType.delete:
            await txn.delete(
              table,
              where: parameter.where,
              whereArgs: parameter.whereArgs,
            );
        }
    ''');
    buffer.write("}");
    buffer.write("});}");
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
