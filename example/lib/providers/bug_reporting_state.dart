import 'package:flutter/material.dart';

import 'package:instabug_flutter/instabug_flutter.dart';

class BugReportingState with ChangeNotifier {
  final _extraAttachments = {
    'Screenshot': true,
    'Extra Screenshot': true,
    'Gallery Image': true,
    'Screen Recording': true
  };
  Map<String, bool> get extraAttachments => _extraAttachments;

  var _selectedInvocationOptions = <InvocationOption>{};
  final _invocationOptions = {
    InvocationOption.commentFieldRequired: 'Comment Required',
    InvocationOption.emailFieldHidden: 'Email Hidden',
    InvocationOption.emailFieldOptional: 'Email Optional',
    InvocationOption.disablePostSendingDialog: 'Disable Post Sending Dialog',
  };
  Set<InvocationOption> get selectedInvocationOptions =>
      _selectedInvocationOptions;
  set selectedInvocationOptions(Set<InvocationOption> value) {
    _selectedInvocationOptions = value;
    notifyListeners();
  }

  Map<InvocationOption, String> get invocationOptions => _invocationOptions;

  var _selectedInvocationEvents = <InvocationEvent>{
    InvocationEvent.floatingButton
  };
  final _invocationEvents = {
    InvocationEvent.floatingButton: 'Floating Button',
    InvocationEvent.shake: 'Shake',
    InvocationEvent.screenshot: 'Screenshot',
    InvocationEvent.twoFingersSwipeLeft: 'Two Finger Swipe Left',
    InvocationEvent.none: 'None',
  };
  Set<InvocationEvent> get selectedInvocationEvents =>
      _selectedInvocationEvents;
  set selectedInvocationEvents(Set<InvocationEvent> value) {
    _selectedInvocationEvents = value;
    notifyListeners();
  }

  Map<InvocationEvent, String> get invocationEvents => _invocationEvents;

  var _selectedExtendedMode = 'Disabled';
  final _extendedMode = {
    ExtendedBugReportMode.disabled: 'Disabled',
    ExtendedBugReportMode.enabledWithOptionalFields: 'Optional Fields',
    ExtendedBugReportMode.enabledWithRequiredFields: 'Required Fields',
  };
  String get selectedExtendedMode => _selectedExtendedMode;
  set selectedExtendedMode(String value) {
    _selectedExtendedMode = value;
    notifyListeners();
  }

  Map<ExtendedBugReportMode, String> get extendedMode => _extendedMode;

  var _selectedVideoRecordingPosition = 'Bottom Right';
  final _videoRecordingPosition = {
    Position.topLeft: 'Top Left',
    Position.topRight: 'Top Right',
    Position.bottomLeft: 'Bottom Left',
    Position.bottomRight: 'Bottom Right',
  };
  String get selectedVideoRecordingPosition => _selectedVideoRecordingPosition;
  set selectedVideoRecordingPosition(String value) {
    _selectedVideoRecordingPosition = value;
    notifyListeners();
  }

  Map<Position, String> get videoRecordingPosition => _videoRecordingPosition;

  var _selectedFloatingButtonEdge = 'Right';
  var _selectedFloatingButtonOffset = 100;
  final _floatingButtonEdge = {
    FloatingButtonEdge.right: 'Right',
    FloatingButtonEdge.left: 'Left',
  };
  String get selectedFloatingButtonEdge => _selectedFloatingButtonEdge;
  set selectedFloatingButtonEdge(String value) {
    _selectedFloatingButtonEdge = value;
    notifyListeners();
  }

  Map<FloatingButtonEdge, String> get floatingButtonEdge => _floatingButtonEdge;

  int get selectedFloatingButtonOffset => _selectedFloatingButtonOffset;
  set selectedFloatingButtonOffset(int value) {
    _selectedFloatingButtonOffset = value;
    notifyListeners();
  }
}
