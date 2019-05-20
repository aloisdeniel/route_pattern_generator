import 'package:route_pattern/route_pattern.dart';
import 'package:flutter/widgets.dart';

part 'routes.g.dart';

@RoutePattern("/?tab&[int]scroll")
String home(String settings, HomeRouteArguments arguments) {

}

@RoutePattern("/article/:[int]id")
String article(String settings, ArticleRouteArguments arguments) {

}
 