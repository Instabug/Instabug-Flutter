part of '../../main.dart';

class BugReportingPage extends StatefulWidget {
  static const screenName = 'bugReporting';

  const BugReportingPage({Key? key}) : super(key: key);

  @override
  _BugReportingPageState createState() => _BugReportingPageState();
}

class _BugReportingPageState extends State<BugReportingPage> {
  List<ReportType> reportTypes = [
    ReportType.bug,
    ReportType.feedback,
    ReportType.question
  ];
  List<InvocationOption> invocationOptions = [];

  final disclaimerTextController = TextEditingController();

  bool attachmentsOptionsScreenshot = true;
  bool attachmentsOptionsExtraScreenshot = true;
  bool attachmentsOptionsGalleryImage = true;
  bool attachmentsOptionsScreenRecording = true;
  File? fileAttachment;
  CallbackHandlersProvider? callbackHandlerProvider;

  void restartInstabug() {
    Instabug.setEnabled(false);
    Instabug.setEnabled(true);
    BugReporting.setInvocationEvents([InvocationEvent.floatingButton]);
  }

  void setInvocationEvent(InvocationEvent invocationEvent) {
    BugReporting.setInvocationEvents([invocationEvent]);
  }

  @override
  void initState() {
    super.initState();
  }

  void setUserConsent(
    String key,
    String description,
    bool mandatory,
    bool checked,
    UserConsentActionType? actionType,
  ) {
    BugReporting.addUserConsents(
        key: key,
        description: description,
        mandatory: mandatory,
        checked: true,
        actionType: actionType);
  }

  void show() {
    Instabug.show();
  }

