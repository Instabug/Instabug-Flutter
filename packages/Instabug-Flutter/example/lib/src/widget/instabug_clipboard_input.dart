import 'package:flutter/material.dart';
import 'package:instabug_flutter_example/src/widget/instabug_text_field.dart';
import 'package:instabug_flutter_example/src/widget/instabug_clipboard_icon_button.dart';

class InstabugClipboardInput extends StatelessWidget {
  const InstabugClipboardInput({
    Key? key,
    required this.label,
    required this.controller,
  }) : super(key: key);

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InstabugTextField(
            label: label,
            margin: const EdgeInsetsDirectional.only(
              start: 20.0,
            ),
            controller: controller,
          ),
        ),
        InstabugClipboardIconButton(
          onPaste: (String? clipboardText) {
            controller.text = clipboardText ?? controller.text;
          },
        )
      ],
    );
  }
}
