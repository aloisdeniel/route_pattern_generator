import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:recase/recase.dart';
import 'package:source_gen/source_gen.dart';

import 'parsing.dart';

class RouteNaming {
  final ReCase _name;
  RouteNaming(String name) : this._name = ReCase(name);
  String get routeName => "${_name.pascalCase}Route";
  String get argumentName => "${_name.pascalCase}RouteArguments";
}

class RouterBuilder {
  Code build(List<AnnotatedElement> elements) {
    final body = StringBuffer("const router = const Router(routes:[");
    final routes = elements.map((x) => "Routes." + x.element.name).join(",");
    body.write(routes);
    body.write("]);");
    return Code(body.toString());
  }
}

class RoutesBuilder {
  Class build(List<AnnotatedElement> elements) {
    final builder = ClassBuilder()
      ..name = "Routes"
      ..abstract = true;

    elements.forEach((e) => builder.fields.add(Field((b) => b
      ..name = e.element.name
      ..modifier = FieldModifier.constant
      ..static = true
      ..assignment = Code(RouteNaming(e.element.name).routeName + '()'))));

    return builder.build();
  }
}

class RouteBuilder {
  Method _createMatch(ParsedPattern pattern, RouteNaming naming) {
    final body = StringBuffer();

    final conditions = ["parsed.requiredCount != ${pattern.segments.length}"]
      ..addAll(pattern.segments
          .where((x) => x is ConstantSegment)
          .cast<ConstantSegment>()
          .map((x) => 'parsed.required(${x.index}) != "${x.value}"'));

    body.write("final parsed = ParsedRoute.fromPath(path);");
    body.write(
        "if (${conditions.join(" || ")}) return MatchResult.fail(this);");
    body.write("return MatchResult.success(this,${naming.argumentName}(");

    pattern.segments
        .where((x) => x is DynamicSegment)
        .cast<DynamicSegment>()
        .forEach((x) => body.write("${x.name}: parsed.required(${x.index}),"));

    pattern.query.forEach((x) => body.write('$x: parsed.optional("$x"),'));

    body.write("));");

    return Method((m) => m
      ..name = "match"
      ..annotations.add(CodeExpression(Code("override")))
      ..returns = refer("MatchResult<${naming.argumentName}>")
      ..requiredParameters.add(Parameter((p) => p
        ..name = "path"
        ..type = refer("String")))
      ..body = Code(body.toString()));
  }

  Method _createBuild(ParsedPattern pattern, RouteNaming naming) {
    final body = StringBuffer();

    body.write("return Route.buildPath(");

    if (pattern.segments.isNotEmpty) {
      final args = pattern.segments
          .map((s) => s is ConstantSegment
              ? '"${s.value}"'
              : ("arguments." + (s as DynamicSegment).name))
          .join(",");
      body.write("[$args]");
    }

    if (pattern.query.isNotEmpty) {
      if (pattern.segments.isEmpty) body.write("[]");
      final args = pattern.query.map((n) => '"$n": arguments.$n').join(",");
      body.write(",{$args}");
    }

    body.write(");");

    return Method((m) => m
      ..name = "build"
      ..annotations.add(CodeExpression(Code("override")))
      ..returns = refer("String")
      ..requiredParameters.add(Parameter((p) => p
        ..name = "arguments"
        ..type = refer(naming.argumentName)))
      ..body = Code(body.toString()));
  }

  Class build(String name, ParsedPattern pattern) {
    final naming = RouteNaming(name);
    final builder = ClassBuilder()
      ..name = naming.routeName
      ..extend = refer("Route<${naming.argumentName}>");

    builder.constructors.add(Constructor((b) => b..constant = true));

    builder.methods.add(_createMatch(pattern, naming));
    builder.methods.add(_createBuild(pattern, naming));

    return builder.build();
  }
}

class ArgumentBuilder {
  Class build(String name, ParsedPattern pattern) {
    final naming = RouteNaming(name);
    final builder = ClassBuilder()..name = naming.argumentName;

    final constructor = ConstructorBuilder();
    pattern.segments
        .where((x) => x is DynamicSegment)
        .cast<DynamicSegment>()
        .forEach((x) => _addField(x.name, true, builder, constructor));
    pattern.query
        .forEach((name) => _addField(name, false, builder, constructor));

    builder.constructors.add(constructor.build());

    return builder.build();
  }

  void _addField(String name, bool isRequired, ClassBuilder builder,
      ConstructorBuilder constructor) {
    final parameter = ParameterBuilder()
      ..name = name
      ..named = true
      ..toThis = true;
    if (isRequired) {
      parameter.annotations.add(CodeExpression(Code("required")));
    }
    constructor.optionalParameters.add(parameter.build());

    builder.fields.add(Field((b) => b
      ..name = name
      ..type = refer("String")
      ..modifier = FieldModifier.final$));
  }
}
