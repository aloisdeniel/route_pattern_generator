class ParsedPattern {
  final List<RouteSegment> segments;
  final List<TypedParameter> query;

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
    final query = (parts.length > 1)
        ? parts[1].split("&").map(_getTyped).toList()
        : <TypedParameter>[];
    return ParsedPattern._(segments, query);
  }
}

abstract class RouteSegment {
  final int index;
  RouteSegment(this.index);
  factory RouteSegment.fromPattern(int index, String pattern) {
    if (pattern.startsWith(":")) {
      final typed = _getTyped(pattern.substring(1));
      return DynamicSegment(index, typed.type, typed.name);
    }
    return ConstantSegment(index, pattern);
  }
}

class ConstantSegment extends RouteSegment {
  final String value;
  ConstantSegment(int index, this.value) : super(index);
}

class DynamicSegment extends RouteSegment implements TypedParameter {
  final String name;
  final String type;
  DynamicSegment(int index, this.type, this.name) : super(index);

  String value(String uriSegment) => Uri.decodeComponent(uriSegment);
}

TypedParameter _getTyped(String parameter) {
  final endType = parameter.indexOf(']');
  if (parameter[0] == '[' && endType > 1) {
    final type = parameter.substring(1, endType);
    final name = parameter.substring(endType + 1);
    return TypedParameter(type, name);
  }

  return TypedParameter("String", parameter);
}

class TypedParameter {
  final String type;
  final String name;
  TypedParameter(this.type, this.name);
}
