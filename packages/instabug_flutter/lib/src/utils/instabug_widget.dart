import 'package:flutter/material.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/generated/instabug_private_view.api.g.dart';
import 'package:instabug_flutter/src/utils/private_views/private_views_manager.dart';
import 'package:meta/meta.dart';

@internal
final instabugWidgetKey = GlobalKey(debugLabel: 'instabug_screenshot_widget');

class InstabugWidget extends StatefulWidget {
  final Widget child;
  final bool enablePrivateViews;
  final bool enableUserSteps;
  final List<AutoMasking>? automasking;

  const InstabugWidget({
    Key? key,
    required this.child,
    this.enableUserSteps = true,
    this.enablePrivateViews = true,
    this.automasking,
  }) : super(key: key);

  @override
  State<InstabugWidget> createState() => _InstabugWidgetState();
}

class _InstabugWidgetState extends State<InstabugWidget> {
  @override
  void initState() {
    if (widget.enablePrivateViews) {
      _enableInstabugMaskingPrivateViews();
    }
    if (widget.automasking != null) {
      PrivateViewsManager.I.addAutoMasking(widget.automasking!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final child = widget.enableUserSteps
        ? InstabugUserSteps(child: widget.child)
        : widget.child;

    if (widget.enablePrivateViews) {
      return RepaintBoundary(
        key: instabugWidgetKey,
        child: child,
      );
    }
    return child;
  }
}

void _enableInstabugMaskingPrivateViews() {
  final api = InstabugPrivateViewHostApi();
  api.init();
  InstabugPrivateViewFlutterApi.setup(PrivateViewsManager.I);
}
