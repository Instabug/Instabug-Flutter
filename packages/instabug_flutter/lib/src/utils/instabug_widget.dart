import 'package:flutter/material.dart';
import 'package:instabug_flutter/src/generated/instabug_private_view.api.g.dart';
import 'package:instabug_flutter/src/utils/private_views/private_views_manager.dart';
import 'package:meta/meta.dart';

@internal
final instabugWidgetKey = GlobalKey(debugLabel: 'instabug_screenshot_widget');

class InstabugWidget extends StatefulWidget {
  final Widget child;

  const InstabugWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<InstabugWidget> createState() => _InstabugWidgetState();
}

class _InstabugWidgetState extends State<InstabugWidget> {
  @override
  void initState() {
    _enableInstabugMaskingPrivateViews();


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: instabugWidgetKey,
      child: widget.child,
    );
  }

  void _enableInstabugMaskingPrivateViews() {
    final api = InstabugPrivateViewHostApi();
    api.init();
    InstabugPrivateViewFlutterApi.setup(PrivateViewsManager.I);
  }
}
