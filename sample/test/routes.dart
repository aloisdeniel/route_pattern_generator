import 'package:route_pattern/route_pattern.dart';
import 'package:sample/routes.dart';
import 'package:test/test.dart';

void main() {
  group('Home route', () {
    test('doesn\'t matches an invalid url', () async {
      final route = HomeRoute();
      final match = route.match("/test");
      expect(match.isSuccess, false);
    });
    test('matches a valid url', () async {
      final route = HomeRoute();
      final match = route.match("/");
      expect(match.isSuccess, true);
      expect(match.arguments.tab, null);
    });
    test('matches an url with query', () async {
      final route = HomeRoute();
      final match = route.match("/?tab=users");
      expect(match.isSuccess, true);
      expect(match.arguments.tab, 'users');
    });

    test('build a valid url', () async {
      final route = HomeRoute();
      final path = route.build(HomeRouteArguments(tab: "users"));
      expect(path, "/?tab=users");
    });
  });

  group('Article route', () {
    test('doesn\'t matches an empty url', () async {
      final route = ArticleRoute();
      final match = route.match("/");
      expect(match.isSuccess, false);
    });
    test('doesn\'t matches an invalid url', () async {
      final route = ArticleRoute();
      final match = route.match("/test");
      expect(match.isSuccess, false);
    });
    test('matches a url', () async {
      final route = ArticleRoute();
      final match = route.match("/article/874645234");
      expect(match.isSuccess, true);
      expect(match.arguments.id, '874645234');
    });
  });

  group('Router', () {
    test('contains route', () {
      final match = Routes.match("/article/12345");
      expect(match is MatchResult<ArticleRouteArguments>, true);
      if (match is MatchResult<ArticleRouteArguments>) {
        expect(match.arguments.id, '12345');
      }
    });
  });
}
