// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// RoutePatternGenerator
// **************************************************************************

class HomeRouteArguments {
  HomeRouteArguments({this.tab});

  final String tab;
}

class HomeRoute extends Route<HomeRouteArguments> {
  @override
  MatchResult<HomeRouteArguments> match(String path) {
    final parsed = ParsedRoute.fromPath(path);
    if (parsed.requiredCount != 0) return MatchResult.fail(this);
    return MatchResult.success(
        this,
        HomeRouteArguments(
          tab: parsed.optional("tab"),
        ));
  }

  @override
  String build(HomeRouteArguments arguments) {
    return Route.buildPath([], {"tab": arguments.tab});
  }
}

class ArticleRouteArguments {
  ArticleRouteArguments({@required this.id});

  final String id;
}

class ArticleRoute extends Route<ArticleRouteArguments> {
  @override
  MatchResult<ArticleRouteArguments> match(String path) {
    final parsed = ParsedRoute.fromPath(path);
    if (parsed.requiredCount != 2 || parsed.required(0) != "article")
      return MatchResult.fail(this);
    return MatchResult.success(
        this,
        ArticleRouteArguments(
          id: parsed.required(1),
        ));
  }

  @override
  String build(ArticleRouteArguments arguments) {
    return Route.buildPath(["article", arguments.id]);
  }
}
