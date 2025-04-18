import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'package:mvvm/config/dependences.dart';
import 'package:mvvm/my_app.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((log) {
    debugPrint('[${log.level} - ${log.loggerName}]: ${log.message}');
  });

  runApp(MultiProvider(providers: remoteProviders, child: const MyApp()));
}
