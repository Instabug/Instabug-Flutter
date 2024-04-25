import 'package:flutter/material.dart';
import 'package:instabug_flutter/src/utils/screen_loading/screen_loading_manager.dart';
import 'package:instabug_flutter/src/utils/screen_loading/screen_loading_trace.dart';

class InstabugCaptureScreenLoading extends StatefulWidget {
  static const tag = "InstabugCaptureScreenLoading";

  const InstabugCaptureScreenLoading({
    Key? key,
    required this.screenName,
    required this.child,
  }) : super(key: key);
  final Widget child;
  final String screenName;

  @override
  State<InstabugCaptureScreenLoading> createState() =>
      _InstabugCaptureScreenLoadingState();
}

class _InstabugCaptureScreenLoadingState
    extends State<InstabugCaptureScreenLoading> {
  ScreenLoadingTrace? trace;
  final startTimeInMicroseconds = DateTime.now().microsecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
    ScreenLoadingManager.I.startScreenLoadingTrace(
      widget.screenName,
      startTimeInMicroseconds: startTimeInMicroseconds,
    );

    trace = ScreenLoadingTrace(
      widget.screenName,
      startTimeInMicroseconds: startTimeInMicroseconds,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final endTimeInMicroseconds = DateTime.now().microsecondsSinceEpoch;
      ScreenLoadingManager.I.reportScreenLoading(
        trace,
        endTimeInMicroseconds: endTimeInMicroseconds,
      );
      trace?.endTimeInMicroseconds = endTimeInMicroseconds;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
