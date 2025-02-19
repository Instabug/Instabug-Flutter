using E2E.Utils;
using Xunit;
using Instabug.Captain;

using NoSuchElementException = OpenQA.Selenium.NoSuchElementException;
using System.Drawing;

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

      Console.WriteLine("FloatingButtonInvocationEvent");

    captain.FindById(
        android: "instabug_floating_button",
        ios: "IBGFloatingButtonAccessibilityIdentifier"
    ).Tap();

    AssertOptionsPromptIsDisplayed();
  }

  [Fact]
  public void ShakeInvocationEvent()
  {

          Console.WriteLine("ShakeInvocationEvent");

    if (!Platform.IsIOS) return;


    captain.FindByTextScroll("Shake").Tap();

    captain.Shake();

    AssertOptionsPromptIsDisplayed();
  }

  [Fact]
  public void TwoFingersSwipeLeftInvocationEvent()
  {

              Console.WriteLine("TwoFingersSwipeLeftInvocationEvent");



    captain.FindByTextScroll("Two Fingers Swipe Left").Tap();

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

                  Console.WriteLine("NoneInvocationEvent");


    captain.FindByTextScroll("None").Tap();

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


                  Console.WriteLine("ManualInvocation");



    captain.FindByTextScroll("Invoke").Tap();

    AssertOptionsPromptIsDisplayed();
  }

  [Fact]
  public void MultipleScreenshotsInReproSteps()
  {


    Console.WriteLine("MultipleScreenshotsInReproSteps");




captain.FindByTextScroll("Enter screen name").Tap();
    captain.Type("My Screen");
    captain.HideKeyboard();

    captain.HideKeyboard();
    Thread.Sleep(500);

    captain.FindByTextScroll("Report Screen Change")?.Tap();
    Thread.Sleep(500);
    captain.FindByTextScroll("Send Bug Report")?.Tap();

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

  [Fact(Skip = "The test is flaky on iOS so we're skipping it to unblock the v13.2.0 release")]
  public void ChangeReportTypes()
  {

    Console.WriteLine("ChangeReportTypes");


    captain.FindByTextScroll("Bug", exact: true).Tap();

    if (Platform.IsAndroid)
    {
      captain.FindByTextScroll("Invoke").Tap();

      // Shows bug reporting screen
      Assert.True(captain.FindById("ib_bug_scroll_view").Displayed);

      // Close bug reporting screen
      captain.GoBack();
      captain.FindByTextScroll("DISCARD").Tap();

      Thread.Sleep(500);

    }

    captain.FindByTextScroll("Feedback").Tap();

    captain.FindByTextScroll("Invoke").Tap();

    // Shows both bug reporting and feature requests in prompt options
    AssertOptionsPromptIsDisplayed();

    Assert.True(captain.FindByText("Report a bug").Displayed);
    Assert.True(captain.FindByText("Suggest an improvement").Displayed);
    Assert.Throws<NoSuchElementException>(() => captain.FindByText("Ask a question", wait: false));
  }

  [Fact]
  public void ChangeFloatingButtonEdge()
  {

    Console.WriteLine("ChangeFloatingButtonEdge");


    captain.FindByTextScroll("Move Floating Button to Left",false,false)?.Tap();


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

    captain.FindByTextScroll("Set On Dismiss Callback",false,false).Tap();
    captain.FindByTextScroll("Invoke",false,false).Tap();

    AssertOptionsPromptIsDisplayed();

    captain.FindByTextScroll("Cancel").Tap();

    var popUpText = captain.FindByText("onDismiss callback called with DismissType.cancel and ReportType.other");
    Assert.True(popUpText.Displayed);

  }
}
