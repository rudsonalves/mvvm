import 'package:flutter/material.dart';

import '/routing/router.dart';
import '/ui/core/themes/text_theme.dart';
import '/ui/core/themes/theme.dart';

void main() {
  runApp(const AppMaterial());
}

class AppMaterial extends StatelessWidget {
  const AppMaterial({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    TextTheme textTheme = createTextTheme(context, 'Open Sans', 'Montserrat');

    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp.router(
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      debugShowCheckedModeBanner: false,
      routerConfig: reouterConfig(),
    );
  }
}
