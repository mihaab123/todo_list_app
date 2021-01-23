import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_list_app/src/app.dart';

void main() => runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('ru', 'RU')],
      //supportedLocales: [ Locale('ru', 'RU')],
      path: 'assets/translations',
      //fallbackLocale: Locale('ru', 'RU'),
      fallbackLocale: Locale('en', 'US'),
      child: App()
    )
    //App()
);