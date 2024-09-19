part of 'schema_builder.dart';

extension StringExt on String {
  /// Sentence capitalization.
  String get sentence {
    return this[0].toUpperCase() + substring(1);
  }
}

final class _Assertions {
  static void check(final Element element) {
    if (element is! ClassElement) {
      throw InvalidGenerationSource(
        "The annotation 'Schema' can only be used on Classes",
        element: element,
      );
    }
    if (element.fields.isEmpty) {
      throw InvalidGenerationSource(
        "The annotated class must have at least one field,",
        element: element,
      );
    }
    constructorCheck(element);
    methodCheck(element);
  }

  static void constructorCheck(final ClassElement element) {
    final List<ConstructorElement> constructors = element.constructors;
    const TypeChecker fromJsonChecker = TypeChecker.fromRuntime(FromJson);
    for (final ConstructorElement constructor in constructors) {
      if (!fromJsonChecker.hasAnnotationOfExact(constructor)) continue;
      if (constructor.name != "fromJson") {
        throw InvalidGenerationSource(
          "The constructor annotated with fromJson must be named 'fromJson'.",
          element: constructor,
        );
      }
      if (constructor.parameters.length != 1) {
        throw InvalidGenerationSource(
          "The constructor annotated with fromJson must have exactly one parameter.",
          element: constructor,
        );
      }
      final ParameterElement parameter = constructor.parameters.elementAt(0);
      if (parameter.type.toString() != "Map<String, dynamic>") {
        throw InvalidGenerationSource(
          "The constructor annotated with fromJson must have Map<String, dynamic> parameter.",
          element: constructor,
        );
      }
    }
  }

  static void methodCheck(final ClassElement element) {
    final List<MethodElement> methods = element.methods;
    const TypeChecker toJsonChecker = TypeChecker.fromRuntime(ToJson);
    for (final MethodElement method in methods) {
      if (!toJsonChecker.hasAnnotationOfExact(element)) continue;
    }
  }
}
