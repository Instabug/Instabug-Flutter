import 'package:flutter/material.dart';
import 'package:instabug_flutter/src/utils/ibg_date_time.dart';
import 'package:instabug_flutter/src/utils/instabug_montonic_clock.dart';
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
  final startTimeInMicroseconds = IBGDateTime.I.now().microsecondsSinceEpoch;
  final startMonotonicTimeInMicroseconds = InstabugMonotonicClock.I.now;
  final stopwatch = Stopwatch()..start();

  @override
  void initState() {
    super.initState();
    trace = ScreenLoadingTrace(
      ScreenLoadingManager.I.sanitizeScreenName(widget.screenName),
      startTimeInMicroseconds: startTimeInMicroseconds,
      startMonotonicTimeInMicroseconds: startMonotonicTimeInMicroseconds,
    );

    ScreenLoadingManager.I.startScreenLoadingTrace(trace!);

    // to maintain supported versions prior to Flutter 3.0.0
    // ignore: invalid_null_aware_operator
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      stopwatch.stop();
      final duration = stopwatch.elapsedMicroseconds;
      trace?.duration = duration;
      trace?.endTimeInMicroseconds = startTimeInMicroseconds + duration;
      ScreenLoadingManager.I.reportScreenLoading(trace);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
