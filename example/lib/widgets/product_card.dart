import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product_item.dart';
import '../providers/settings_state.dart';
import '../screens/products_screen.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final Color color;

  const ProductCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.color,
  });

  void navToSelectedProduct(BuildContext ctx) {
    ProductItem selectedProduct =
        ProductsScreen.products.firstWhere((product) => product.title == title);

    Navigator.push(
      ctx,
      MaterialPageRoute(builder: (_) => selectedProduct.screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<SettingsState>(context);
    return InkWell(
      onTap: () => navToSelectedProduct(context),
      splashColor: state.getThemeData().splashColor,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: state.getThemeData().cardColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.0,
              height: 80.0,
              margin: const EdgeInsets.only(top: 20.0),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(imageUrl),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: state.getThemeData().textTheme.headlineMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
