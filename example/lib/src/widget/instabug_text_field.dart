import 'package:flutter/material.dart';

class InstabugTextField extends StatelessWidget {
  const InstabugTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.labelStyle,
    this.margin,
    this.keyboardType,
    this.validator,
  }) : super(key: key);

  final String label;
  final TextEditingController controller;
  final EdgeInsetsGeometry? margin;
  final TextStyle? labelStyle;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ??
          const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: labelStyle ?? Theme.of(context).textTheme.labelLarge,
          suffixIcon: IconButton(
            onPressed: controller.clear,
            iconSize: 12.0,
            icon: const Icon(
              Icons.clear,
            ),
          ),
        ),
      ),
    );
  }
}
