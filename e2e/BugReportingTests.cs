using E2E.Utils;
using Xunit;
using Instabug.Captain;

namespace E2E;

[Collection("E2E")]
public class BugReportingTests : CaptainTest
{
  [Fact]
  public void ReportABug()
  {
    captain.FindById(
        android: "instabug_floating_button",
        ios: "IBGFloatingButtonAccessibilityIdentifier"
    ).Tap();

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
