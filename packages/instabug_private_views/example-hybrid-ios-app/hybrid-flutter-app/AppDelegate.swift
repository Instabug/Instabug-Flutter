//
//  AppDelegate.swift
//  hybrid-flutter-app
//
//  Created by Ahmed alaa on 29/10/2024.
//

import UIKit
import Flutter
import FlutterPluginRegistrant
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var flutterEngine: FlutterEngine!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        flutterEngine = FlutterEngine(name: "my flutter engine")
            flutterEngine.run()
        GeneratedPluginRegistrant.register(with: flutterEngine)

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

