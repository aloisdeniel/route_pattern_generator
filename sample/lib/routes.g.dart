// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// RoutePatternGenerator
// **************************************************************************

abstract class Routes {
  static const _router = Router(routes: [home, article]);

  static const home = HomeRoute();

  static const article = ArticleRoute();

  static MatchResult match(String path) {
    return _router.match(path);
  }
}

class HomeRouteArguments {
  HomeRouteArguments({this.tab, this.scroll});

  final String tab;

  final int scroll;
}

class HomeRoute extends Route<HomeRouteArguments> {
  const HomeRoute();

  @override
  MatchResult<HomeRouteArguments> match(String path) {
    final parsed = ParsedRoute.fromPath(path);
    if (parsed.requiredCount != 0) return MatchResult.fail(this);
    return MatchResult.success(
        this,
        HomeRouteArguments(
          tab: parsed.optional("tab"),
          scroll: int.parse(parsed.optional("scroll")),
        ));
  }

  @override
  String build(HomeRouteArguments arguments) {
    return Route.buildPath([], {
      "tab": arguments.tab.toString(),
      "scroll": arguments.scroll.toString()
    });
  }
}

class ArticleRouteArguments {
  ArticleRouteArguments({@required this.id});

  final int id;
}

class ArticleRoute extends Route<ArticleRouteArguments> {
  const ArticleRoute();

  @override
  MatchResult<ArticleRouteArguments> match(String path) {
    final parsed = ParsedRoute.fromPath(path);
    if (parsed.requiredCount != 2 || parsed.required(0) != "article")
      return MatchResult.fail(this);
    return MatchResult.success(
        this,
        ArticleRouteArguments(
          id: int.parse(parsed.required(1)),
        ));
  }

  @override
  String build(ArticleRouteArguments arguments) {
    return Route.buildPath(["article", arguments.id.toString()]);
  }
}
