import 'package:flutter/material.dart';
import 'package:platform_convertion/app.dart';
import 'package:platform_convertion/controller/functionController.dart';
import 'package:platform_convertion/controller/platFormController.dart';
import 'package:platform_convertion/controller/themeController.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeController(),
        ),
        ChangeNotifierProvider(
          create: (context) => PlatFormController(),
        ),
        ChangeNotifierProvider(
          create: (context) => FunctionController(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
