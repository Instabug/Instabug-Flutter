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

  @override
  void initState() {
    _addPrivateView(true);
    super.initState();
  }

  @override
  void dispose() {
    _removePrivateView(true);
    super.dispose();
  }

  void _addPrivateView(bool init) {
    PrivateViewsManager.I.mask(key);
    debugPrint(
      "Sliver Adding private view $key ${init ? "init" : ''}",
    );
  }

  void _removePrivateView(bool dispose) {
    debugPrint(
      "Sliver Removing private view $key ${dispose ? "dispose" : ''}",
    );
    PrivateViewsManager.I.unMask(key);
  }

  void _onVisibilityChanged(bool isVisible) {
    if (isVisible) {
      _addPrivateView(false);
    } else {
      _removePrivateView(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverVisibilityDetector(
      key: key,
      onVisibilityChanged: _onVisibilityChanged,
      sliver: widget.sliver,
    );
  }
}
