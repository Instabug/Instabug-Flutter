using Xunit;
using Instabug.Captain;

namespace E2E;

public class BugReporting
{
  readonly Captain captain = new(
      androidApp: Path.GetFullPath("../../../../build/app/outputs/flutter-apk/app-debug.apk"),
      androidVersion: "11",
      iosApp: Path.GetFullPath("../../../../build/ios/iphonesimulator/Runner.app"),
      iosVersion: "15.5"
  );

  [Fact]
  public void ReportABug()
  {
    captain.FindById(
        android: "instabug_floating_button",
        ios: "IBGFloatingButtonAccessibilityIdentifier"
    ).Tap();

    if (captain.IsAndroid) captain.GoBack();

    captain.FindByText("Report a bug").Tap();

    captain.FindInput(
        android: "instabug_edit_text_email",
        ios: "IBGBugInputViewEmailFieldAccessibilityIdentifier"
    ).Type("inst@bug.com");

    captain.FindById(
        android: "instabug_bugreporting_send",
        ios: "IBGBugVCNextButtonAccessibilityIdentifier"
    ).Tap();

    Assert.True(captain.FindByText("Thank you").Displayed);
  }
}
