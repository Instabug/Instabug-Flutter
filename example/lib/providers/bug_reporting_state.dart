import 'dart:io';

import 'package:flutter/material.dart';

import 'package:instabug_flutter/instabug_flutter.dart';
import '../models/attachment_type.dart';

class BugReportingState with ChangeNotifier {
  var _extraAttachments = <AttachmentType>{
    AttachmentType.screenshot,
    AttachmentType.extraScreenshot,
    AttachmentType.galleryImage,
    AttachmentType.screenRecording,
  };
  Set<AttachmentType> get extraAttachments => _extraAttachments;
  set extraAttachments(Set<AttachmentType> attachments) {
    _extraAttachments = attachments;
    notifyListeners();
  }

  var _invocationOptions = <InvocationOption>{};
  Set<InvocationOption> get invocationOptions => _invocationOptions;
  set invocationOptions(Set<InvocationOption> options) {
    _invocationOptions = options;
    notifyListeners();
  }

  var _invocationEvents = <InvocationEvent>{InvocationEvent.floatingButton};
  Set<InvocationEvent> get invocationEvents => _invocationEvents;
  set invocationEvents(Set<InvocationEvent> events) {
    _invocationEvents = events;
    notifyListeners();
  }

  var _extendedMode = ExtendedBugReportMode.disabled;
  ExtendedBugReportMode get extendedMode => _extendedMode;
  set extendedMode(ExtendedBugReportMode mode) {
    _extendedMode = mode;
    notifyListeners();
  }

  var _videoRecordingPosition = Position.bottomRight;
  Position get videoRecordingPosition => _videoRecordingPosition;
  set videoRecordingPosition(Position position) {
    _videoRecordingPosition = position;
    notifyListeners();
  }

  var _floatingButtonEdge = FloatingButtonEdge.right;
  FloatingButtonEdge get floatingButtonEdge => _floatingButtonEdge;
  set floatingButtonEdge(FloatingButtonEdge edge) {
    _floatingButtonEdge = edge;
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

  var _floatingButtonOffset = Platform.isIOS ? 100 : 250;
  int get floatingButtonOffset => _floatingButtonOffset;
  set floatingButtonOffset(int offset) {
    _floatingButtonOffset = offset;
    notifyListeners();
  }
}
