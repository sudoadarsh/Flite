import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:flite/flite.dart';
import 'package:source_gen/source_gen.dart';
part 'helper.dart';

class SchemaBuilder extends GeneratorForAnnotation<Schema> {
  /// The table name.
  String? table;

  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    _Assertions.check(element);

    final String dartClass = element.name.toString();
    // Set the table name.
    final ConstantReader reader = annotation.read("name");
    table = reader.isString ? reader.stringValue : dartClass;

    // The string buffer.
    final StringBuffer buffer = StringBuffer();

    // Create the enum.
    buffer.write(_createEnum(element as ClassElement));

    // Provider Start.
    buffer.write("class ${table?.sentence}Provider extends FliteProvider {");
    buffer.write("\n\n");
    buffer.write(_createTableGetter());

    buffer.write("\n\n");
    buffer.write(_createRead());
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

  String _createTableGetter() {
    final StringBuffer buffer = StringBuffer();
    buffer.writeln("@override");
    buffer.write("String get table => '$table';");
    return buffer.toString();
  }

  String _createRead() {
    final StringBuffer buffer = StringBuffer();
    buffer.write(
      "Future<List<Map<String, dynamic>>> read({required ReadParameters params,}){",
    );
    buffer.write("return flRead({params: params});");
    buffer.write("}");
    return buffer.toString();
  }
}
