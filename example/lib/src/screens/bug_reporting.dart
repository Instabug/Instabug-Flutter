part of '../../main.dart';

class BugReportingPage extends StatefulWidget {
  static const screenName = 'bugReporting';

  const BugReportingPage({Key? key}) : super(key: key);

  @override
  _BugReportingPageState createState() => _BugReportingPageState();
}

class _BugReportingPageState extends State<BugReportingPage> {
  List<ReportType> reportTypes = [];
  List<InvocationOption> invocationOptions = [];

  final disclaimerTextController = TextEditingController();

  void restartInstabug() {
    Instabug.setEnabled(false);
    Instabug.setEnabled(true);
    BugReporting.setInvocationEvents([InvocationEvent.floatingButton]);
  }

  void setInvocationEvent(InvocationEvent invocationEvent) {
    BugReporting.setInvocationEvents([invocationEvent]);
  }

  void show() {
    Instabug.show();
  }

  void toggleReportType(ReportType reportType) {
    if (reportTypes.contains(reportType)) {
      reportTypes.remove(reportType);
    } else {
      reportTypes.add(reportType);
    }
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

  void setOnDismissCallback() {
    BugReporting.setOnDismissCallback((dismissType, reportType) {
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
    return Page(
      title: 'Bug Reporting',
      children: [
        const SectionTitle('Enabling Bug Reporting'),
        InstabugButton(
          key: const Key('instabug_restart'),
          onPressed: restartInstabug,
          text: 'Restart Instabug',
        ),
        InstabugButton(
          key: const Key('instabug_disable'),
          onPressed: () => Instabug.setEnabled(false),
          text: "Disable Instabug",
        ),
        InstabugButton(
          key: const Key('instabug_enable'),
          onPressed: () => Instabug.setEnabled(true),
          text: "Enable Instabug",
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
            ),
            ElevatedButton(
              key: const Key('invocation_event_shake'),
              onPressed: () => setInvocationEvent(InvocationEvent.shake),
              child: const Text('Shake'),
            ),
            ElevatedButton(
              key: const Key('invocation_event_screenshot'),
              onPressed: () => setInvocationEvent(InvocationEvent.screenshot),
              child: const Text('Screenshot'),
            ),
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
            ),
            ElevatedButton(
              key: const Key('invocation_event_two_fingers'),
              onPressed: () =>
                  setInvocationEvent(InvocationEvent.twoFingersSwipeLeft),
              child: const Text('Two Fingers Swipe Left'),
            ),
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
            ),
            ElevatedButton(
              key: const Key('invocation_option_email_hidden'),
              onPressed: () =>
                  addInvocationOption(InvocationOption.emailFieldHidden),
              child: const Text('emailFieldHidden'),
            ),
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
            ),
            ElevatedButton(
              onPressed: () =>
                  addInvocationOption(InvocationOption.emailFieldOptional),
              child: const Text('emailFieldOptional'),
            ),
          ],
        ),
        InstabugButton(
          key: const Key('instabug_show'),
          onPressed: show,
          text: 'Invoke',
        ),
        const SectionTitle('Disclaimer Text'),
        InstabugTextField(
          key: const Key('disclaimer_text'),
          controller: disclaimerTextController,
          label: 'Enter disclaimer Text',
        ),
        ElevatedButton(
          key: const Key('set_disclaimer_text'),
          onPressed: () => setDisclaimerText,
          child: const Text('set disclaimer text'),
        ),
        const SectionTitle('Bug Report Types'),
        ButtonBar(
          mainAxisSize: MainAxisSize.min,
          alignment: MainAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(
              key: const Key('bug_report_type_bug'),
              onPressed: () => toggleReportType(ReportType.bug),
              child: const Text('Bug'),
            ),
            ElevatedButton(
              key: const Key('bug_report_type_feedback'),
              onPressed: () => toggleReportType(ReportType.feedback),
              child: const Text('Feedback'),
            ),
            ElevatedButton(
              key: const Key('bug_report_type_question'),
              onPressed: () => toggleReportType(ReportType.question),
              child: const Text('Question'),
            ),
          ],
        ),
        InstabugButton(
          onPressed: () => {
            BugReporting.show(
                ReportType.bug, [InvocationOption.emailFieldOptional])
          },
          text: 'Send Bug Report',
        ),
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
            ),
            ElevatedButton(
              key:
                  const Key('extended_bug_report_mode_required_fields_enabled'),
              onPressed: () => BugReporting.setExtendedBugReportMode(
                  ExtendedBugReportMode.enabledWithRequiredFields),
              child: const Text('enabledWithRequiredFields'),
            ),
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
            ),
          ],
        ),
        const SectionTitle('Set Callback After Discarding'),
        InstabugButton(
          onPressed: setOnDismissCallback,
          text: 'Set On Dismiss Callback',
        ),
      ], // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
