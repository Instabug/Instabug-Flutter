import 'package:flutter/material.dart';
import 'package:instabug_flutter/src/utils/ibg_date_time.dart';
import 'package:instabug_flutter/src/utils/instabug_montonic_clock.dart';
import 'package:instabug_flutter/src/utils/screen_loading/screen_loading_manager.dart';
import 'package:instabug_flutter/src/utils/screen_loading/screen_loading_trace.dart';

/// A widget that tracks and reports screen loading times to Instabug.
///
/// This widget wraps around a child widget and measures the time taken
/// for the screen to fully render. The recorded loading time is reported
/// using the [ScreenLoadingManager].
///
/// ## Usage
/// ```dart
/// InstabugCaptureScreenLoading(
///   screenName: "HomeScreen",
///   child: HomeScreenWidget(),
/// )
/// ```
class InstabugCaptureScreenLoading extends StatefulWidget {
  /// A unique identifier for the widget used internally for debugging purposes.
  static const tag = "InstabugCaptureScreenLoading";

  /// Creates an instance of [InstabugCaptureScreenLoading].
  ///
  /// Requires [screenName] to identify the screen being tracked and [child]
  /// which represents the UI component to be rendered.
  const InstabugCaptureScreenLoading({
    Key? key,
    required this.screenName,
    required this.child,
  }) : super(key: key);

  /// The UI component whose loading time is being measured.
  final Widget child;

  /// The name of the screen being monitored for loading performance.
  final String screenName;

  @override
  State<InstabugCaptureScreenLoading> createState() =>
      _InstabugCaptureScreenLoadingState();
}

class _InstabugCaptureScreenLoadingState
    extends State<InstabugCaptureScreenLoading> {
  /// Trace object that records screen loading details.
  ScreenLoadingTrace? trace;

  /// Timestamp in microseconds when the widget is created.
  final startTimeInMicroseconds = IBGDateTime.I.now().microsecondsSinceEpoch;

  /// Monotonic timestamp in microseconds for more precise duration tracking.
  final startMonotonicTimeInMicroseconds = InstabugMonotonicClock.I.now;

  /// Stopwatch to measure screen loading time.
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

    // Ensures compatibility with Flutter versions before 3.0.0
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
