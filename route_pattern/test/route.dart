import 'package:route_pattern/route_pattern.dart';
import 'package:test/test.dart';

void main() {
  group('Building a route', () {
    test('with a no segments and query', () async {
      final result = RouteMatcher.buildPath();
      expect(result, "/");
    });

    test('with a null segments and query', () async {
      final result = RouteMatcher.buildPath(null, null);
      expect(result, "/");
    });

    test('with segments', () async {
      final result = RouteMatcher.buildPath(["example", "test"]);
      expect(result, "/example/test");
    });

    test('with encoded segments', () async {
      final result = RouteMatcher.buildPath(
          ["example", "§è4874ç'ç!('(\$'(!è\"'//\\\\", "test"]);
      expect(result,
          "/example/%C2%A7%C3%A84874%C3%A7'%C3%A7!('(%24'(!%C3%A8%22'%2F%2F%5C%5C/test");
    });

    test('with a single query parameter', () async {
      final result =
          RouteMatcher.buildPath(["example", "test"], {"oh": "yeah"});
      expect(result, "/example/test?oh=yeah");
    });

    test('with multiple query parameters', () async {
      final result = RouteMatcher.buildPath(
          ["example", "test"], {"oh": "yeah", "eh": "meh"});
      expect(
          ["/example/test?oh=yeah&eh=meh", "/example/test?eh=meh&oh=yeah"]
              .contains(result),
          true);
    });

    test('with encoded query parameters', () async {
      final result = RouteMatcher.buildPath(["example", "test"], {"§": "è"});
      expect(result, "/example/test?%C2%A7=%C3%A8");
    });
  });

  group('Route parsing', () {
    test('with an empty path', () async {
      final parsed = ParsedRoute.fromPath("");
      expect(parsed.isEmpty, true);
      expect(parsed.requiredCount, 0);
      expect(parsed.hasOptionals, false);
    });

    test('with an only a question mark', () async {
      final parsed = ParsedRoute.fromPath("?");
      expect(parsed.isEmpty, true);
      expect(parsed.requiredCount, 0);
      expect(parsed.hasOptionals, false);
    });

    test('with a static path', () async {
      final parsed = ParsedRoute.fromPath("/example/with/static/parts");
      expect(parsed.isEmpty, false);
      expect(parsed.hasOptionals, false);

      expect(parsed.requiredCount, 4);
      expect(parsed.required(0), "example");
      expect(parsed.required(1), "with");
      expect(parsed.required(2), "static");
      expect(parsed.required(3), "parts");
    });

    test('with encoded segments', () async {
      final parsed = ParsedRoute.fromPath(
          "/example/%C2%A7%C3%A84874%C3%A7%27%C3%A7%21%28%27%28%24%27%28%21%C3%A8%22%27%2F%2F%5C%5C/static");
      expect(parsed.isEmpty, false);
      expect(parsed.hasOptionals, false);

      expect(parsed.requiredCount, 3);
      expect(parsed.required(0), "example");
      expect(parsed.required(1), "§è4874ç'ç!('(\$'(!è\"'//\\\\");
      expect(parsed.required(2), "static");
    });

    test('with a single query parameter', () async {
      final parsed = ParsedRoute.fromPath("/example/test?k=v");
      expect(parsed.isEmpty, false);
      expect(parsed.hasOptionals, true);
      expect(parsed.optional("k"), "v");

      expect(parsed.requiredCount, 2);
      expect(parsed.required(0), "example");
      expect(parsed.required(1), "test");
    });

    test('with a query and trailing slash', () async {
      final parsed = ParsedRoute.fromPath("/example/test/?k=v");
      expect(parsed.isEmpty, false);
      expect(parsed.hasOptionals, true);
      expect(parsed.optional("k"), "v");

      expect(parsed.requiredCount, 2);
      expect(parsed.required(0), "example");
      expect(parsed.required(1), "test");
    });

    test('with a multiple query parameters', () async {
      final parsed = ParsedRoute.fromPath("/example/test?k=v&o=p&j=6");
      expect(parsed.isEmpty, false);
      expect(parsed.hasOptionals, true);
      expect(parsed.optional("o"), "p");
      expect(parsed.optional("k"), "v");
      expect(parsed.optional("j"), "6");

      expect(parsed.requiredCount, 2);
      expect(parsed.required(0), "example");
      expect(parsed.required(1), "test");
    });

    test('with a multiple encoded query parameters', () async {
      final parsed =
          ParsedRoute.fromPath("/example/test?k=%C2%A7%C3%A8&o=4874");
      expect(parsed.isEmpty, false);
      expect(parsed.hasOptionals, true);
      expect(parsed.optional("o"), "4874");
      expect(parsed.optional("k"), "§è");

      expect(parsed.requiredCount, 2);
      expect(parsed.required(0), "example");
      expect(parsed.required(1), "test");
    });
  });
}
