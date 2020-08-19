import 'package:meta/meta.dart';
import 'package:route_pattern/route_pattern.dart';
import 'package:test/test.dart';

class ExampleRouteArguments {
  final String requiredExample;
  final String optionalExample1;
  final String optionalExample2;
  ExampleRouteArguments(
      {@required this.requiredExample,
      this.optionalExample1,
      this.optionalExample2});
}

class ExampleRoute extends RouteMatcher<ExampleRouteArguments> {
  @override
  String build(ExampleRouteArguments args) {
    return RouteMatcher.buildPath([
      "test",
      args.requiredExample,
    ], {
      "optionalExample1": args.optionalExample1,
      "optionalExample2": args.optionalExample2,
    });
  }

  @override
  MatchResult<ExampleRouteArguments> match(String path) {
    final parsed = ParsedRoute.fromPath(path);
    if (parsed.requiredCount != 2 || parsed.required(0) != "test") {
      return MatchResult.fail(this);
    }

    return MatchResult.success(
        this,
        ExampleRouteArguments(
          requiredExample: parsed.required(1),
          optionalExample1: parsed.optional("optionalExample1"),
          optionalExample2: parsed.optional("optionalExample2"),
        ));
  }
}

class ExampleRouteArguments2 {
  ExampleRouteArguments2();
}

class ExampleRoute2 extends RouteMatcher<ExampleRouteArguments2> {
  @override
  String build(ExampleRouteArguments2 args) {
    return RouteMatcher.buildPath(["test"]);
  }

  @override
  MatchResult<ExampleRouteArguments2> match(String path) {
    final parsed = ParsedRoute.fromPath(path);
    if (parsed.requiredCount != 1 || parsed.required(0) != "test") {
      return MatchResult.fail(this);
    }

    return MatchResult.success(this, ExampleRouteArguments2());
  }
}

void main() {
  group('Example', () {
    test('doesn\'t matches an invalid url', () async {
      final route = ExampleRoute();
      final match = route.match("/test");
      expect(match.isSuccess, false);
    });
    test('matches a url', () async {
      final route = ExampleRoute();
      final match = route.match("/test/iuiu9589ifdj9?optionalExample2=true");
      expect(match.isSuccess, true);
      expect(match.arguments.requiredExample, "iuiu9589ifdj9");
      expect(match.arguments.optionalExample1, null);
      expect(match.arguments.optionalExample2, 'true');
    });
  });

  group('Router', () {
    test('matches first route', () async {
      final router = PatternRouter(routes: [
        ExampleRoute(),
        ExampleRoute2(),
      ]);

      final match = router.match("/test?optionalExample2=true");

      expect(match.route is ExampleRoute2, true);
      expect(match.isSuccess, true);
    });
    test('matches second route', () async {
      final router = PatternRouter(routes: [
        ExampleRoute(),
        ExampleRoute2(),
      ]);

      final match = router.match("/test/iuiu9589ifdj9?optionalExample2=true");

      expect(match.route is ExampleRoute, true);
      expect(match.isSuccess, true);
      expect(match.arguments.requiredExample, "iuiu9589ifdj9");
      expect(match.arguments.optionalExample1, null);
      expect(match.arguments.optionalExample2, 'true');
    });
  });
}
