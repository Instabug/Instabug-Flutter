import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instabug_flutter/src/modules/crash_reporting.dart';
import 'package:instabug_flutter/src/utils/instabug_logger.dart';

class InstabugWidget extends StatefulWidget {
  final Widget child;

  /// Custom handler for Flutter errors.
  ///
  /// This callback is called when a Flutter error occurs. It receives a
  /// [FlutterErrorDetails] object containing information about the error.
  ///
  /// Example:
  /// ```dart
  /// InstabugWidget(
  ///   flutterErrorHandler: (details) {
  ///     print('Flutter error: ${details.exception}');
  ///     // Custom error handling logic
  ///   },
  ///   child: MyApp(),
  /// )
  /// ```
  ///
  /// Note: If this handler throws an error, it will be caught and logged
  /// to prevent it from interfering with Instabug's error reporting.
  final Function(FlutterErrorDetails)? flutterErrorHandler;

  /// Custom handler for platform errors.
  ///
  /// This callback is called when a platform error occurs. It receives the
  /// error object and stack trace.
  ///
  /// Example:
  /// ```dart
  /// InstabugWidget(
  ///   platformErrorHandler: (error, stack) {
  ///     print('Platform error: $error');
  ///     // Custom error handling logic
  ///   },
  ///   child: MyApp(),
  /// )
  /// ```
  ///
  /// Note: If this handler throws an error, it will be caught and logged
  /// to prevent it from interfering with Instabug's error reporting.
  final Function(Object, StackTrace)? platformErrorHandler;

  /// Whether to handle Flutter errors.
  ///
  /// If true, the Flutter error will be reported as a non-fatal crash, instead of a fatal crash.
  final bool nonFatalFlutterErrors;

  /// The level of the non-fatal exception.
  ///
  /// This is used to determine the level of the non-fatal exception.
  ///
  /// Note: This has no effect if [nonFatalFlutterErrors] is false.
  final NonFatalExceptionLevel nonFatalExceptionLevel;

  /// This widget is used to wrap the root of your application. It will automatically
  /// configure both FlutterError.onError and PlatformDispatcher.instance.onError handlers to report errors to Instabug.
  ///
  /// Example:
  /// ```dart
  /// MaterialApp(
  ///   home: InstabugWidget(
  ///     child: MyApp(),
  ///   ),
  /// )
  /// ```
  ///
  /// Note: Custom error handlers are called before the error is reported to Instabug.
  const InstabugWidget({
    Key? key,
    required this.child,
    this.flutterErrorHandler,
    this.platformErrorHandler,
    this.nonFatalFlutterErrors = false,
    this.nonFatalExceptionLevel = NonFatalExceptionLevel.error,
  }) : super(key: key);

  @override
  State<InstabugWidget> createState() => _InstabugWidgetState();
}

class _InstabugWidgetState extends State<InstabugWidget> {
  @override
  void initState() {
    super.initState();
    _setupErrorHandlers();
  }

  void _setupErrorHandlers() {
    FlutterError.onError = (FlutterErrorDetails details) {
      // Call user's custom handler if provided
      if (widget.flutterErrorHandler != null) {
        try {
          widget.flutterErrorHandler!(details);
        } catch (e) {
          InstabugLogger.I.e(
            'Custom Flutter error handler failed: $e',
            tag: 'InstabugWidget',
          );
        }
      }

      if (widget.nonFatalFlutterErrors) {
        CrashReporting.reportHandledCrash(
          details.exception,
          details.stack ?? StackTrace.current,
          level: widget.nonFatalExceptionLevel,
        );
      } else {
        CrashReporting.reportCrash(
          details.exception,
          details.stack ?? StackTrace.current,
        );
      }

      FlutterError.presentError(details);
    };

    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      // Call user's custom handler if provided
      if (widget.platformErrorHandler != null) {
        try {
          widget.platformErrorHandler!(error, stack);
        } catch (e) {
          InstabugLogger.I.e(
            'Custom platform error handler failed: $e',
            tag: 'InstabugWidget',
          );
        }
      }

      CrashReporting.reportCrash(error, stack);

      return true;
    };
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
