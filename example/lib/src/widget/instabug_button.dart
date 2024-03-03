import 'package:flutter/material.dart';

class InstabugButton extends StatelessWidget {
  const InstabugButton({Key? key,
    required this.text,
    this.onPressed,
  }) : super(key: key);

  final String text;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
          foregroundColor: MaterialStateProperty.all(Colors.white),
        ),
        child: Text(text),
      ),
    );
  }
}
