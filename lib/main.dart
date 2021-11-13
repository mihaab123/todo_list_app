import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todo_list_app/providers/category_provider.dart';
import 'package:todo_list_app/src/app.dart';

import 'helpers/notificationHelper.dart';
import 'package:provider/provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
NotificationAppLaunchDetails notificationAppLaunchDetails;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  await initNotifications(flutterLocalNotificationsPlugin);
  requestIOSPermissions(flutterLocalNotificationsPlugin);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: CategoryProvider.initialize()),
    ],
    child: EasyLocalization(
        supportedLocales: [Locale('en', 'US'), Locale('ru', 'RU')],
        //supportedLocales: [ Locale('ru', 'RU')],
        path: 'assets/translations',
        //fallbackLocale: Locale('ru', 'RU'),
        fallbackLocale: Locale('en', 'US'),
        child: App()),
  )
      //App()
      );
}
