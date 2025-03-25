import 'package:flutter/material.dart';

import 'package:mvvm/routing/router.dart';
import 'package:mvvm/ui/core/themes/text_theme.dart';
import 'package:mvvm/ui/core/themes/theme.dart';

void main() {
  runApp(const AppMaterial());
}

class AppMaterial extends StatelessWidget {
  const AppMaterial({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    TextTheme textTheme = createTextTheme(
      context,
      'Open Sans',
      'Montserrat',
      // 'Quando',
      // "Happy Monkey",
      //"Marcellus SC", //
    );

    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp.router(
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      debugShowCheckedModeBanner: false,
      routerConfig: reouterConfig(),
    );
  }
}
