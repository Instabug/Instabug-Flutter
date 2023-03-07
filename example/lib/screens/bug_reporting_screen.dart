import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:instabug_flutter/instabug_flutter.dart';

import '../providers/bug_reporting_state.dart';
import '../widgets/chip_picker.dart';
import '../widgets/feature_tile.dart';
import '../widgets/section_card.dart';
import '../widgets/separated_list_view.dart';

class BugReportingScreen extends StatefulWidget {
  const BugReportingScreen({super.key});

  @override
  _BugReportingScreenState createState() => _BugReportingScreenState();
}

class _BugReportingScreenState extends State<BugReportingScreen> {
  final characterCountController = TextEditingController();
  final disclaimerTextController = TextEditingController();
  final floatingButtonOffsetController = TextEditingController();

  @override
  void dispose() {
    characterCountController.dispose();
    disclaimerTextController.dispose();
    floatingButtonOffsetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<BugReportingState>(context);
    floatingButtonOffsetController.text =
        state.selectedFloatingButtonOffset.toString();
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Bug Reporting',
          ),
        ),
        body: MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          removeTop: true,
          child: SeparatedListView(
            padding: const EdgeInsets.all(8.0),
            separator: const SizedBox(
              height: 8.0,
            ),
            children: <Widget>[
              SectionCard(
                children: [
                  FeatureTile(
                    leading: const Icon(Icons.bug_report),
                    title: const Text('Report a bug'),
                    onTap: () => BugReporting.show(
                      ReportType.bug,
                      state.selectedInvocationOptions.toList(),
                    ),
                  ),
                  FeatureTile(
                    leading: const Icon(Icons.feedback),
                    title: const Text('Suggest an improvement'),
                    onTap: () => BugReporting.show(
                      ReportType.feedback,
                      state.selectedInvocationOptions.toList(),
                    ),
                  ),
                  FeatureTile(
                    leading: const Icon(Icons.question_mark),
                    title: const Text('Ask a question'),
                    onTap: () => BugReporting.show(
                      ReportType.question,
                      state.selectedInvocationOptions.toList(),
                    ),
                  ),
                ],
              ),
              SectionCard(
                children: [
                  FeatureTile(
                    leading: const Icon(Icons.touch_app),
                    title: const Text('Invocation Events'),
                    bottom: ChipPicker(
                      items: state.invocationEvents.keys.toSet(),
                      values: state.selectedInvocationEvents,
                      labelBuilder: (value) => state.invocationEvents[value]!,
                      onChanged: (values) {
                        state.selectedInvocationEvents = values;
                        BugReporting.setInvocationEvents(
                          state.selectedInvocationEvents.toList(),
                        );
                      },
                    ),
                  ),
                  FeatureTile(
                    leading: const Icon(Icons.attachment),
                    title: const Text('Attachments'),
                    bottom: Wrap(
                      spacing: 4.0,
                      children: state.extraAttachments.keys
                          .toList()
                          .map((String attachment) {
                        return FilterChip(
                          label: Text(attachment),
                          selected: state.extraAttachments[attachment]!,
                          onSelected: (bool value) {
                            setState(() {
                              state.extraAttachments[attachment] = value;
                              BugReporting.setEnabledAttachmentTypes(
                                state.extraAttachments['Screenshot']!,
                                state.extraAttachments['Extra Screenshot']!,
                                state.extraAttachments['Gallery Image']!,
                                state.extraAttachments['Screen Recording']!,
                              );
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  FeatureTile(
                    leading: const Icon(Icons.dynamic_form),
                    title: const Text('Invocation Options'),
                    bottom: ChipPicker(
                      items: state.invocationOptions.keys.toSet(),
                      values: state.selectedInvocationOptions,
                      labelBuilder: (value) => state.invocationOptions[value]!,
                      onChanged: (values) {
                        state.selectedInvocationOptions = values;
                        BugReporting.setInvocationOptions(
                          state.selectedInvocationOptions.toList(),
                        );
                      },
                    ),
                  ),
                  Tooltip(
                    message:
                        'Minimum number of character required for the comments field',
                    child: FeatureTile(
                      leftFlex: 2,
                      leading: const Icon(Icons.comment),
                      title: const Text('Comment Minimum'),
                      right: Focus(
                        onFocusChange: (hasFocus) {
                          if (!hasFocus &&
                              characterCountController.text.isNotEmpty) {
                            BugReporting.setCommentMinimumCharacterCount(
                              int.parse(characterCountController.text),
                            );
                          }
                        },
                        child: TextField(
                          controller: characterCountController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                            border: OutlineInputBorder(),
                            hintText: 'Characters',
                          ),
                          enableInteractiveSelection: true,
                        ),
                      ),
                    ),
                  ),
                  FeatureTile(
                    leftFlex: 5,
                    leading: const Icon(Icons.keyboard_control),
                    title: const Text('Extended Report'),
                    rightFlex: 4,
                    right: DropdownMenu<ExtendedBugReportMode>(
                      width: 150,
                      initialSelection: state.extendedMode.keys.firstWhere(
                        (element) =>
                            state.extendedMode[element] ==
                            state.selectedExtendedMode,
                      ),
                      label: const Text('Mode'),
                      dropdownMenuEntries: state.extendedMode.keys
                          .map<DropdownMenuEntry<ExtendedBugReportMode>>(
                              (ExtendedBugReportMode mode) {
                        return DropdownMenuEntry<ExtendedBugReportMode>(
                          value: mode,
                          label: state.extendedMode[mode]!,
                        );
                      }).toList(),
                      onSelected: (ExtendedBugReportMode? mode) {
                        state.selectedExtendedMode = state.extendedMode[mode]!;
                        BugReporting.setExtendedBugReportMode(mode!);
                      },
                    ),
                  ),
                  FeatureTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('Disclaimer Text'),
                    bottom: TextField(
                      controller: disclaimerTextController,
                      keyboardType: TextInputType.multiline,
                      textAlign: TextAlign.left,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 8.0,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (String value) =>
                          BugReporting.setDisclaimerText(
                        disclaimerTextController.text,
                      ),
                      enableInteractiveSelection: true,
                    ),
                  ),
                ],
              ),
              SectionCard(
                children: [
                  FeatureTile(
                    leftFlex: 5,
                    leading: const Icon(Icons.videocam),
                    title: const Text('Recording Button'),
                    rightFlex: 4,
                    right: DropdownMenu<Position>(
                      width: 150,
                      initialSelection:
                          state.videoRecordingPosition.keys.firstWhere(
                        (element) =>
                            state.videoRecordingPosition[element] ==
                            state.selectedVideoRecordingPosition,
                      ),
                      label: const Text('Position'),
                      dropdownMenuEntries: state.videoRecordingPosition.keys
                          .map<DropdownMenuEntry<Position>>(
                              (Position position) {
                        return DropdownMenuEntry<Position>(
                          value: position,
                          label: state.videoRecordingPosition[position]!,
                        );
                      }).toList(),
                      onSelected: (Position? position) {
                        state.selectedVideoRecordingPosition =
                            state.videoRecordingPosition[position]!;
                        BugReporting.setVideoRecordingFloatingButtonPosition(
                          position!,
                        );
                      },
                    ),
                  ),
                  FeatureTile(
                    leftFlex: 5,
                    leading: const Icon(Icons.message),
                    title: const Text('Floating Button'),
                    rightFlex: 4,
                    right: DropdownMenu<FloatingButtonEdge>(
                      width: 150,
                      initialSelection:
                          state.floatingButtonEdge.keys.firstWhere(
                        (element) =>
                            state.floatingButtonEdge[element] ==
                            state.selectedFloatingButtonEdge,
                      ),
                      label: const Text('Edge'),
                      dropdownMenuEntries: state.floatingButtonEdge.keys
                          .map<DropdownMenuEntry<FloatingButtonEdge>>(
                              (FloatingButtonEdge edge) {
                        return DropdownMenuEntry<FloatingButtonEdge>(
                          value: edge,
                          label: state.floatingButtonEdge[edge]!,
                        );
                      }).toList(),
                      onSelected: (FloatingButtonEdge? edge) {
                        state.selectedFloatingButtonEdge =
                            state.floatingButtonEdge[edge]!;
                        BugReporting.setFloatingButtonEdge(
                          edge!,
                          state.selectedFloatingButtonOffset,
                        );
                      },
                    ),
                  ),
                  Tooltip(
                    message: 'Offset from top',
                    child: FeatureTile(
                      leftFlex: 2,
                      leading: const Icon(Icons.border_top),
                      title: const Text('Floating Button Offset'),
                      right: Focus(
                        onFocusChange: (hasFocus) {
                          if (!hasFocus &&
                              floatingButtonOffsetController.text.isNotEmpty) {
                            state.selectedFloatingButtonOffset = int.parse(
                              floatingButtonOffsetController.text,
                            );
                          } else if (!hasFocus &&
                              floatingButtonOffsetController.text.isEmpty) {
                            state.selectedFloatingButtonOffset = 100;
                          }
                          BugReporting.setFloatingButtonEdge(
                            state.floatingButtonEdge.keys.firstWhere(
                              (element) =>
                                  state.floatingButtonEdge[element] ==
                                  state.selectedFloatingButtonEdge,
                            ),
                            state.selectedFloatingButtonOffset,
                          );
                        },
                        child: TextField(
                          controller: floatingButtonOffsetController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                            border: OutlineInputBorder(),
                          ),
                          enableInteractiveSelection: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
