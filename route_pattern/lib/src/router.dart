import 'route.dart';

class PatternRouter {
  final List<RouteMatcher> routes;

  const PatternRouter({required this.routes});

  MatchResult match(String path) {
    return routes.map((x) => x.match(path)).firstWhere(
          (x) => x.isSuccess,
          orElse: () => MatchResult.fail(null),
        );
  }
}
