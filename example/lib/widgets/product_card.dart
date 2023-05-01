import 'package:flutter/material.dart';

import '../models/product_item.dart';
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

  void navToSelectedProduct(BuildContext context) {
    ProductItem selectedProduct =
        ProductsScreen.products.firstWhere((product) => product.title == title);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => selectedProduct.screen,
        settings: RouteSettings(name: selectedProduct.title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => navToSelectedProduct(context),
      splashColor: Theme.of(context).splashColor,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Theme.of(context).cardColor,
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
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
