import 'package:flutter/material.dart';

import './products_screen.dart';
import './settings_screen.dart';
import '../models/app_flow.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedPageIndex = 0;

  static const flows = [
    AppFlow(
      title: 'Home',
      page: ProductsScreen(),
      icon: Icons.home,
    ),
    AppFlow(
      title: 'Settings',
      page: SettingsScreen(),
      icon: Icons.settings,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(flows[selectedPageIndex].title),
      ),
      body: IndexedStack(
        index: selectedPageIndex,
        children: flows.map((flow) => flow.page).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            selectedPageIndex = index;
          });
        },
        currentIndex: selectedPageIndex,
        items: flows
            .map(
              (flow) => BottomNavigationBarItem(
                icon: Icon(flow.icon),
                label: flow.title,
              ),
            )
            .toList(),
      ),
    );
  }
}
