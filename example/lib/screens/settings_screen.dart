import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:instabug_flutter/instabug_flutter.dart';

import '../providers/settings_state.dart';
import '../providers/theme_state.dart';
import '../widgets/feature_tile.dart';
import '../widgets/section_card.dart';
import '../widgets/separated_list_view.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<ThemeState>(context);
    final settingsState = Provider.of<SettingsState>(context);
    return Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        removeTop: true,
        child: SeparatedListView(
          padding: const EdgeInsets.all(8.0),
          separator: const SizedBox(
            height: 8.0,
          ),
          children: <Widget>[
            SectionCard(
              children: [
                FeatureTile(
                  leading: Icon(
                    themeState.isDarkTheme
                        ? Icons.dark_mode
                        : Icons.dark_mode_outlined,
                  ),
                  title: const Text('Dark Theme'),
                  trailing: Switch(
                    value: themeState.isDarkTheme,
                    onChanged: (value) {
                      themeState.setThemeData(value);
                      Instabug.setColorTheme(
                        themeState.isDarkTheme
                            ? ColorTheme.dark
                            : ColorTheme.light,
                      );
                    },
                  ),
                ),
                FeatureTile(
                  leading: const Icon(Icons.palette),
                  title: const Text('Primary Color'),
                  bottom: Wrap(
                    spacing: 4.0,
                    children: settingsState.colors.keys.map((colorName) {
                      final color = settingsState.colors[colorName]!;
                      final isSelected =
                          colorName == settingsState.selectedColorName;
                      return ChoiceChip(
                        label: Text(colorName),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[700],
                        ),
                        selected: isSelected,
                        selectedColor: color,
                        onSelected: (selected) {
                          if (selected) {
                            settingsState.selectColor(colorName);
                            Instabug.setPrimaryColor(color);
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: isSelected
                              ? BorderSide.none
                              : BorderSide(
                                  color: color,
                                  width: 2,
                                ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
