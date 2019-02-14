import 'dart:async';

import 'package:flutter/services.dart';

enum InvocationEvent { shake, screenshot, twoFingersSwipeLeft, rightEdgePan, floatingButton, none }

class InstabugFlutter {
  static const MethodChannel _channel =
      const MethodChannel('instabug_flutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static void start(String token, List<InvocationEvent> invocationEvents) async {
    List<String> invocationEventsStrings = new List<String>();
    invocationEvents.forEach((e) {
      invocationEventsStrings.add(e.toString());
    });
    Map params = {'token': token, 'invocationEvents': invocationEventsStrings};
    await _channel.invokeMethod('startWithToken:invocationEvents', params);
  }
}
