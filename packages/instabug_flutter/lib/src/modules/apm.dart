// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';

import 'package:flutter/widgets.dart' show WidgetBuilder;
import 'package:instabug_flutter/src/generated/apm.api.g.dart';
import 'package:instabug_flutter/src/models/network_data.dart';
import 'package:instabug_flutter/src/utils/ibg_build_info.dart';
import 'package:instabug_flutter/src/utils/instabug_logger.dart';
import 'package:instabug_flutter/src/utils/screen_loading/screen_loading_manager.dart';
import 'package:meta/meta.dart';

class APM {
  static var _host = ApmHostApi();
  static String tag = 'Instabug - APM';

  /// @nodoc
  @visibleForTesting
  // ignore: use_setters_to_change_properties
  static void $setHostApi(ApmHostApi host) {
    _host = host;
  }

  /// Enables or disables APM feature.
  /// [boolean] isEnabled
  static Future<void> setEnabled(bool isEnabled) async {
    return _host.setEnabled(isEnabled);
  }

  /// Returns a Future<bool> indicating whether [APM] is enabled.
  ///
  /// Returns:
  ///   A Future<bool> object is being returned.
  @internal
  static Future<bool> isEnabled() async {
    return _host.isEnabled();
  }

  /// Sets the screen loading state based on the provided boolean value.
  ///
  /// Args:
  ///   isEnabled (bool): The [isEnabled] parameter is a boolean value that determines whether screen
  /// loading is enabled or disabled. If [isEnabled] is `true`, screen loading will be enabled; if
  /// [isEnabled] is `false`, screen loading will be disabled.
  ///
  /// Returns:
  ///   A Future<void> is being returned.
  static Future<void> setScreenLoadingEnabled(bool isEnabled) {
    return _host.setScreenLoadingEnabled(isEnabled);
  }

  /// Returns a Future<bool> indicating whether screen loading is enabled.
  ///
  /// Returns:
  ///   A Future<bool> object is being returned.
  @internal
  static Future<bool> isScreenLoadingEnabled() async {
    return _host.isScreenLoadingEnabled();
  }

  /// Sets whether cold app launch is enabled or not.
  ///
  /// Args:
  ///   isEnabled (bool): The [setColdAppLaunchEnabled] method takes a boolean parameter [isEnabled] which
  /// indicates whether cold app launch is enabled or not.
  ///
  /// Returns:
  ///   The method is returning a `Future<void>`.
  static Future<void> setColdAppLaunchEnabled(bool isEnabled) async {
    return _host.setColdAppLaunchEnabled(isEnabled);
  }

  /// Starts an AppFlow with the given [name].
  ///
  /// The [name] must not be an empty string. It should be unique and not exceed 150 characters,
  /// ignoring leading and trailing spaces.
  ///
  /// Duplicate [name]s will terminate the older AppFlow with the termination reason recorded as
  /// 'force abandon end reason'.
  ///
  /// The method will only execute if APM is enabled, the feature is
  /// active, and the SDK has been initialized.
  static Future<void> startFlow(String name) async {
    if (name.isNotEmpty) {
      return _host.startFlow(name.trim());
    }
  }

  /// Assigns a custom attribute to an AppFlow with the specified [name], [key], and [value].
  ///
  /// The [name] must not be an empty string. The [key] should not exceed 30 characters,
  /// and [value] should not exceed 60 characters, with both ignoring leading and trailing spaces.
  ///
  /// To remove an attribute, set its [value] to null. Attributes cannot be added or
  /// modified after an AppFlow has concluded.
  static Future<void> setFlowAttribute(
    String name,
    String key,
    String? value,
  ) async {
    return _host.setFlowAttribute(name, key, value);
  }

  /// Ends a flow with the specified name.
  ///
  /// Args:
  ///   name (String): The [name] parameter is a required string that represents the name of the flow that you want
  /// to end.
  ///
  /// Returns:
  ///   The method is returning a `Future<void>`.
  static Future<void> endFlow(String name) async {
    return _host.endFlow(name);
  }

  /// Sets whether auto UI trace is enabled or not.
  ///
  /// Args:
  ///   isEnabled (bool): The [isEnabled] parameter is a boolean value that determines whether the auto
  /// UI trace feature should be enabled or disabled. If [isEnabled] is set to `true`, the auto UI trace
  /// feature will be enabled, and if it is set to `false`, the feature will be disabled.
  ///
  /// Returns:
  ///   The method returns a `Future<void>`.
  static Future<void> setAutoUITraceEnabled(bool isEnabled) async {
    return _host.setAutoUITraceEnabled(isEnabled);
  }

  /// Starts a UI trace with the given name.
  ///
  /// Args:
  ///   name (String): The [name] parameter in the [startUITrace] method is a string that represents the
  /// name of the UI trace that will be started.
  ///
  /// Returns:
  ///   The method is returning a `Future<void>`.
  static Future<void> startUITrace(String name) async {
    return _host.startUITrace(name);
  }

  /// The [endUITrace] function ends a UI trace.
  ///
  /// Returns:
  ///   The method is returning a `Future<void>`.
  static Future<void> endUITrace() async {
    return _host.endUITrace();
  }

  /// Defines when an app launch is complete,
  /// such as when it's intractable, use the end app launch API.
  /// You can then view this data with the automatic cold and hot app launches.
  ///
  /// Returns:
  ///   The method is returning a `Future<void>`.
  static Future<void> endAppLaunch() async {
    return _host.endAppLaunch();
  }

