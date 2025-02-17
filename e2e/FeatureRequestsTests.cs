using E2E.Utils;
using Instabug.Captain;
using Xunit;

namespace E2E;

[Collection("E2E")]
public class FeatureRequestsTests : CaptainTest
{
  [Fact]
  public void ShowFeatureRequetsScreen()
  {

    Console.WriteLine("ShowFeatureRequetsScreen");

    captain.FindByTextScroll("Show Feature Requests").Tap();

    var screenTitle = captain.FindById(
        android: "ib_fr_toolbar_main",
        ios: "IBGFeatureListTableView"
    );
    Assert.True(screenTitle.Displayed);
  }
}
