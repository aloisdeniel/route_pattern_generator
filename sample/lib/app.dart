import 'package:sample/routes.dart';
import 'package:flutter/material.dart';

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example',
      onGenerateRoute: Routes.onGenerateRoute,
    );
  }
}
