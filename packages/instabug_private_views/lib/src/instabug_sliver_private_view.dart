import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instabug_private_views/src/private_views_manager.dart';
import 'package:instabug_private_views/src/visibility_detector/sliver_visibility_detector.dart';

class InstabugSliverPrivateView extends StatefulWidget {
  final Widget sliver;

  // Making the constructor const prevents the VisibilityDetector from detecting changes in the view,
  // ignore: prefer_const_constructors_in_immutables, use_super_parameters
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

  @override
  void initState() {
    _addPrivateView();
    super.initState();
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
      sliver: KeyedSubtree(key: _childKey, child: widget.sliver),
    );
  }
}
