import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instabug_flutter/src/utils/private_views/private_views_manager.dart';
import 'package:instabug_flutter/src/utils/private_views/visibility_detector/sliver_visibility_detector.dart';

class InstabugSliverPrivateView extends StatefulWidget {
  final Widget sliver;

  // ignore: prefer_const_constructors_in_immutables
  InstabugSliverPrivateView({Key? key, required this.sliver}) : super(key: key);

  @override
  State<InstabugSliverPrivateView> createState() =>
      _InstabugSliverPrivateViewState();
}

class _InstabugSliverPrivateViewState extends State<InstabugSliverPrivateView> {
  final key = GlobalKey();
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
    return SliverVisibilityDetector(
      key: key,
      onVisibilityChanged: _onVisibilityChanged,
      sliver: KeyedSubtree(key: _childKey,child: widget.sliver),
    );
  }
}
