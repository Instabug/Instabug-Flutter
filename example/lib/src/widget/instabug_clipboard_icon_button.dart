import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InstabugClipboardIconButton extends StatelessWidget {
  const InstabugClipboardIconButton({
    Key? key,
    this.onPaste,
  }) : super(key: key);

  final Function(String?)? onPaste;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _getClipboardContent(),
      icon: const Icon(
        Icons.paste_outlined,
      ),
    );
  }

  Future<void> _getClipboardContent() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    final clipboardText = clipboardData?.text;
    if (clipboardText != null && clipboardText.isNotEmpty) {
      onPaste?.call(clipboardText);
    }
  }
}
