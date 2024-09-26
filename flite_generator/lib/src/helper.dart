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
    if (element.mixins.isEmpty) {
      throw InvalidGenerationSource(
        "The annotated class must be mixed with `FliteProvider` mixin.",
      );
    } else if (!element.mixins.any((final InterfaceType interface) {
      return interface.element.name == "FliteProvider";
    })) {
      throw InvalidGenerationSource(
        "The annotated class must be mixed with `FliteProvider` mixin.",
      );
    }
  }
}
