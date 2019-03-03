import 'dart:async';

import 'package:flutter/services.dart';

enum InvocationEvent { shake, screenshot, twoFingersSwipeLeft, floatingButton, none }

class InstabugFlutter {
  static const MethodChannel _channel =
      const MethodChannel('instabug_flutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

   /*
   * Starts the SDK.
   * This is the main SDK method that does all the magic. This is the only
   * method that SHOULD be called.
   * Should be called in constructor of the app registery component
   * @param {string} token The token that identifies the app, you can find
   * it on your dashboard.
   * @param {List<InvocationEvent>} invocationEvents The events that invoke
   * the SDK's UI.
   */
  static void start(String token, List<InvocationEvent> invocationEvents) async {
    List<String> invocationEventsStrings = new List<String>();
    invocationEvents.forEach((e) {
      invocationEventsStrings.add(e.toString());
    });
    Map params = {'token': token, 'invocationEvents': invocationEventsStrings};
    await _channel.invokeMethod('startWithToken:invocationEvents:', params);
  }
  
}
