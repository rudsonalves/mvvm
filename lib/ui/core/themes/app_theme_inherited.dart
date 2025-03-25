import 'package:flutter/material.dart';

class AppThemeInherited extends InheritedTheme {
  final Brightness _brightness;
  final Function() toggleTheme;

  const AppThemeInherited({
    super.key,
    required Brightness brightness,
    required super.child,
    required this.toggleTheme,
  }) : _brightness = brightness;

  Brightness get brightness => _brightness;

  bool get isDark => _brightness == Brightness.dark;

  @override
  bool updateShouldNotify(covariant AppThemeInherited oldWidget) {
    return oldWidget.brightness != _brightness;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return AppThemeInherited(
      brightness: brightness,
      toggleTheme: toggleTheme,
      child: child,
    );
  }

  factory AppThemeInherited.of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppThemeInherited>()!;
  }
}
