import Flutter
import UIKit
import PSA
import Foundation



public class SwiftOkaythisFlutterPlugin: NSObject, FlutterPlugin {
    static var channel: FlutterMethodChannel?
    var tenantTheme: PSATheme?
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    channel = FlutterMethodChannel(name: "okaythis_flutter_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftOkaythisFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel!)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
    switch call.method {
    case "getPlatformVersion":
         result("iOS " + UIDevice.current.systemVersion)
         break;
    case "initPsa":
        // do nothing
        break;
    case "startEnrollment":
        guard let args = call.arguments as? [String: Any] else {
               return
        }
        let deviceToken = args["appPns"] as? String
        let pubPssBase64 = args["pubPss"] as? String
        let host = args["host"] as? String
        let installationId = args["installationId"] as? String
        startEnrollment(host: host!, installationId: installationId!, deviceToken: deviceToken!, pubPssBase64: pubPssBase64!);
        break;
    case "linkTenant":
        guard let args = call.arguments as? [String: Any] else {
            print("Debug!!")
            return
        }
        let linkingCode = args["linkingCode"] as? String
        print("Linking code: \(String(describing: linkingCode))")
        linkTenant(linkingCode: linkingCode!)
        break;
    case "unlinkTenant":
        guard let args = call.arguments as? [String: Any] else {
            return
        }
        let tenantId = args["tenantId"] as? Int
        unlinkTenant(tenantId: tenantId!)
    case "startAuthorization":
        guard let args = call.arguments as? [String: Any] else {
               return
        }
        let sessionId = args["sessionId"] as? Int
        startAuthorization(sessionId: sessionId!)
        break;
    default:
        result(FlutterMethodNotImplemented)
    }
}
        
    private func startEnrollment(host: String, installationId: String, deviceToken: String, pubPssBase64: String) {
        PSA.updateDeviceToken(deviceToken)
        if PSA.isReadyForEnrollment() {
            PSA.startEnrollment(withHost: host, installationId: installationId, pubPssBase64: pubPssBase64) {
                (status) in
                if status.rawValue == 1 {
                    print("Success: \(status.rawValue)") // call callback here
        SwiftOkaythisFlutterPlugin.channel?.invokeMethod("onEnrollmentHandler", arguments: true)
                } else {
                    print("Failure: \(status.rawValue)")
                    SwiftOkaythisFlutterPlugin.channel?.invokeMethod("onEnrollmentHandler", arguments: false)
                }
            }
        }
    }
    
    private func linkTenant(linkingCode: String) {
        PSA.linkTenant(withLinkingCode: linkingCode) { (PSASharedStatuses, PSATenant) in
            if PSASharedStatuses.rawValue == 1 {
                self.tenantTheme = PSATenant.theme
                SwiftOkaythisFlutterPlugin.channel?.invokeMethod("onLinkingHandler", arguments: true)
            } else {
                SwiftOkaythisFlutterPlugin.channel?.invokeMethod("onLinkingHandler", arguments: false)
            }
        }
    }
    
    private func unlinkTenant(tenantId: Int) {
        PSA.unlinkTenant(withTenantId: NSNumber(value: tenantId)) { (status, number) in
            if status.rawValue == 1 {
                SwiftOkaythisFlutterPlugin.channel?.invokeMethod("onUnLinkingHandler", arguments: true)
            } else {
                SwiftOkaythisFlutterPlugin.channel?.invokeMethod("onUnLinkingHandler", arguments: false)
            }
        }
    }
    
    private func startAuthorization(sessionId: Int) {
        if PSA.isReadyForAuthorization() {
            PSA.startAuthorization(with: tenantTheme!, sessionId: NSNumber(value: sessionId)) { (isCancelled, status) in
                      if !isCancelled && status.rawValue == 1 {
                          print("Success: \(status)") // call callback here
                        SwiftOkaythisFlutterPlugin.channel?.invokeMethod("onAuthorizationHandler", arguments: true)
                      } else {
                        print("Failure: \(status)") // call callback here
                        SwiftOkaythisFlutterPlugin.channel?.invokeMethod("onAuthorizationHandler", arguments: false)
                      }
            }
        }
    }
}

