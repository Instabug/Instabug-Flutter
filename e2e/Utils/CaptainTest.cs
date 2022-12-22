using System.Drawing;
using Instabug.Captain;

namespace E2E.Utils;

public class CaptainTest : IDisposable
{
  private static readonly CaptainConfig _config = new()
  {
    AndroidApp = Path.GetFullPath("../../../../example/build/app/outputs/flutter-apk/app-debug.apk"),
    AndroidVersion = "11",
    IosApp = Path.GetFullPath("../../../../example/build/ios/iphonesimulator/Runner.app"),
    IosVersion = "15.5"
  };
  protected readonly Captain captain = new(_config);

  public CaptainTest()
  {
    // Wait till the app is ready
    captain.FindByText("Hello Instabug");
  }

  public void Dispose()
  {
    captain.ResetApp();
  }
}
