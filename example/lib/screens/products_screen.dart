import 'package:flutter/material.dart';

import '../models/product_item.dart';
import '../screens/apm_screen.dart';
import '../screens/bug_reporting_screen.dart';
import '../screens/core_screen.dart';
import '../screens/crash_reporting_screen.dart';
import '../screens/feature_requests_screen.dart';
import '../screens/network_logger_screen.dart';
import '../screens/replies_screen.dart';
import '../screens/surveys_screen.dart';
import '../widgets/product_card.dart';

class ProductsScreen extends StatelessWidget {
  static const products = [
    ProductItem(
      title: 'Bug Reporting',
      imageUrl: 'assets/images/Bug Reporting.png',
      color: Color(0x3000287A),
      screen: BugReportingScreen(),
    ),
    ProductItem(
      title: 'Crash Reporting',
      imageUrl: 'assets/images/Crash Reporting.png',
      color: Color(0x30E91002),
      screen: CrashReportingScreen(),
    ),
    ProductItem(
      title: 'APM',
      imageUrl: 'assets/images/APM.png',
      color: Color(0x30008037),
      screen: APMScreen(),
    ),
    ProductItem(
      title: 'Replies',
      imageUrl: 'assets/images/Replies.png',
      color: Color(0x309D03A0),
      screen: RepliesScreen(),
    ),
    ProductItem(
      title: 'Surveys',
      imageUrl: 'assets/images/Surveys.png',
      color: Color(0x30FF1887),
      screen: SurveysScreen(),
    ),
    ProductItem(
      title: 'Feature Requests',
      imageUrl: 'assets/images/Feature Requests.png',
      color: Color(0x30FFA721),
      screen: FeatureRequestsScreen(),
    ),
    ProductItem(
      title: 'Core',
      imageUrl: 'assets/images/Core.png',
      color: Color(0x305DABF0),
      screen: CoreScreen(),
    ),
    ProductItem(
      title: 'Network Logger',
      imageUrl: 'assets/images/Network.png',
      color: Color(0x30F4CE04),
      screen: NetworkLoggerScreen(),
    ),
  ];

  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        physics: const ClampingScrollPhysics(),
        crossAxisCount: 2,
        padding: const EdgeInsets.all(20.0),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: products
            .map(
              (product) => ProductCard(
                title: product.title,
                imageUrl: product.imageUrl,
                color: product.color,
              ),
            )
            .toList(),
      ),
    );
  }
}
