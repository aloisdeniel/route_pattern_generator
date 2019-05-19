class ParsedPattern {
  final List<RouteSegment> segments;
  final List<String> query;

  ParsedPattern._(this.segments, this.query);

  factory ParsedPattern.fromString(String pattern) {
    if (pattern == null) return null;
    final parts = pattern.split("?");
    final segments = (parts.length > 0)
        ? parts[0]
            .split("/")
            .where((x) => x.isNotEmpty)
            .toList()
            .asMap()
            .entries
            .map((e) => RouteSegment.fromPattern(e.key, e.value))
            .toList()
        : <RouteSegment>[];
    final query = (parts.length > 1) ? parts[1].split("&") : <String>[];
    return ParsedPattern._(segments, query);
  }
}

abstract class RouteSegment {
  final int index;
  RouteSegment(this.index);
  factory RouteSegment.fromPattern(int index, String pattern) {
    if (pattern.startsWith(":")) {
      return DynamicSegment(index, pattern.substring(1));
    }
    return ConstantSegment(index, pattern);
  }
}

class ConstantSegment extends RouteSegment {
  final String value;
  ConstantSegment(int index, this.value) : super(index);
}

class DynamicSegment extends RouteSegment {
  final String name;
  DynamicSegment(int index, this.name) : super(index);

  String value(String uriSegment) => Uri.decodeComponent(uriSegment);
}
