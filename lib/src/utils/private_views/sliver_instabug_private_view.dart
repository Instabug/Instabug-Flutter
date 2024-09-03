import 'package:flutter/material.dart';
import 'package:instabug_flutter/src/modules/instabug.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SliverInstabugPrivateView extends StatefulWidget {
  final Widget sliver;

  SliverInstabugPrivateView({
    required this.sliver,
  }) : super(key: GlobalKey());

  @override
  State<SliverInstabugPrivateView> createState() =>
      _SliverInstabugPrivateViewState();
}

class _SliverInstabugPrivateViewState extends State<SliverInstabugPrivateView> {
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
    return SliverVisibilityDetector(
      key: _visibilityDetectorKey,
      onVisibilityChanged: _onVisibilityChanged,
      sliver: widget.sliver,
    );
  }
}
