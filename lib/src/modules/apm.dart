// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';
import 'dart:developer';

import 'package:instabug_flutter/src/generated/apm.api.g.dart';
import 'package:instabug_flutter/src/models/network_data.dart';
import 'package:instabug_flutter/src/models/trace.dart';
import 'package:instabug_flutter/src/utils/ibg_build_info.dart';
import 'package:instabug_flutter/src/utils/ibg_date_time.dart';
import 'package:meta/meta.dart';

class APM {
  static var _host = ApmHostApi();
  static String tag = 'FLT-APM';

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

  /// @nodoc
  @internal
  static Future<bool> isEnabled() async {
    return _host.isEnabled();
  }

  /// Enables or disables the screenLoading Monitoring feature.
  /// [boolean] isEnabled
  static Future<void> setScreenLoadingMonitoringEnabled(
      bool isEnabled,
      ) {
    return _host.setScreenLoadingMonitoringEnabled(isEnabled);
  }

  /// @nodoc
  @internal
  static Future<bool> isScreenLoadingMonitoringEnabled() async {
    return _host.isScreenLoadingMonitoringEnabled();
  }

  /// Enables or disables cold app launch tracking.
  /// [boolean] isEnabled
  static Future<void> setColdAppLaunchEnabled(bool isEnabled) async {
    return _host.setColdAppLaunchEnabled(isEnabled);
  }

  /// Starts an execution trace.
  /// [String] name of the trace.
  ///
  /// Please migrate to the App Flows APIs: [startFlow], [setFlowAttribute], and [endFlow].
  @Deprecated(
    'Please migrate to the App Flows APIs: APM.startAppFlow, APM.endFlow, and APM.setFlowAttribute. This feature was deprecated in v13.0.0',
  )
  static Future<Trace> startExecutionTrace(String name) async {
    final id = IBGDateTime.instance.now();
    final traceId = await _host.startExecutionTrace(id.toString(), name);

    if (traceId == null) {
      return Future.error(
        "Execution trace $name wasn't created. Please make sure to enable APM first by following "
        'the instructions at this link: https://docs.instabug.com/reference#enable-or-disable-apm',
      );
    }

    return Trace(
      id: traceId,
      name: name,
    );
  }

  /// Sets attribute of an execution trace.
  /// [String] id of the trace.
  /// [String] key of attribute.
  /// [String] value of attribute.
  ///
  /// Please migrate to the App Flows APIs: [startFlow], [setFlowAttribute], and [endFlow].
  @Deprecated(
    'Please migrate to the App Flows APIs: APM.startAppFlow, APM.endFlow, and APM.setFlowAttribute. This feature was deprecated in v13.0.0',
  )
  static Future<void> setExecutionTraceAttribute(
    String id,
    String key,
    String value,
  ) async {
    return _host.setExecutionTraceAttribute(id, key, value);
  }

  /// Ends an execution trace.
  /// [String] id of the trace.
  ///
  /// Please migrate to the App Flows APIs: [startFlow], [setFlowAttribute], and [endFlow].
  @Deprecated(
    'Please migrate to the App Flows APIs: APM.startAppFlow, APM.endFlow, and APM.setFlowAttribute. This feature was deprecated in v13.0.0',
  )
  static Future<void> endExecutionTrace(String id) async {
    return _host.endExecutionTrace(id);
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
      String name, String key, String? value) async {
    return _host.setFlowAttribute(name, key, value);
  }

  /// Ends the AppFlow with the given [name].
  static Future<void> endFlow(String name) async {
    return _host.endFlow(name);
  }

  /// Enables or disables auto UI tracing.
  /// [boolean] isEnabled
  static Future<void> setAutoUITraceEnabled(bool isEnabled) async {
    return _host.setAutoUITraceEnabled(isEnabled);
  }

  /// Starts UI trace.
  /// [String] name
  static Future<void> startUITrace(String name) async {
    return _host.startUITrace(name);
  }

  /// Ends UI trace.
  static Future<void> endUITrace() async {
    return _host.endUITrace();
  }

  /// Ends App Launch.
  static Future<void> endAppLaunch() async {
    return _host.endAppLaunch();
  }

  static FutureOr<void> networkLogAndroid(NetworkData data) {
    if (IBGBuildInfo.instance.isAndroid) {
      return _host.networkLogAndroid(data.toJson());
    }
  }

  /// @nodoc
  @internal
  static Future<void> startCpUiTrace(
    String screenName,
    int startTimeInMicroseconds,
    int traceId,
  ) {
    log(
      'starting Ui trace — traceId: $traceId, screenName: $screenName, microTimeStamp: $startTimeInMicroseconds',
      name: APM.tag,
    );
    return _host.startCpUiTrace(screenName, startTimeInMicroseconds, traceId);
  }

  /// @nodoc
  @internal
  static Future<void> reportScreenLoading(
    int startTimeInMicroseconds,
    int durationInMicroseconds,
    int uiTraceId,
  ) {
    log(
      'reporting screen loading trace — traceId: $uiTraceId, startTimeInMicroseconds: $startTimeInMicroseconds, durationInMicroseconds: $durationInMicroseconds',
      name: APM.tag,
    );
    return _host.reportScreenLoading(
        startTimeInMicroseconds, durationInMicroseconds, uiTraceId);
  }

  static Future<void> endScreenLoading(
    int endTimeInMicroseconds,
    int uiTraceId,
  ) {
    log(
      'Extending screen loading trace — traceId: $uiTraceId, endTimeInMicroseconds: $endTimeInMicroseconds',
      name: APM.tag,
    );
    return _host.endScreenLoading(endTimeInMicroseconds, uiTraceId);
  }
}
