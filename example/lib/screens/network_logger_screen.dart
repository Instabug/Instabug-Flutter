import 'package:flutter/material.dart';

class NetworkLoggerScreen extends StatelessWidget {
  const NetworkLoggerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Network Logger',
        ),
      ),
    );
  }
}
