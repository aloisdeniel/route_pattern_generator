
import 'package:build/build.dart';
import 'package:route_pattern_generator/src/generator.dart';

import 'package:source_gen/source_gen.dart';

Builder route_pattern(BuilderOptions _) => SharedPartBuilder([RoutePatternGenerator()], 'route_pattern');