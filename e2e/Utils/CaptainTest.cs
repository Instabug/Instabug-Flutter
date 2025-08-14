using System.Drawing;
using Instabug.Captain;
using OpenQA.Selenium;
using OpenQA.Selenium.Appium.MultiTouch;

namespace E2E.Utils;

public class CaptainTest : IDisposable
{
  private static readonly CaptainConfig _config = new()
  {
    AndroidApp = Path.GetFullPath("../../../../packages/instabug_flutter/example/build/app/outputs/flutter-apk/app-debug.apk"),
    AndroidAppId = "com.instabug.flutter.example",
    AndroidVersion = "13",

    IosApp = Path.GetFullPath("../../../../packages/instabug_flutter/example/build/ios/iphonesimulator/Runner.app"),
    IosAppId = "com.instabug.InstabugSample",
    IosVersion = "17.2",
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


}
