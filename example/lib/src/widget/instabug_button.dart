import 'package:flutter/material.dart';

class InstabugButton extends StatelessWidget {
  InstabugButton(
      {Key? key,
      required this.text,
      this.onPressed,
      this.fontSize,
      this.margin,
      this.backgroundColor,
      this.symanticLabel})
      : super(
            key:
                key ?? (symanticLabel != null ? ValueKey(symanticLabel) : key));

  const InstabugButton.smallFontSize(
      {Key? key,
      required this.text,
      this.onPressed,
      this.fontSize = 10.0,
      this.margin,
      this.backgroundColor,
      this.symanticLabel})
      : super(key: key);

  final String text;
  final Function()? onPressed;
  final double? fontSize;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? margin;

  final String? symanticLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin ??
          const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
      child: Semantics(
        label: symanticLabel,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? Colors.lightBlue,
            foregroundColor: Colors.white,
            textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: fontSize,
                ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
