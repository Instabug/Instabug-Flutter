using System.Drawing;
using Instabug.Captain;

namespace E2E.Utils;

public class CaptainTest : IDisposable
{
  private static readonly CaptainConfig _config = new()
  {
    AndroidApp = Path.GetFullPath("../../../../example/build/app/outputs/flutter-apk/app-debug.apk"),
    AndroidAppId = "com.instabug.flutter.example",
    AndroidVersion = "11",
    IosApp = Path.GetFullPath("../../../../example/build/ios/iphonesimulator/Runner.app"),
    IosAppId = "com.instabug.InstabugSample",
    IosVersion = "17.4",
    IosDevice = "iPhone 15 Pro Max"
  };
  protected static readonly Captain captain = new(_config);

  public CaptainTest()
  {
    // Wait till the app is ready
    captain.FindByText("Hello Instabug");
  }

  public void Dispose()
  {
    captain.RestartApp();
  }

  protected void ScrollDown()
  {
    captain.Swipe(
        start: new Point(captain.Window.Size.Width / 2, captain.Window.Size.Height - 200),
        end: new Point(captain.Window.Size.Width / 2, 250)
    );
  }

  protected void ScrollUp()
  {
    captain.Swipe(
        start: new Point(captain.Window.Size.Width / 2, 250),
        end: new Point(captain.Window.Size.Width / 2, captain.Window.Size.Height - 200)
    );
  }
}
