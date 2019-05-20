# route_pattern_generator

A Dart static code generator that produces matchers and builders from route URI patterns.

## Quickstart

Define your patterns as constant strings annoted with `@route`.

```dart
import 'package:route_pattern/route_pattern.dart';

part 'routes.g.dart';

@route
const home = "/?tab";

@route
const article = "/article/:id";
```

Each constant will generate a `Route` with a `build` and `match` method, and a associated `Argument` class ([an example of the generate sources is available in the sample](sample/lib/routes.g.dart)).

```dart
final path = Routes.home.build(HomeRouteArguments(tab: "users"));
expect(path, "/?tab=users");

final match = Routes.home.match("/?tab=users");
expect(match.isSuccess, true);
expect(match.arguments.tab, 'users');

final path = Routes.article.build(ArticleRouteArguments(id: "12345"));
expect(path, "/article/12345");

final match = Routes.article.match("/article/12345");
expect(match.isSuccess, true);
expect(match.arguments.id, '12345');
```

A global `match` function is also generated to help you match one of the declared routes.

```dart
final match = Routes.match("/article/12345");
if(match is MatchResult<ArticleRouteArguments>) {
    expect(match.arguments.id, '12345');
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

#### Example

`/article/:id/details?tab&scroll`

* `article` : static segment
* `id` : required dynamic segment
* `details` : static segment
* `tab` : optionnal query parameter
* `scroll` : optionnal query parameter

This example will match those URIs :

* `/article/26436/details`
* `/article/DH4H5JH5/details?tab=1`
* `/article/°098904/details?tab=first&scroll=8`

### Run the generator

To run the generator, you must use `build_runner` cli:

```sh
flutter pub pub run build_runner watch
```