library flite_generator;

import 'package:build/build.dart';
import 'package:flite_generator/src/schema_builder.dart';
import 'package:source_gen/source_gen.dart';

Builder generateJsonMethods(BuilderOptions options) {
  return SharedPartBuilder([SchemaBuilder()], 'flite');
}
