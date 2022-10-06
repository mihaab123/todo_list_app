import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_app/components/page_wrapper.dart';
import 'package:todo_list_app/components/primary_color_switcher.dart';
import 'package:todo_list_app/components/theme_switcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text('settings').tr(),
      ),
      body: PageWrapper(
        body: Column(
          children: const [
            SizedBox(height: 30),
            ThemeSwitcher(),
            SizedBox(height: 20),
            PrimaryColorSwitcher(),
          ],
        ),
      ),
    );
  }
}
