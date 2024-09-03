import 'package:flutter/material.dart';
import 'package:instabug_flutter/src/modules/instabug.dart';
import 'package:visibility_detector/visibility_detector.dart';

class InstabugPrivateView extends StatefulWidget {
  final Widget child;

  InstabugPrivateView({
    required this.child,
  }) : super(key: GlobalKey());

  @override
  State<InstabugPrivateView> createState() => _InstabugPrivateViewState();
}

class _InstabugPrivateViewState extends State<InstabugPrivateView> {
  GlobalKey get key => widget.key! as GlobalKey;

  final Key _visibilityDetectorKey = UniqueKey();

  @override
  void initState() {
    _addPrivateView();
    super.initState();
  }

  @override
  void dispose() {
    _removePrivateView();
    super.dispose();
  }

  void _addPrivateView() {
    debugPrint("Adding private view");

    PrivateViews.views.add(key);
  }

  void _removePrivateView() {
    debugPrint("Removing private view");

    PrivateViews.views.remove(key);
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction > 0) {
      _addPrivateView();
    } else {
      _removePrivateView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _visibilityDetectorKey,
      onVisibilityChanged: _onVisibilityChanged,
      child: widget.child,
    );
  }
}
