import 'package:flutter/material.dart';
import 'package:mvvm/routing/router.dart';

void main() {
  runApp(AppMaterial());
}

class AppMaterial extends StatelessWidget {
  const AppMaterial({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      routerConfig: reouterConfig(),
    );
  }
}