  Future<void> addFileAttachment() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      fileAttachment = File(result.files.single.path!);
      Instabug.addFileAttachmentWithURL(fileAttachment!.path,
          fileAttachment!.path.split('/').last.substring(0));
      setState(() {});
    }
  }

  void removeFileAttachment() {
    Instabug.clearFileAttachments();
  }

  void addAttachmentOptions() {
    BugReporting.setEnabledAttachmentTypes(
        attachmentsOptionsScreenshot,
        attachmentsOptionsExtraScreenshot,
        attachmentsOptionsGalleryImage,
        attachmentsOptionsScreenRecording);
  }

  void toggleReportType(ReportType reportType) {
    if (reportTypes.contains(reportType)) {
      reportTypes.remove(reportType);
    } else {
      reportTypes.add(reportType);
    }
    setState(() {});
    BugReporting.setReportTypes(reportTypes);
  }

  void addInvocationOption(InvocationOption invocationOption) {
    if (invocationOptions.contains(invocationOption)) {
      invocationOptions.remove(invocationOption);
    } else {
      invocationOptions.add(invocationOption);
    }
    BugReporting.setInvocationOptions(invocationOptions);
    // BugReporting.setInvocationOptions([invocationOption]);
  }

  void showDialogOnInvoke(BuildContext context) {
    BugReporting.setOnDismissCallback((dismissType, reportType) {
      if (dismissType == DismissType.submit) {
        showDialog(
            context: context,
            builder: (_) => const AlertDialog(
                  title: Text('Bug Reporting sent'),
                ));
      }
    });
  }

  void setOnDismissCallback(void Function(DismissType, ReportType) callback) {
    BugReporting.setOnDismissCallback((dismissType, reportType) {
      callback(dismissType, reportType);
    });
  }

  void setOnInvoiceCallback(VoidCallback callback) {
    BugReporting.setOnInvokeCallback(() {
      callback.call();
    });
  }

  void setDisclaimerText() {
    BugReporting.setDisclaimerText(disclaimerTextController.text);
  }

  @override
  void dispose() {
    disclaimerTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    callbackHandlerProvider = context.read<CallbackHandlersProvider>();

    return Page(
      title: 'Bug Reporting',
      children: [
        const SectionTitle('Enabling Bug Reporting'),
        InstabugButton(
          symanticLabel: 'id_restart_instabug_btn',
          key: const Key('instabug_restart'),
          onPressed: restartInstabug,
          text: 'Restart Instabug',
        ),
        InstabugButton(
          symanticLabel: 'id_disable_instabug_btn',
          key: const Key('instabug_disable'),
          onPressed: () => Instabug.setEnabled(false),
          text: "Disable Instabug",
        ),
        InstabugButton(
          symanticLabel: 'id_enable_instabug_btn',
          key: const Key('instabug_enable'),
          onPressed: () => Instabug.setEnabled(true),
          text: "Enable Instabug",
        ),
        InstabugButton(
          symanticLabel: 'id_enable_instabug_btn',
          key: const Key('instabug_post_sending_dialog'),
          onPressed: () => {showDialogOnInvoke(context)},
          text: "Set the post sending dialog",
        ),
        const SectionTitle('Invocation events'),
        ButtonBar(
          mainAxisSize: MainAxisSize.min,
          alignment: MainAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(
              key: const Key('invocation_event_none'),
              onPressed: () => setInvocationEvent(InvocationEvent.none),
              child: const Text('None'),
            ).withSemanticsLabel('invocation_event_none'),
            ElevatedButton(
              key: const Key('invocation_event_shake'),
              onPressed: () => setInvocationEvent(InvocationEvent.shake),
              child: const Text('Shake'),
            ).withSemanticsLabel('invocation_event_shake'),
            ElevatedButton(
              key: const Key('invocation_event_screenshot'),
              onPressed: () => setInvocationEvent(InvocationEvent.screenshot),
              child: const Text('Screenshot'),
            ).withSemanticsLabel('invocation_event_screenshot'),
          ],
        ),
        ButtonBar(
          mainAxisSize: MainAxisSize.min,
          alignment: MainAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(
              key: const Key('invocation_event_floating'),
              onPressed: () =>
                  setInvocationEvent(InvocationEvent.floatingButton),
              child: const Text('Floating Button'),
            ).withSemanticsLabel('invocation_event_floating'),
            ElevatedButton(
              key: const Key('invocation_event_two_fingers'),
              onPressed: () =>
                  setInvocationEvent(InvocationEvent.twoFingersSwipeLeft),
              child: const Text('Two Fingers Swipe Left'),
            ).withSemanticsLabel('invocation_event_two_fingers'),
          ],
        ),
        const SectionTitle('User Consent'),
        ButtonBar(
          mainAxisSize: MainAxisSize.min,
          alignment: MainAxisAlignment.start,
          layoutBehavior: ButtonBarLayoutBehavior.padded,
          children: <Widget>[
            ElevatedButton(
              key: const Key('user_consent_media_manadatory'),
              onPressed: () => setUserConsent(
                  'media_mandatory',
                  "Mandatory for Media",
                  true,
                  true,
                  UserConsentActionType.dropAutoCapturedMedia),
              child: const Text('Drop Media Mandatory'),
            ).withSemanticsLabel('user_consent_media_manadatory'),
            ElevatedButton(
              key: const Key('user_consent_no_chat_manadatory'),
              onPressed: () => setUserConsent(
                  'noChat_mandatory',
                  "Mandatory for No Chat",
                  true,
                  true,
                  UserConsentActionType.noChat),
              child: const Text('No Chat Mandatory'),
            ).withSemanticsLabel('user_consent_no_chat_manadatory'),
          ],
        ),
        ButtonBar(
          mainAxisSize: MainAxisSize.min,
          alignment: MainAxisAlignment.start,
          layoutBehavior: ButtonBarLayoutBehavior.padded,
          children: <Widget>[
            ElevatedButton(
              key: const Key('user_consent_drop_logs_manadatory'),
              onPressed: () => setUserConsent(
                  'dropLogs_mandatory',
                  "Mandatory for Drop logs",
                  true,
                  true,
                  UserConsentActionType.dropLogs),
              child: const Text('Drop logs Mandatory'),
            ).withSemanticsLabel('user_consent_drop_logs_manadatory'),
            ElevatedButton(
              key: const Key('user_consent_no_chat_optional'),
              onPressed: () => setUserConsent(
                  'noChat_mandatory',
                  "Optional for No Chat",
                  false,
                  true,
                  UserConsentActionType.noChat),
              child: const Text('No Chat optional'),
            ).withSemanticsLabel('user_consent_no_chat_optional'),
          ],
        ),
        const SectionTitle('Invocation Options'),
        ButtonBar(
          mainAxisSize: MainAxisSize.min,
          alignment: MainAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(
              key: const Key('invocation_option_disable_post_sending_dialog'),
              onPressed: () => addInvocationOption(
                  InvocationOption.disablePostSendingDialog),
              child: const Text('disablePostSendingDialog'),
            ).withSemanticsLabel(
                'invocation_option_disable_post_sending_dialog'),
            ElevatedButton(
              key: const Key('invocation_option_email_hidden'),
              onPressed: () =>
                  addInvocationOption(InvocationOption.emailFieldHidden),
              child: const Text('emailFieldHidden'),
            ).withSemanticsLabel('invocation_option_email_hidden'),
          ],
        ),
        ButtonBar(
          mainAxisSize: MainAxisSize.min,
          alignment: MainAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(
              key: const Key('invocation_option_comment_required'),
              onPressed: () =>
                  addInvocationOption(InvocationOption.commentFieldRequired),
              child: const Text('commentFieldRequired'),
            ).withSemanticsLabel('invocation_option_comment_required'),
            ElevatedButton(
              onPressed: () =>
                  addInvocationOption(InvocationOption.emailFieldOptional),
              child: const Text('emailFieldOptional'),
            ).withSemanticsLabel('invocation_option_email_required'),
          ],
        ),
        InstabugButton(
          key: const Key('instabug_show'),
          onPressed: show,
          symanticLabel: 'instabug_show',
          text: 'Invoke',
        ),
        const SectionTitle('Attachment Options'),
        Wrap(
          children: [
            CheckboxListTile(
              isThreeLine: false,
              tristate: false,
              value: attachmentsOptionsScreenshot,
              onChanged: (value) {
                setState(() {
                  attachmentsOptionsScreenshot = value ?? false;
                });
                addAttachmentOptions();
              },
              title: const Text("Screenshot"),
              subtitle: const Text('Enable attachment for screenShot'),
              key: const Key('attachment_option_screenshot'),
            ).withSemanticsLabel('attachment_option_screenshot'),
            CheckboxListTile(
              value: attachmentsOptionsExtraScreenshot,
              onChanged: (value) {
                setState(() {
                  attachmentsOptionsExtraScreenshot = value ?? false;
                });
                addAttachmentOptions();
              },
              title: const Text("Extra Screenshot"),
              subtitle: const Text('Enable attachment for extra screenShot'),
              key: const Key('attachment_option_extra_screenshot'),
            ).withSemanticsLabel('attachment_option_extra_screenshot'),
            CheckboxListTile(
              value: attachmentsOptionsGalleryImage,
              onChanged: (value) {
                setState(() {
                  attachmentsOptionsGalleryImage = value ?? false;
                });
                addAttachmentOptions();
              },
              title: const Text("Gallery"),
              subtitle: const Text('Enable attachment for gallery'),
              key: const Key('attachment_option_gallery'),
            ).withSemanticsLabel('attachment_option_gallery'),
            CheckboxListTile(
              value: attachmentsOptionsScreenRecording,
              onChanged: (value) {
                setState(() {
                  attachmentsOptionsScreenRecording = value ?? false;
                });
                addAttachmentOptions();
              },
              title: const Text("Screen Recording"),
              subtitle: const Text('Enable attachment for screen Recording'),
              key: const Key('attachment_option_screen_recording'),
            ).withSemanticsLabel('attachment_option_screen_recording'),
          ],
        ),
        const SectionTitle('Bug reporting type'),
        ButtonBar(
          mainAxisSize: MainAxisSize.min,
          alignment: MainAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(
              key: const Key('bug_report_type_bug'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: reportTypes.contains(ReportType.bug)
                      ? Colors.grey.shade400
                      : null),
              onPressed: () => toggleReportType(ReportType.bug),
              child: const Text('Bug'),
            ).withSemanticsLabel('bug_report_type_bug'),
            ElevatedButton(
              key: const Key('bug_report_type_feedback'),
              onPressed: () => toggleReportType(ReportType.feedback),
              style: ElevatedButton.styleFrom(
                  backgroundColor: reportTypes.contains(ReportType.feedback)
                      ? Colors.grey.shade400
                      : null),
              child: const Text('Feedback'),
            ).withSemanticsLabel('bug_report_type_feedback'),
            ElevatedButton(
              key: const Key('bug_report_type_question'),
              onPressed: () => toggleReportType(ReportType.question),
              style: ElevatedButton.styleFrom(
                  backgroundColor: reportTypes.contains(ReportType.question)
                      ? Colors.grey.shade400
                      : null),
              child: const Text('Question'),
            ).withSemanticsLabel('bug_report_type_question'),
          ],
        ),
        CheckboxListTile(
          value: reportTypes.contains(ReportType.bug),
          onChanged: (value) {
            toggleReportType(ReportType.bug);
            setState(() {});
          },
          title: const Text("Bug"),
          subtitle: const Text('Enable Bug reporting type'),
          key: const Key('bug_report_type_bug'),
        ).withSemanticsLabel('bug_report_type_question'),
        CheckboxListTile(
          value: reportTypes.contains(ReportType.feedback),
          onChanged: (value) {
            toggleReportType(ReportType.feedback);
            setState(() {});
          },
          title: const Text("Feedback"),
          subtitle: const Text('Enable Feedback reporting type'),
          key: const Key('bug_report_type_feedback'),
        ).withSemanticsLabel('bug_report_type_question'),
        CheckboxListTile(
          value: reportTypes.contains(ReportType.question),
          onChanged: (value) {
            toggleReportType(ReportType.question);
            setState(() {});
          },
          title: const Text("Question"),
          subtitle: const Text('Enable Question reporting type'),
          key: const Key('bug_report_type_question'),
        ).withSemanticsLabel('bug_report_type_question'),
        InstabugButton(
          symanticLabel: 'id_send_bug',
          onPressed: () => {
            BugReporting.show(
                ReportType.bug, [InvocationOption.emailFieldOptional])
          },
          text: 'Send Bug Report',
        ),
        const SectionTitle('Disclaimer Text'),
        InstabugTextField(
          key: const Key('disclaimer_text'),
          controller: disclaimerTextController,
          label: 'Enter disclaimer Text',
          symanticLabel: 'id_disclaimer_input',
        ),
        ElevatedButton(
          key: const Key('set_disclaimer_text'),
          onPressed: () => setDisclaimerText,
          child: const Text('set disclaimer text'),
        ).withSemanticsLabel('set_disclaimer_text'),
        const SectionTitle('Extended Bug Reporting'),
        ButtonBar(
          mainAxisSize: MainAxisSize.min,
          alignment: MainAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(
              key: const Key('extended_bug_report_mode_disabled'),
              onPressed: () => BugReporting.setExtendedBugReportMode(
                  ExtendedBugReportMode.disabled),
              child: const Text('disabled'),
            ).withSemanticsLabel('extended_bug_report_mode_disabled'),
            ElevatedButton(
              key:
                  const Key('extended_bug_report_mode_required_fields_enabled'),
              onPressed: () => BugReporting.setExtendedBugReportMode(
                  ExtendedBugReportMode.enabledWithRequiredFields),
              child: const Text('enabledWithRequiredFields'),
            ).withSemanticsLabel(
                'extended_bug_report_mode_required_fields_enabled'),
          ],
        ),
        ButtonBar(
          mainAxisSize: MainAxisSize.min,
          alignment: MainAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(
              key:
                  const Key('extended_bug_report_mode_optional_fields_enabled'),
              onPressed: () => BugReporting.setExtendedBugReportMode(
                  ExtendedBugReportMode.enabledWithOptionalFields),
              child: const Text('enabledWithOptionalFields'),
            ).withSemanticsLabel(
                'extended_bug_report_mode_optional_fields_enabled'),
          ],
        ),
        const SectionTitle('Set Callback After Discarding'),
        InstabugButton(
          symanticLabel: 'enable_onDismiss_callback',
          onPressed: () {
            setOnDismissCallback((dismissType, reportType) {
              callbackHandlerProvider?.addItem(
                  'On Dismiss Handler',
                  Item(id: 'event - ${math.Random().nextInt(99999)}', fields: [
                    KeyValuePair(
                        key: 'Date', value: DateTime.now().toIso8601String())
                  ]));

              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('On Dismiss'),
                    content: Text(
                      'onDismiss callback called with $dismissType and $reportType',
                    ),
                  );
                },
              );
            });
          },
          text: 'Enable Set On Dismiss Callback',
        ),
        InstabugButton(
          symanticLabel: 'disable_onDismiss_callback',
          onPressed: () {
            setOnDismissCallback((dismissType, reportType) {});
          },
          text: 'Disable Set On Dismiss Callback',
        ),
        InstabugButton(
          symanticLabel: 'crash_onDismiss_callback',
          onPressed: () {
            setOnDismissCallback((dismissType, reportType) {
              callbackHandlerProvider?.addItem(
                  'On Dismiss Handler',
                  Item(id: 'event - ${math.Random().nextInt(99999)}', fields: [
                    KeyValuePair(
                        key: 'Date', value: DateTime.now().toIso8601String())
                  ]));
              throw Exception("Exception from setOnDismissCallback");
            });
          },
          text: 'Set On Dismiss Callback with Exception',
        ),
        InstabugButton(
          symanticLabel: 'disable_onInvoice_callback',
          onPressed: () {
            setOnInvoiceCallback(() {
              callbackHandlerProvider?.addItem(
                  'Invoke Handler',
                  Item(id: 'event - ${math.Random().nextInt(99999)}', fields: [
                    KeyValuePair(
                        key: 'Date', value: DateTime.now().toIso8601String())
                  ]));

              showDialog(
                context: context,
                builder: (context) {
                  return const AlertDialog(
                    title: Text('On Invoice Callback'),
                    content: Text(
                      'setOnInvoice callback called',
                    ),
                  );
                },
              );
            });
          },
          text: 'Set On Invoice Callback',
        ),
        InstabugButton(
          onPressed: () {
            setOnInvoiceCallback(() {});
          },
          text: 'Disable On Invoice Callback',
        ),
        InstabugButton(
            symanticLabel: 'crash_onInvoice_callback',
            onPressed: () {
              setOnInvoiceCallback(() {
                callbackHandlerProvider?.addItem(
                    'Invoke Handler',
                    Item(
                        id: 'event - ${math.Random().nextInt(99999)}',
                        fields: [
                          KeyValuePair(
                              key: 'Date',
                              value: DateTime.now().toIso8601String())
                        ]));
                throw Exception("Exception from setOnInvoiceCallback");
              });
            },
            text: 'Set On Invoice Callback with Exception'),
        const SectionTitle('Attachments'),
        if (fileAttachment != null)
          Text(fileAttachment!.path.split('/').last.substring(0) + " Attached"),
        InstabugButton(
          onPressed: addFileAttachment,
          text: 'Add file attachment',
          symanticLabel: 'add_file_attachment',
        ),
        InstabugButton(
          onPressed: removeFileAttachment,
          text: 'Clear All attachment',
          symanticLabel: 'clear_file_attachment',
        ),
      ], // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
