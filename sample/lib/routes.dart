import 'package:route_pattern/route_pattern.dart';

part 'routes.g.dart';

@route
const home = "/?tab&[int]scroll";

@route
const article = "/article/:[int]id";
 