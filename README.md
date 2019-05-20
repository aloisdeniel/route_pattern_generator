# route_pattern_generator

A Dart static code generator that produces matchers and builders from route URI patterns.

## Quickstart

Define your patterns as constant strings annoted with `@route`.

```dart
import 'package:route_pattern/route_pattern.dart';
import 'package:flutter/widgets.dart';

part 'routes.g.dart';

@RoutePattern("/?tab&[int]scroll")
Route home(RouteSettings settings, HomeRouteArguments arguments) {
    // returns a Route
}

@RoutePattern("/article/:[int]id")
Route article(RouteSettings settings, ArticleRouteArguments arguments) {
    // returns a Route
}
```

Each constant will generate a `Route` with a `build` and `match` method, and a associated `Argument` class ([an example of the generate sources is available in the sample](sample/lib/routes.g.dart)).

```dart
// Build specific routes
final path = Routes.home.build(HomeRouteArguments(tab: "users"));
expect(path, "/?tab=users");

final path = Routes.article.build(ArticleRouteArguments(id: "12345"));
expect(path, "/article/12345");

// Match specific routes
final match = Routes.home.match("/?tab=users");
expect(match.isSuccess, true);
expect(match.arguments.tab, 'users');

final match = Routes.article.match("/article/12345");
expect(match.isSuccess, true);
expect(match.arguments.id, '12345');

// Or get the first matching route
final match = Routes.match("/article/12345");
if(match is MatchResult<ArticleRouteArguments>) {
    expect(match.arguments.id, '12345');
}
```

A `Routes.onGenerateRoute` method is also generated to use in your app or navigator. It will match the first route which settings name matches a pattern and call your declared function with corresponding arguments.

```dart
import 'package:sample/routes.dart';
import 'package:flutter/material.dart';

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: Routes.onGenerateRoute,
      // ...
    );
  }
}
```

## How to use

### Install

There are a few separate packages you need to install:

```yaml
dependencies:
  route_pattern:

dev_dependencies:
  route_pattern_generator: 
  build_runner: 
```

### Pattern format

A route pattern is composed of static segments separated with `/`, **required** parameters as dynamic segments (starting with `:`), and **optional** parameters as query parameters (starting with `?` and separated by `&`).

### Typing parameters

By default, arguments are of type `String`, but a custom type surrounded with `[` and `]` can be added at the beginning of a required or optional parameter. This type must have static `T parse(String value)` and `String toString()`  methods to serialize and deserialize arguments from path.

#### Example

`/article/:[int]id/details?tab&[int]scroll`

* `article` : static segment
* `id` : required dynamic segment of type `int`
* `details` : static segment
* `tab` : optionnal query parameter of type `String`
* `scroll` : optionnal query parameter of type `int`

This example will match those URIs :

* `/article/26436/details`
* `/article/1234/details?tab=second`
* `/article/98904/details?tab=first&scroll=8`

### Run the generator

To run the generator, you must use `build_runner` cli:

```sh
flutter pub pub run build_runner watch
```