import Flutter
import UIKit
import UniformTypeIdentifiers

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "FalcoClipboard") {
      registerClipboardChannel(messenger: registrar.messenger())
    }
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "FalcoFiles") {
      registerFilesChannel(messenger: registrar.messenger())
    }
  }

  // Part copies, picked copies and upload jobs live in Application Support,
  // which iOS backs up: their folders are kept out of iCloud and Finder
  // backups.
  private func registerFilesChannel(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: "falco/files", binaryMessenger: messenger)
    channel.setMethodCallHandler { call, result in
      guard call.method == "excludeFromBackup", let path = call.arguments as? String else {
        result(FlutterMethodNotImplemented)
        return
      }
      var url = URL(fileURLWithPath: path, isDirectory: true)
      var values = URLResourceValues()
      values.isExcludedFromBackup = true
      do {
        try url.setResourceValues(values)
        result(nil)
      } catch {
        result(FlutterError(code: "exclude_failed", message: error.localizedDescription, details: nil))
      }
    }
  }

  // Secrets go to the pasteboard local only (no Universal Clipboard) and
  // expire after the requested time.
  private func registerClipboardChannel(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: "falco/clipboard", binaryMessenger: messenger)
    channel.setMethodCallHandler { call, result in
      guard call.method == "setSensitive",
        let args = call.arguments as? [String: Any],
        let text = args["text"] as? String
      else {
        result(FlutterMethodNotImplemented)
        return
      }
      let seconds = args["expirySeconds"] as? Int ?? 60
      UIPasteboard.general.setItems(
        [[UTType.plainText.identifier: text]],
        options: [
          .localOnly: true,
          .expirationDate: Date().addingTimeInterval(TimeInterval(seconds)),
        ])
      result(nil)
    }
  }
}
