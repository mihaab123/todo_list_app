import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/constants/app_themes.dart';
import 'package:todo_list_app/screens/home_screen.dart';
import 'package:easy_localization/easy_localization.dart';

import '../providers/theme_provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (c, themeProvider, home) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: AppThemes.main(
          primaryColor: themeProvider.selectedPrimaryColor,
        ),
        darkTheme: AppThemes.main(
          isDark: true,
          primaryColor: themeProvider.selectedPrimaryColor,
        ),
        themeMode: themeProvider.selectedThemeMode,
        home: HomeScreen(),
      );
    });
  }
}
