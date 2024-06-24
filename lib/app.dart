import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platform_convertion/controller/platFormController.dart';
import 'package:platform_convertion/controller/themeController.dart';
import 'package:platform_convertion/pages/CupertinoApp/CThome_page/CThome_page.dart';
import 'package:platform_convertion/pages/MaterialApp/home_page/home_page.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider.of<PlatFormController>(context).isIos
        ? CupertinoApp(
            theme: Provider.of<ThemeController>(context).isdark
                ? const CupertinoThemeData(
                    brightness: Brightness.dark,
                  )
                : const CupertinoThemeData(
                    brightness: Brightness.light,
                  ),
            debugShowCheckedModeBanner: false,
            home: const CTHomePage(),
          )
        : MaterialApp(
            themeMode: Provider.of<ThemeController>(context).isdark
                ? ThemeMode.dark
                : ThemeMode.light,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            debugShowCheckedModeBanner: false,
            home: const MTHomePage(),
          );
  }
}
