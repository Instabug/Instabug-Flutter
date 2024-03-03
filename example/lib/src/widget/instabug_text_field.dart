import 'package:flutter/material.dart';

class InstabugTextField extends StatelessWidget {
  const InstabugTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.margin,
  }) : super(key: key);

  final String label;
  final TextEditingController controller;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ??
          const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: IconButton(
            onPressed: controller.clear,
            icon: const Icon(
              Icons.clear,
            ),
          ),
        ),
      ),
    );
  }
}
