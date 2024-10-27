import 'package:flutter/material.dart';
import 'package:instabug_flutter/src/utils/private_views/private_views_manager.dart';
import 'package:instabug_flutter/src/utils/private_views/visibility_detector/visibility_detector.dart';

class InstabugPrivateView extends StatefulWidget {
  final Widget child;

  // ignore: prefer_const_constructors_in_immutables
  InstabugPrivateView({required this.child}) : super(key: null);

  @override
  State<InstabugPrivateView> createState() => _InstabugPrivateViewState();
}

class _InstabugPrivateViewState extends State<InstabugPrivateView> {
  final GlobalKey _visibilityDetectorKey = GlobalKey();
  final GlobalKey _childKey = GlobalKey();

  @override
  void dispose() {
    _removePrivateView();
    super.dispose();
  }

  void _addPrivateView() {
    PrivateViewsManager.I.mask(_childKey);
  }

  void _removePrivateView() {
    PrivateViewsManager.I.unMask(_childKey);
  }

  void _onVisibilityChanged(bool isVisible) {
    if (isVisible) {
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
      child: KeyedSubtree(key: _childKey, child: widget.child),
    );
  }
}
