import 'package:meta/meta.dart';

import 'route.dart';

class Router {
  final List<Route> routes;

  const Router({@required this.routes});

  MatchResult match(String path) {
    return routes.map((x) => x.match(path)).firstWhere((x) => x.isSuccess, orElse: () => null);
  }
}