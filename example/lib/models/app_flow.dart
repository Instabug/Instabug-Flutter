import 'package:flutter/widgets.dart';

class AppFlow {
  final String title;
  final Widget page;
  final IconData icon;

  const AppFlow({
    required this.title,
    required this.page,
    required this.icon,
  });
}
