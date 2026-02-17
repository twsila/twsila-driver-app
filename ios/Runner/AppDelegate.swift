import UIKit
import Flutter
import GoogleMaps
import FirebaseCore

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyD8KjkW8eLaDD3qeZIiPPDxqfdK8olftWs")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
