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
