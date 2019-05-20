import 'package:flutter/material.dart';
import 'package:route_pattern/route_pattern.dart';
import 'package:flutter/widgets.dart';

part 'routes.g.dart';

@RoutePattern("/?tab&[int]scroll")
Route home(RouteSettings settins, HomeRouteArguments arguments) {
  return MaterialPageRoute(builder: (c) => Text("Home"));
}

@RoutePattern("/article/:[int]id")
Route article(RouteSettings settins, ArticleRouteArguments arguments) {
  return MaterialPageRoute(builder: (c) => Text("Article"));
}
 