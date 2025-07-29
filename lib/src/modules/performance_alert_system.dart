import 'dart:async';
import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:system_info2/system_info2.dart';

typedef AlertCallback = void Function(String type, String message);

class PerformanceAlertSystem {
  static Timer? _memoryTimer;
  static Timer? _networkTimer;
  static Timer? _batteryTimer;
  static AlertCallback? _onAlert;

  static void monitorMemory(
      {double warningThreshold = 80, double criticalThreshold = 90}) {
    _memoryTimer?.cancel();
    
    // Skip memory monitoring on iOS as SysInfo methods are not supported
    if (Platform.isIOS) {
      return;
    }
    
    _memoryTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      try {
        final totalMemory = SysInfo.getTotalPhysicalMemory();
        final freeMemory = SysInfo.getFreePhysicalMemory();
        final usedMemory = totalMemory - freeMemory;
        final usagePercent = (usedMemory / totalMemory) * 100;

        if (usagePercent > criticalThreshold) {
          _onAlert?.call('critical',
              '⛔️ Memory usage is very high (${usagePercent.toStringAsFixed(1)}%). This may cause app freezing or closing.');
        } else if (usagePercent > warningThreshold) {
          _onAlert?.call('warning',
              '⚠️ Memory usage is elevated (${usagePercent.toStringAsFixed(1)}%). The app may become slower.');
        }
      } catch (e) {
        // Handle any platform-specific errors gracefully
        timer.cancel();
      }
    });
  }

  static void monitorNetwork(
      {Duration checkInterval = const Duration(seconds: 10)}) {
    _networkTimer?.cancel();
    _networkTimer = Timer.periodic(checkInterval, (timer) async {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        _onAlert?.call('critical',
            '⛔️ No internet connection! Some features may not work.');
      }
    });
  }

  static void monitorBattery(
      {double warningThreshold = 20, double criticalThreshold = 10}) {
    _batteryTimer?.cancel();
    final battery = Battery();
    _batteryTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      final level = await battery.batteryLevel;
      if (level <= criticalThreshold) {
        _onAlert?.call('critical',
            '⛔️ Battery is very low ($level%). The app may close or freeze.');
      } else if (level <= warningThreshold) {
        _onAlert?.call('warning',
            '⚠️ Battery is low ($level%). It is recommended to charge the device.');
      }
    });
  }

  static void startAllMonitoring({AlertCallback? onAlert}) {
    _onAlert = onAlert;
    monitorMemory();
    monitorNetwork();
    monitorBattery();
  }

  static void stopAllMonitoring() {
    _memoryTimer?.cancel();
    _networkTimer?.cancel();
    _batteryTimer?.cancel();
    _onAlert = null;
  }
}