  /// Logs network data for Instabug Android SDK if the app is running on an
  /// Android platform.
  ///
  /// Args:
  ///   data (NetworkData): The [data] parameter in the `networkLogAndroid` function is of type
  /// [NetworkData] and represents the network data that need to be logged.
  ///
  /// Returns:
  ///   The method is returning a `FutureOr<void>`.
  static FutureOr<void> networkLogAndroid(NetworkData data) {
    if (IBGBuildInfo.instance.isAndroid) {
      return _host.networkLogAndroid(data.toJson());
    }
  }

  /// Logs a message and then starts a UI trace with the provided screen
  /// name, start time, and trace ID.
  ///
  /// Args:
  ///   screenName (String): The [screenName] parameter represents the identifier of the screen or
  /// page where the UI trace is being started. It helps in identifying and tracking the performance of
  /// that specific screen within the application.
  ///   startTimeInMicroseconds (int): The [startTimeInMicroseconds] parameter represents the time at
  /// which the UI trace is starting, measured in microseconds. It is used to track the performance and
  /// behavior of the user interface during a specific period of time.
  ///   traceId (int): The [traceId] parameter is used to uniquely identify a particular trace or
  /// performance measurement within the system. It helps in tracking and distinguishing different traces
  /// for analysis and debugging purposes.
  ///
  /// Returns:
  ///   The `startCpUiTrace` method is returning a `Future<void>`.
  @internal
  static Future<void> startCpUiTrace(
    String screenName,
    int startTimeInMicroseconds,
    int traceId,
  ) {
    InstabugLogger.I.d(
      'Starting Ui trace — traceId: $traceId, screenName: $screenName, microTimeStamp: $startTimeInMicroseconds',
      tag: APM.tag,
    );
    return _host.startCpUiTrace(screenName, startTimeInMicroseconds, traceId);
  }

  /// Reports screen loading trace with specific details.
  ///
  /// Args:
  ///   startTimeInMicroseconds (int): The [startTimeInMicroseconds] parameter represents the time when
  /// the screen loading operation started, measured in microseconds.
  ///   durationInMicroseconds (int): The [durationInMicroseconds] parameter represents the duration of
  /// the screen loading process in microseconds. It indicates the time taken for the screen to load
  /// completely from the start time specified by [startTimeInMicroseconds]. This parameter helps in
  /// measuring and analyzing the performance of the screen loading operation.
  ///   uiTraceId (int): The [uiTraceId] parameter is used to
  /// identify a specific trace related to the screen loading process. It helps in tracking
  /// and monitoring the performance of the screen loading operation.
  ///
  /// Returns:
  ///   The method is returning a `Future<void>`.
  @internal
  static Future<void> reportScreenLoadingCP(
    int startTimeInMicroseconds,
    int durationInMicroseconds,
    int uiTraceId,
  ) {
    InstabugLogger.I.d(
      'Reporting screen loading trace — traceId: $uiTraceId, startTimeInMicroseconds: $startTimeInMicroseconds, durationInMicroseconds: $durationInMicroseconds',
      tag: APM.tag,
    );
    return _host.reportScreenLoadingCP(
      startTimeInMicroseconds,
      durationInMicroseconds,
      uiTraceId,
    );
  }

  /// Extends a screen loading trace with the provided end time and UI trace ID.
  ///
  /// Args:
  ///   endTimeInMicroseconds (int): The [endTimeInMicroseconds] parameter represents the time at which
  /// the screen loading ends, measured in microseconds.
  ///   uiTraceId (int): The [uiTraceId] parameter is an identifier for the user interface trace being
  /// monitored or tracked. It helps in associating the end time of the screen loading with the specific
  /// trace for performance monitoring and analysis.
  ///
  /// Returns:
  ///   The method is returning a `Future<void>`.
  @internal
  static Future<void> endScreenLoadingCP(
    int endTimeInMicroseconds,
    int uiTraceId,
  ) {
    InstabugLogger.I.d(
      'Extending screen loading trace — traceId: $uiTraceId, endTimeInMicroseconds: $endTimeInMicroseconds',
      tag: APM.tag,
    );
    return _host.endScreenLoadingCP(endTimeInMicroseconds, uiTraceId);
  }

  /// Extends the currently active screen loading trace using the [ScreenLoadingManager].
  ///
  /// Returns:
  ///   A Future<void> is being returned.
  static Future<void> endScreenLoading() {
    return ScreenLoadingManager.I.endScreenLoading();
  }

  /// Returns a Future<bool> indicating whether the end screen
  /// loading is enabled.
  ///
  /// Returns:
  ///   A Future<bool> is being returned.
  @internal
  static Future<bool> isEndScreenLoadingEnabled() async {
    return _host.isEndScreenLoadingEnabled();
  }

  /// The function [wrapRoutes] wraps the given routes with a [InstabugCaptureScreenLoading] widget, excluding specified
  /// routes. This allows Instabug to automatically capture screen loading times.
  ///
  /// Args:
  ///   routes (Map<String, WidgetBuilder>): The [routes] parameter is a map that contains route names as
  /// keys and corresponding [WidgetBuilder] functions as values. This map is used to define the available
  /// routes in a Flutter application.
  ///   exclude (List<String>): The [exclude] parameter is a list of route names that you want to exclude
  /// from the wrapping process. When the [wrapRoutes] function is called, it will wrap all routes except
  /// the ones specified in the [exclude] list. Defaults to const []
  ///
  /// Returns:
  ///   A Map<String, WidgetBuilder> that contains the new wrapped routes.
  static Map<String, WidgetBuilder> wrapRoutes(
    Map<String, WidgetBuilder> routes, {
    List<String> exclude = const [],
  }) {
    return ScreenLoadingManager.wrapRoutes(routes, exclude: exclude);
  }
}
