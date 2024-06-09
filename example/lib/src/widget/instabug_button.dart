import 'package:flutter/material.dart';

class InstabugButton extends StatelessWidget {
  const InstabugButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.fontSize,
    this.margin,
  }) : super(key: key);

  const InstabugButton.smallFontSize({
    Key? key,
    required this.text,
    this.onPressed,
    this.fontSize = 10.0,
    this.margin,
  }) : super(key: key);

  final String text;
  final Function()? onPressed;
  final double? fontSize;

  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin ??
          const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightBlue,
          foregroundColor: Colors.white,
          textStyle: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(fontSize: fontSize),
        ),
        child: Text(text),
      ),
    );
  }
}
