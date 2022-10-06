import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/components/primary_color_option.dart';
import 'package:todo_list_app/components/switcher_container.dart';
import 'package:todo_list_app/constants/app_colors.dart';
import 'package:todo_list_app/providers/theme_provider.dart';

class PrimaryColorSwitcher extends StatelessWidget {
  const PrimaryColorSwitcher({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwitcherContainer(
      title: 'Primary Color',
      content: Consumer<ThemeProvider>(
        builder: (c, themeProvider, _) {
          return Wrap(
            children: List.generate(
              AppColors.primaryColorOptions.length,
              (i) => PrimaryColorOption(
                color: AppColors.primaryColorOptions[i],
                isSelected: themeProvider.selectedPrimaryColor ==
                    AppColors.primaryColorOptions[i],
                onTap: () => themeProvider.setSelectedPrimaryColor(
                  AppColors.primaryColorOptions[i],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
