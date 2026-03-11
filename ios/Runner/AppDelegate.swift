import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Setup AppGroup for HomeWidget
    let appGroupId = Bundle.main.object(forInfoDictionaryKey: "HomeWidgetAppGroupId") as? String
      ?? "group.com.example.lifeQuestWidget"
    if let userDefaults = UserDefaults(suiteName: appGroupId) {
      userDefaults.set("Ready", forKey: "widgetStatus")
    }

    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
