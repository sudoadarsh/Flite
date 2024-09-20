import 'package:analyzer/dart/element/element.dart';
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
    buffer.write("$_createTableGetter\n\n");
    buffer.write(_createRead);
    buffer.write(_createInsert);
    buffer.write(_createUpdate);
    buffer.write(_createDelete);
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
    buffer.write(
      "Future<int> insert({required InsertParameters parameters}) async {",
    );
    buffer.write("return flInsert(parameters: parameters);");
    buffer.write("}");
    return buffer.toString();
  }

  String get _createUpdate {
    final StringBuffer buffer = StringBuffer();
    buffer.write(
      "Future<int> update({required UpdateParameters parameters}) async {",
    );
    buffer.write("return flUpdate(parameters: parameters);");
    buffer.write("}");
    return buffer.toString();
  }

  String get _createDelete {
    final StringBuffer buffer = StringBuffer();
    buffer.write(
      "Future<int> delete({required DeleteParameters parameters}) async {",
    );
    buffer.write("return flDelete(parameters: parameters);");
    buffer.write("}");
    return buffer.toString();
  }
}
