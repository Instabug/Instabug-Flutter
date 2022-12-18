using Instabug.Captain;

namespace E2E.Utils;

public class CaptainTest : IDisposable
{
  protected readonly Captain captain = new(
      androidApp: Path.GetFullPath("../../../../example/build/app/outputs/flutter-apk/app-debug.apk"),
      androidVersion: "11",
      iosApp: Path.GetFullPath("../../../../example/build/ios/iphonesimulator/Runner.app"),
      iosVersion: "15.5"
  );

  public void Dispose()
  {
    captain.ResetApp();
  }
}