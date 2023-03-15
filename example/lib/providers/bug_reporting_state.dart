import 'package:flutter/material.dart';

import 'package:instabug_flutter/instabug_flutter.dart';

class BugReportingState with ChangeNotifier {
  var _extraAttachments = {
    'Screenshot': true,
    'Extra Screenshot': true,
    'Gallery Image': true,
    'Screen Recording': true
  };
  Map<String, bool> get extraAttachments => _extraAttachments;
  set extraAttachments(Map<String, bool> attachments) {
    _extraAttachments = attachments;
    notifyListeners();
  }

  var _selectedInvocationOptions = <InvocationOption>{};
  Set<InvocationOption> get selectedInvocationOptions =>
      _selectedInvocationOptions;
  set selectedInvocationOptions(Set<InvocationOption> options) {
    _selectedInvocationOptions = options;
    notifyListeners();
  }

  var _selectedInvocationEvents = <InvocationEvent>{
    InvocationEvent.floatingButton
  };
  Set<InvocationEvent> get selectedInvocationEvents =>
      _selectedInvocationEvents;
  set selectedInvocationEvents(Set<InvocationEvent> events) {
    _selectedInvocationEvents = events;
    notifyListeners();
  }

  var _selectedExtendedMode = ExtendedBugReportMode.disabled;
  ExtendedBugReportMode get selectedExtendedMode => _selectedExtendedMode;
  set selectedExtendedMode(ExtendedBugReportMode mode) {
    _selectedExtendedMode = mode;
    notifyListeners();
  }

  var _selectedVideoRecordingPosition = Position.bottomRight;
  Position get selectedVideoRecordingPosition =>
      _selectedVideoRecordingPosition;
  set selectedVideoRecordingPosition(Position position) {
    _selectedVideoRecordingPosition = position;
    notifyListeners();
  }

  var _selectedFloatingButtonEdge = FloatingButtonEdge.right;
  FloatingButtonEdge get selectedFloatingButtonEdge =>
      _selectedFloatingButtonEdge;
  set selectedFloatingButtonEdge(FloatingButtonEdge edge) {
    _selectedFloatingButtonEdge = edge;
    notifyListeners();
  }

  var _disclaimerText = '';
  String get disclaimerText => _disclaimerText;
  set disclaimerText(String text) {
    _disclaimerText = text;
    notifyListeners();
  }

  var _characterCount = '';
  String get characterCount => _characterCount;
  set characterCount(String count) {
    _characterCount = count;
    notifyListeners();
  }

  var _floatingButtonOffset = 100;
  int get floatingButtonOffset => _floatingButtonOffset;
  set floatingButtonOffset(int offset) {
    _floatingButtonOffset = offset;
    notifyListeners();
  }
}
