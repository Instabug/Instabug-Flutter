import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: kInstabugChannelName, binaryMessenger: controller.binaryMessenger)
        let methodCallHandler = InstabugExampleMethodCallHandler()
        channel.setMethodCallHandler { methodCall, result in
            methodCallHandler.handle(methodCall, result: result)
        }
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
