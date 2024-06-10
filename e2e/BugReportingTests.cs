using System.Drawing;
using E2E.Utils;
using Xunit;
using Instabug.Captain;

using NoSuchElementException = OpenQA.Selenium.NoSuchElementException;

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
  public void FloatingButtonInvocationEvent()
  {
    captain.FindById(
        android: "instabug_floating_button",
        ios: "IBGFloatingButtonAccessibilityIdentifier"
    ).Tap();

    AssertOptionsPromptIsDisplayed();
  }

  [Fact]
  public void ShakeInvocationEvent()
  {
    if (!Platform.IsIOS) return;

    captain.FindByText("Shake").Tap();

    captain.Shake();

    AssertOptionsPromptIsDisplayed();
  }

  [Fact]
  public void TwoFingersSwipeLeftInvocationEvent()
  {
    ScrollUp();
    captain.FindByText("Two Fingers Swipe Left").Tap();

    Thread.Sleep(500);

    // Do a two-finger swipe left
    var width = captain.Window.Size.Width;
    captain.TwoFingerSwipe(
        new Point(width - 50, 300),
        new Point(50, 300),
        new Point(width - 50, 350),
        new Point(50, 350)
    );

    AssertOptionsPromptIsDisplayed();
  }

  [Fact]
  public void NoneInvocationEvent()
  {
    captain.FindByText("None").Tap();

    captain.WaitForAssertion(() =>
      Assert.Throws<NoSuchElementException>(() =>
        captain.FindById(
            android: "instabug_floating_button",
            ios: "IBGFloatingButtonAccessibilityIdentifier",
            wait: false
        )
      )
    );
  }

  [Fact]
  public void ManualInvocation()
  {
    captain.FindByText("Invoke").Tap();

    AssertOptionsPromptIsDisplayed();
  }

  [Fact]
  public void MultipleScreenshotsInReproSteps()
  {
    ScrollDown();

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
    ScrollUp();
    captain.FindByText("Bug", exact: true).Tap();

    if (Platform.IsAndroid)
    {
      captain.FindByText("Invoke").Tap();

      // Shows bug reporting screen
      Assert.True(captain.FindById("ib_bug_scroll_view").Displayed);

      // Close bug reporting screen
      captain.GoBack();
      captain.FindByText("DISCARD").Tap();

      Thread.Sleep(500);

    }

    captain.FindByText("Feedback").Tap();

    captain.FindByText("Invoke").Tap();

    // Shows both bug reporting and feature requests in prompt options
    AssertOptionsPromptIsDisplayed();

    Assert.True(captain.FindByText("Report a bug").Displayed);
    Assert.True(captain.FindByText("Suggest an improvement").Displayed);
    Assert.Throws<NoSuchElementException>(() => captain.FindByText("Ask a question", wait: false));
  }

  [Fact]
  public void ChangeFloatingButtonEdge()
  {
    ScrollDown();
    captain.FindByText("Move Floating Button to Left").Tap();

    Thread.Sleep(500);

    captain.WaitForAssertion(() =>
    {
      var floatingButton = captain.FindById(
          android: "instabug_floating_button",
          ios: "IBGFloatingButtonAccessibilityIdentifier"
      );
      var screenWidth = captain.Window.Size.Width;

      Assert.True(floatingButton.Location.X < screenWidth / 2);
    });
  }

  [Fact]
  public void OnDismissCallbackIsCalled()
  {
    ScrollDownLittle();

    captain.FindByText("Set On Dismiss Callback").Tap();
    captain.FindByText("Invoke").Tap();

    AssertOptionsPromptIsDisplayed();

    captain.FindByText("Cancel").Tap();

    var popUpText = captain.FindByText("onDismiss callback called with DismissType.cancel and ReportType.other");
    Assert.True(popUpText.Displayed);
  }
}
