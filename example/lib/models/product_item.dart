import 'package:flutter/widgets.dart';

class ProductItem {
  final String title;
  final String imageUrl;
  final Color color;
  final Widget screen;

  const ProductItem({
    required this.title,
    required this.imageUrl,
    required this.color,
    required this.screen,
  });
}
