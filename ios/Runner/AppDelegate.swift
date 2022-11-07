import UIKit
import Flutter
import GoogleMaps  // Add this import

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // Add Google Maps API Key
    GMSServices.provideAPIKey("AIzaSyBXgp7mOQ6cBaFrptdz0Tld7M30O4IxJyE")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
