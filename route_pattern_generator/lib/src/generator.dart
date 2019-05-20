import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:source_gen/source_gen.dart';
import 'package:route_pattern/route_pattern.dart';

import 'builders.dart';
import 'parsing.dart';

class RoutePatternGenerator extends GeneratorForAnnotation<RoutePattern> {
  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    final annotatedElements = library.annotatedWith(typeChecker).toList();

    if (annotatedElements.isEmpty) return null;

    final routesBuilder = RoutesBuilder();
    var routesClass = routesBuilder.build(annotatedElements);

    final generateBuilder = OnGenerateRouteBuilder();
    var generateMethod = generateBuilder.build(annotatedElements);

    var emitter = DartEmitter();
    var source =
        '${generateMethod.accept(emitter)} ${routesClass.accept(emitter)}';

    return DartFormatter().format(source) +
        '\n\n' +
        (await super.generate(library, buildStep));
  }

  @override
  Iterable<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is FunctionElement) {
      final obj = annotation.objectValue;
      final value = obj.getField("pattern").toStringValue();
      final pattern = ParsedPattern.fromString(value);

      final argument = ArgumentBuilder().build(element.name, pattern);
      final route = RouteBuilder().build(element.name, pattern);

      var library = Library(
          (b) => b..body.addAll([argument, route])..directives.addAll([]));

      var emitter = DartEmitter();
      var source = '${library.accept(emitter)}';
      return [DartFormatter().format(source)];
    }

    throw InvalidGenerationSourceError(
        'Generator can only target top level string variables.',
        todo: 'Add the annotation on a valid top level string variable.',
        element: element);
  }
}
