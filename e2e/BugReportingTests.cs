using E2E.Utils;
using Xunit;
using Instabug.Captain;

namespace E2E;

[Collection("E2E")]
public class BugReportingTests : CaptainTest
{
  private void AssertOptionsPromptIsDisplayed()
  {
    var optionsPrompt = captain.FindById(
        android: "instabug_main_prompt_container",
        ios: "IBGReportBugPromptOptionAccessibilityIdentifier"
    );

    Assert.True(optionsPrompt.Displayed);
  }

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

  [Fact]
  public void MultipleScreenshotsInReproSteps()
  {
    captain.FindByText("Enter screen name").Tap();
    captain.Type("My Screen");
    captain.HideKeyboard();

    captain.FindByText("Report Screen Change").Tap();
    captain.FindByText("Send Bug Report").Tap();
    captain.FindById(
        android: "instabug_text_view_repro_steps_disclaimer",
        ios: "IBGBugVCReproStepsDisclaimerAccessibilityIdentifier"
    ).Tap();

    var reproSteps = captain.FindManyById(
        android: "ib_bug_repro_step_screenshot",
        ios: "IBGReproStepsTableCellViewAccessibilityIdentifier"
    );
    Assert.Equal(2, reproSteps.Count);
  }

  [Fact]
  public void ChangeReportTypes()
  {
    ScrollDown();
    captain.FindByText("Bug", exact: true).Tap();

    ScrollUp();
    captain.FindByText("Invoke").Tap();

    if (Platform.IsAndroid)
    {
      // Shows bug reporting screen
      Assert.True(captain.FindById("ib_bug_scroll_view").Displayed);

      // Close bug reporting screen
      captain.GoBack();
      captain.FindByText("DISCARD").Tap();
    }

    // Enable feedback reports
    ScrollDown();
    captain.FindByText("Feedback").Tap();

    ScrollUp();
    captain.FindByText("Invoke").Tap();

    // Shows both bug reporting and feature requests in prompt options
    AssertOptionsPromptIsDisplayed();

    Assert.True(captain.FindByText("Report a bug").Displayed);
    Assert.True(captain.FindByText("Suggest an improvement").Displayed);
    Assert.ThrowsAny<Exception>(() => captain.FindByText("Ask a question"));
  }

  [Fact]
  public void ChangeFloatingButtonEdge()
  {
    captain.FindByText("Floating Button").Tap();
    ScrollDown();
    captain.FindByText("Move Floating Button to Left").Tap();

    var floatingButton = captain.FindById(
        android: "instabug_floating_button",
        ios: "IBGFloatingButtonAccessibilityIdentifier"
    );
    var screenWidth = captain.Window.Size.Width;

    Assert.True(floatingButton.Location.X < screenWidth / 2);
  }
}
