using System.Drawing;
using E2E.Utils;
using Instabug.Captain;
using Xunit;

namespace E2E;

[Collection("E2E")]
public class InstabugTests : CaptainTest
{
  [Fact]
  public void ChangePrimaryColor()
  {
    Console.WriteLine("ChangePrimaryColor");

    var color = "#FF0000";
    var expected = Color.FromArgb(255, 0, 0);

    captain.FindByTextScroll("Enter primary color").Tap();
    captain.Type(color);
    captain.HideKeyboard();

    captain.FindByTextScroll("Change Primary Color").Tap();

    captain.WaitForAssertion(() =>
    {
      var floatingButton = captain.FindById(
          android: "instabug_floating_button",
          ios: "IBGFloatingButtonAccessibilityIdentifier"
      );

      var x = floatingButton.Location.X + floatingButton.Size.Width / 2;
      var y = floatingButton.Location.Y + Platform.Choose(android: 15, ios: 5);
      var actual = captain.GetPixel(x, y);

      // Assert actual color is close to expected color
      Assert.InRange(actual.R, expected.R - 10, expected.R + 10);
      Assert.InRange(actual.G, expected.G - 10, expected.G + 10);
      Assert.InRange(actual.B, expected.B - 10, expected.B + 10);
    });
  }
}
