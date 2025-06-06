import 'package:instabug_flutter/src/models/InstabugFrameData.dart';

class InstabugScreenRenderData {
  int traceId;
  int totalSlowFramesDurations;
  int totalFrozenFramesDurations;
  List<InstabugFrameData> frameData;

  InstabugScreenRenderData({
    this.totalSlowFramesDurations = 0,
    this.totalFrozenFramesDurations = 0,
    required this.frameData ,
    this.traceId = -1,
  });

  bool get isEmpty => traceId == -1;

  bool get isNotEmpty => !isEmpty;

  void clear() {
    traceId = -1;
    totalFrozenFramesDurations = 0;
    totalSlowFramesDurations = 0;
    frameData.clear();
  }

  @override
  String toString() => '\nTraceId $traceId\n'
      'TotalSlowFramesDurations: $totalSlowFramesDurations\n'
      'TotalFrozenFramesDurations $totalFrozenFramesDurations\n'
      'FrameData[\n${frameData.map((element) => '\t\n$element')}\n]';
}
