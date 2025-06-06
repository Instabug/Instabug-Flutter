// import 'dart:async';
// import 'dart:developer';
// import 'dart:ui';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/widgets.dart';
// import 'package:instabug_flutter/src/modules/apm.dart';
// import 'package:meta/meta.dart';
//
// @internal
// class InstabugFrameTracker {
//   late Duration buildTime;
//   late Duration rasterTime;
//   late Duration totalTime;
//
//   int _JANKFrames = 0;
//   double _deviceRefreshRate = 60;
//   double _threshold = 16;
//
//   // final stackChain = Chain.current();
//
//   InstabugFrameTracker() {
//     log("Andrew InstabugFrameTracker has been attached");
//     _checkForWidgetBinding();
//
//     WidgetsBinding.instance.addTimingsCallback((timings) {
//       for (final frameTiming in timings) {
//         _analyzeFrameTiming(frameTiming);
//       }
//     });
//   }
//
//   // Simulates a computationally expensive task
//   void simulateHeavyComputation() {
//     final startTime = DateTime.now();
//     // Block the UI thread for ~500ms
//     while (DateTime.now().difference(startTime).inMilliseconds <= 1000) {
//       // Busy waiting (not recommended in real apps)
//     }
//   }
//
//
//
// }
