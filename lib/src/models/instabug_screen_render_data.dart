import 'package:flutter/foundation.dart';
import 'package:instabug_flutter/src/models/instabug_frame_data.dart';

class InstabugScreenRenderData {
  int traceId;
  int slowFramesTotalDuration;
  int frozenFramesTotalDuration;
  List<InstabugFrameData> frameData;

  InstabugScreenRenderData({
    this.slowFramesTotalDuration = 0,
    this.frozenFramesTotalDuration = 0,
    required this.frameData,
    this.traceId = -1,
  });

  bool get isEmpty => traceId == -1;

  bool get isNotEmpty => !isEmpty;

  void clear() {
    traceId = -1;
    frozenFramesTotalDuration = 0;
    slowFramesTotalDuration = 0;
    frameData.clear();
  }

  @override
  String toString() => '\nTrace Id $traceId\n'
      'Slow Frames Total Duration: $slowFramesTotalDuration\n'
      'Frozen Frames Total Duration $frozenFramesTotalDuration\n'
      'Frame Data[\n${frameData.map((element) => '\t\n$element')}\n]';

  @override
  // ignore: hash_and_equals
  bool operator ==(covariant InstabugScreenRenderData other) {
    if (identical(this, other)) return true;
    return traceId == other.traceId &&
        slowFramesTotalDuration == other.slowFramesTotalDuration &&
        frozenFramesTotalDuration == other.frozenFramesTotalDuration &&
        listEquals(frameData, other.frameData);
  }
}
