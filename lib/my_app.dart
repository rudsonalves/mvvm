import 'package:flutter/material.dart';
import 'package:mvvm/routing/router.dart';
import 'package:mvvm/ui/core/themes/app_theme_inherited.dart';
import 'package:mvvm/ui/core/themes/text_theme.dart';
import 'package:mvvm/ui/core/themes/theme.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Brightness brightness;
  late final TextTheme textTheme;
  late final MaterialTheme theme;

  @override
  void initState() {
    brightness = Brightness.light;
    textTheme = createTextTheme(context, 'Open Sans', 'Montserrat');
    theme = MaterialTheme(textTheme);
    super.initState();
  }

  void _toggleTheme() {
    brightness =
        brightness == Brightness.light ? Brightness.dark : Brightness.light;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeInherited(
      brightness: brightness,
      toggleTheme: _toggleTheme,
      child: MaterialApp.router(
        theme: brightness != Brightness.light ? theme.light() : theme.dark(),
        debugShowCheckedModeBanner: false,
        routerConfig: reouterConfig(),
      ),
    );
  }
}
