import 'package:meta/meta.dart';

class MatchResult<T> {
  final Route<T> route;
  final T arguments;
  final bool isSuccess;
  MatchResult._(
      {@required this.route,
      @required this.arguments,
      @required this.isSuccess});

  MatchResult.fail(Route<T> route)
      : this._(isSuccess: false, route: route, arguments: null);

  MatchResult.success(Route<T> route, T arguments)
      : this._(isSuccess: true, route: route, arguments: arguments);
}

abstract class Route<T> {
  String build(T args);
  MatchResult<T> match(String path);

  static String buildPath([List<String> segments, Map<String, String> query]) {
    final buffer = StringBuffer();
    if (segments == null || segments.isEmpty)
      buffer.write("/");
    else
      segments
          .forEach((s) => buffer..write("/")..write(Uri.encodeComponent(s)));

    if (query != null && query.isNotEmpty) {
      final entries = query.entries.toList();
      for (var i = 0; i < entries.length; i++) {
        final entry = entries[i];
        buffer.write(i == 0 ? "?" : "&");
        buffer.write(Uri.encodeQueryComponent(entry.key));
        buffer.write("=");
        buffer.write(Uri.encodeQueryComponent(entry.value));
      }
    }

    return buffer.toString();
  }
}

class ParsedRoute {
  final List<String> _segments;
  final Map<String, String> _query;

  bool get hasOptionals => _query.isNotEmpty;

  bool get isEmpty => !hasOptionals && requiredCount == 0;

  int get requiredCount => _segments.length;

  ParsedRoute(this._segments, this._query);

  factory ParsedRoute.fromPath(String path) {
    if (path == null) return null;
    final parts = path.split("?");
    final segments = (parts.length > 0)
        ? parts[0].split("/").where((x) => x.isNotEmpty).toList()
        : [];
    final query = (parts.length > 1)
        ? Uri.splitQueryString(parts[1])
        : <String, String>{};
    return ParsedRoute(segments, query);
  }

  String required(int index) {
    final result = _segments[index];
    return result == null ? null : Uri.decodeComponent(result);
  }

  String optional(String name) {
    final result = _query[name];
    return result == null ? null : result;
  }
}
