import 'package:route_pattern_generator/src/parsing.dart';
import 'package:test/test.dart';

void main() {
  group('Parsing', () {
     test('an null pattern', () async {
      final result = ParsedPattern.fromString(null);
      expect(result, null);
    });
     test('an empty pattern', () async {
      final result = ParsedPattern.fromString("");
      expect(result.segments.isEmpty, true);
      expect(result.query.isEmpty, true);
    });
    test('a pattern with static segments', () async {
      final result = ParsedPattern.fromString("/example/static");
      expect(result.query.isEmpty, true);
      expect(result.segments.length == 2, true);

      final segment0 = result.segments[0] as ConstantSegment;
      final segment1 = result.segments[1] as ConstantSegment;

      expect(segment0?.index, 0);
      expect(segment0?.value, "example");
      expect(segment1?.index, 1);
      expect(segment1?.value, "static");
    });
    test('a pattern with dymanic segments', () async {
      final result = ParsedPattern.fromString("/example/:id/static");
      expect(result.query.isEmpty, true);
      expect(result.segments.length == 3, true);

      final segment0 = result.segments[0] as ConstantSegment;
      final segment1 = result.segments[1] as DynamicSegment;
      final segment2 = result.segments[2] as ConstantSegment;

      expect(segment0?.index, 0);
      expect(segment0?.value, "example");
      expect(segment1?.index, 1);
      expect(segment1?.name, "id");
      expect(segment2?.index, 2);
      expect(segment2?.value, "static");
    });
    test('a pattern with a single query parameter', () async {
      final result = ParsedPattern.fromString("/example/static?test");
      expect(result.segments.isNotEmpty, true);
      expect(result.query.isNotEmpty, true);

      expect(result.query.contains("test"), true);
    });
    test('a pattern with multiple query parameters', () async {
      final result = ParsedPattern.fromString("/example/static?test&other");
      expect(result.segments.isNotEmpty, true);
      expect(result.query.length == 2, true);

      expect(result.query.contains("test"), true);
      expect(result.query.contains("other"), true);
    });
  });
}