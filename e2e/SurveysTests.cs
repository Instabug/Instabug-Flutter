using E2E.Utils;
using Instabug.Captain;
using Xunit;

namespace E2E;

[Collection("E2E")]
public class SurveysTests : CaptainTest
{
  [Fact]
  public void ShowManualSurvey()
  {
        Console.WriteLine("ShowManualSurvey");

    captain.FindByTextScroll("Show Manual Survey").Tap();

    captain.WaitForAssertion(() =>
    {
      var surveyDialog = captain.FindById(
          android: "instabug_survey_dialog_container",
          ios: "SurveyNavigationVC"
      );
      Assert.True(surveyDialog.Displayed);
    });
  }
}

