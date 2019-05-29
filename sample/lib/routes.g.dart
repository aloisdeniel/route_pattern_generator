// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// RoutePatternGenerator
// **************************************************************************

Route _onGenerateRoute(RouteSettings settings) {
  final match = Routes.match(settings.name.replaceAll('+', '/'));
  if (match is MatchResult<HomeRouteArguments>) {
    return home(settings.copyWith(arguments: match.arguments), match.arguments);
  }
  if (match is MatchResult<ArticleRouteArguments>) {
    return article(
        settings.copyWith(arguments: match.arguments), match.arguments);
  }
  throw Exception('No route found');
}

abstract class Routes {
  static const _router = Router(routes: [home, article]);

  static const home = HomeRoute();

  static const article = ArticleRoute();

  static Route onGenerateRoute(RouteSettings settings) {
    return _onGenerateRoute(settings);
  }

  static Future<T> push<T>(BuildContext context, dynamic arguments) {
    if (arguments is HomeRouteArguments) {
      return Navigator.pushNamed<T>(
          context, home.build(arguments).replaceAll('/', '+'));
    }
    if (arguments is ArticleRouteArguments) {
      return Navigator.pushNamed<T>(
          context, article.build(arguments).replaceAll('/', '+'));
    }
    throw Exception('No route found for argument');
  }

  static Future<T> pushReplacement<T, TO>(
      BuildContext context, dynamic arguments) {
    if (arguments is HomeRouteArguments) {
      return Navigator.pushReplacementNamed<T, TO>(
          context, home.build(arguments).replaceAll('/', '+'));
    }
    if (arguments is ArticleRouteArguments) {
      return Navigator.pushReplacementNamed<T, TO>(
          context, article.build(arguments).replaceAll('/', '+'));
    }
    throw Exception('No route found for argument');
  }

  static MatchResult match(String path) {
    return _router.match(path);
  }
}

class HomeRouteArguments {
  HomeRouteArguments({this.tab, this.scroll});

  final String tab;

  final int scroll;
}

class HomeRoute extends RouteMatcher<HomeRouteArguments> {
  const HomeRoute();

  @override
  MatchResult<HomeRouteArguments> match(String path) {
    final parsed = ParsedRoute.fromPath(path);
    if (parsed.requiredCount != 0) return MatchResult.fail(this);
    final optional_tab = parsed.optional('tab');
    final optional_scroll = parsed.optional('scroll');
    return MatchResult.success(
        this,
        HomeRouteArguments(
          tab: optional_tab,
          scroll: optional_scroll == null ? null : int.parse(optional_scroll),
        ));
  }

  @override
  String build(HomeRouteArguments arguments) {
    return RouteMatcher.buildPath([], {
      "tab": arguments.tab?.toString(),
      "scroll": arguments.scroll?.toString()
    });
  }
}

class ArticleRouteArguments {
  ArticleRouteArguments({@required this.id});

  final int id;
}

class ArticleRoute extends RouteMatcher<ArticleRouteArguments> {
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
    return RouteMatcher.buildPath(["article", arguments.id.toString()]);
  }
}
