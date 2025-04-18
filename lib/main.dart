import 'package:flutter/material.dart';
import 'package:mvvm/config/dependences.dart';
import 'package:mvvm/ui/core/themes/app_theme_inherited.dart';
import 'package:provider/provider.dart';

import '/routing/router.dart';
import '/ui/core/themes/text_theme.dart';
import '/ui/core/themes/theme.dart';

void main() {
  runApp(MultiProvider(providers: remoteProviders, child: const AppMaterial()));
}

class AppMaterial extends StatefulWidget {
  const AppMaterial({super.key});

  @override
  State<AppMaterial> createState() => _AppMaterialState();
}

class _AppMaterialState extends State<AppMaterial> {
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
