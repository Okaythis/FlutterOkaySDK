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
    case "initPsa":
        guard let args = call.arguments as? [String: Any] else {
            return
        }
        let host = args["host"] as? String
        PSACommonData.setHost(host)
        break;
    case "startEnrollment":
        guard let args = call.arguments as? [String: Any] else {
               return
        }
        let deviceToken = args["appPns"] as? String
        let pubPssBase64 = args["pubPss"] as? String
        let host = args["host"] as? String
        let installationId = args["installationId"] as? String
        let backgroundEnroll = args["backgroundEnroll"] as? bool
        startEnrollment(host: host!, backgroundEnroll, installationId: installationId!, deviceToken: deviceToken!, pubPssBase64: pubPssBase64!);
        break;
        
    case "isEnrolled":
        result(PSA.isEnrolled())
        break
    case "linkTenant":
        guard let args = call.arguments as? [String: Any] else {
            return
        }
        let linkingCode = args["linkingCode"] as? String
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
        let pageTheme = themeMapper(args["pageTheme"] as? [String: String])
        if pageTheme != nil {
            startAuthorization(theme: pageTheme!, sessionId: sessionId!)
            return
        }
        
        if self.tenantTheme != nil {
            startAuthorization(theme: self.tenantTheme!, sessionId: sessionId!)
            return
        }
        
        startAuthorization(sessionId: sessionId!)
        break;
    default:
        result(FlutterMethodNotImplemented)
    }
}
        
    private func startEnrollment(host: String, backgroundEnroll: bool, installationId: String, deviceToken: String, pubPssBase64: String) {
        PSA.updateDeviceToken(deviceToken)
        if PSA.isReadyForEnrollment() {
            PSA.startEnrollment(withHost: host, invisibly: backgroundEnroll, installationId: installationId, resourceProvider: nil, pubPssBase64: pubPssBase64) {
                (status) in
                if status.rawValue == 1 {
        SwiftOkaythisFlutterPlugin.channel?.invokeMethod("onEnrollmentHandler", arguments: true)
                } else {
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
    
    private func startAuthorization(theme: PSATheme?, sessionId: Int) {
        if PSA.isReadyForAuthorization() {
            PSA.startAuthorization(with: theme, sessionId: NSNumber(value: sessionId), resourceProvider: nil, loaderViewController: nil) { (isCancelled, sharedStatus, transactionInfo) in
                      if !isCancelled && sharedStatus.rawValue == 1 {
                        SwiftOkaythisFlutterPlugin.channel?.invokeMethod("onAuthorizationHandler", arguments: true)
                      } else {
                        SwiftOkaythisFlutterPlugin.channel?.invokeMethod("onAuthorizationHandler", arguments: false)
                      }
            }
        } else {
            SwiftOkaythisFlutterPlugin.channel?.invokeMethod("onAuthorizationHandler", arguments: false)
        }
    }
    
    private func themeMapper(themeDict: [String: String]){
        let theme = CustomTheme()
        for colorKey in themeDict.keys {
            switch colorKey {
            case "PSAThemeLogoKey":
                //theme.PSAThemeLogoKey = themeDict[colorKey]
                break
            case "PSAThemeTitleKey":
                theme.PSAThemeTitleKey = themeDict[colorKey]
                break
            case "PSAThemeLogoDataKey":
                theme.PSAThemeLogoDataKey = themeDict[colorKey]
                break
             case "PSAThemeScreenBackgroundColorKey":
                theme.PSAThemeScreenBackgroundColorKey = themeDict[colorKey]
                break
            case "PSAThemeActivityIndicatorColor":
                theme.PSAThemeActivityIndicatorColor = themeDict[colorKey]
                break;
            case "PSAThemeTitleTextColorKey":
                theme.PSAThemeTitleTextColorKey = themeDict[colorKey]
                break
            case "PSAThemeQuestionMarkColorKey":
                theme.PSAThemeQuestionMarkColorKey = themeDict[colorKey]
                break
             case "PSAThemeTransactionTypeTextColorKey":
                theme.PSAThemeTransactionTypeTextColorKey = themeDict[colorKey]
                break
            case "PSAThemeInfoSectionTitleColorKey":
                theme.PSAThemeInfoSectionTitleColorKey = themeDict[colorKey]
                break
            case "PSAThemeInfoSectionValueColorKey":
                theme.PSAThemeInfoSectionValueColorKey = themeDict[colorKey]
                break
            case "PSAThemeFromTextColorKey":
                theme.PSAThemeFromTextColorKey = themeDict[colorKey]
                break
            case "PSAThemeMessageTextColorKey":
                theme.PSAThemeMessageTextColorKey = themeDict[colorKey]
                break
            case "PSAThemeAuthInfoBackgroundColorKey":
                theme.PSAThemeAuthInfoBackgroundColorKey = themeDict[colorKey]
                break
            case "PSAThemeShowDetailsTextColorKey":
                theme.PSAThemeShowDetailsTextColorKey = themeDict[colorKey]
                break
            case "PSAThemeConfirmButtonBackgroundColorKey":
                theme.PSAThemeConfirmButtonBackgroundColorKey = themeDict[colorKey]
                break
            case "PSAThemeConfirmButtonTextColorKey":
                theme.PSAThemeConfirmButtonTextColorKey = themeDict[colorKey]
                break
            case "PSAThemeCancelButtonBackgroundColorKey":
                theme.PSAThemeCancelButtonBackgroundColorKey = themeDict[colorKey]
                break
            case "PSAThemeCancelButtonTextColorKey":
                theme.PSAThemeCancelButtonTextColorKey = themeDict[colorKey]
                break
            case "PSAThemeAuthConfirmationBackgroundColorKey":
                theme.PSAThemeAuthConfirmationBackgroundColorKey = themeDict[colorKey]
                break
            case "PSAThemeAuthConfirmationTitleColorKey":
                theme.PSAThemeAuthConfirmationTitleColorKey = themeDict[colorKey]
                break
            case "PSAThemeAuthConfirmationMessageColorKey":
                theme.PSAThemeAuthConfirmationMessageColorKey = themeDict[colorKey]
                break
            case"PSAThemeAuthConfirmationThumbColorKey":
                theme.PSAThemeAuthConfirmationThumbColorKey = themeDict[colorKey]
                break
            case "PSAThemeAuthConfirmationApostropheColorKey":
                theme.PSAThemeAuthConfirmationApostropheColorKey = themeDict[colorKey]
                break
            case "PSAThemeAuthConfirmationButtonBackgroundColorKey":
                theme.PSAThemeAuthConfirmationButtonBackgroundColorKey = themeDict[colorKey]
                break
            case "PSAThemeAuthConfirmationButtonTextColorKey":
                theme.PSAThemeAuthConfirmationButtonTextColorKey = themeDict[colorKey]
                break
            case "PSAThemeAuthCancellationBackgroundColorKey":
                theme.PSAThemeAuthCancellationBackgroundColorKey = themeDict[colorKey]
                break
            case "PSAThemeAuthCancellationTitleColorKey":
                theme.PSAThemeAuthCancellationTitleColorKey = themeDict[colorKey]
                break
            case "PSAThemeAuthCancellationMessageColorKey":
                theme.PSAThemeAuthCancellationMessageColorKey = themeDict[colorKey]
                break
            case "PSAThemeAuthCancellationThumbColorKey":
                theme.PSAThemeAuthCancellationThumbColorKey = themeDict[colorKey]
                break
            case "PSAThemeAuthCancellationApostropheColorKey":
                theme.PSAThemeAuthCancellationApostropheColorKey = themeDict[colorKey]
                break
            case "PSAThemeAuthCancellationButtonBackgroundColorKey":
                theme.PSAThemeAuthCancellationButtonBackgroundColorKey = themeDict[colorKey]
                break
            case "PSAThemeAuthCancellationButtonTextColorKey":
                theme.PSAThemeAuthCancellationButtonTextColorKey = themeDict[colorKey]
                break
            case "PSAThemePinTitleTextColorKey":
                theme.PSAThemePinTitleTextColorKey = themeDict[colorKey]
                break
            case "PSAThemePinValueTextColorKey":
                theme.PSAThemePinValueTextColorKey = themeDict[colorKey]
                break
            case "PSAThemePinNumberButtonTextColorKey":
                theme.PSAThemePinNumberButtonTextColorKey = themeDict[colorKey]
                break
            case "PSAThemePinNumberButtonBackgroundColorKey":
                theme.PSAThemePinNumberButtonBackgroundColorKey = themeDict[colorKey]
                break
            case "PSAThemePinRemoveButtonTextColorKey":
                theme.PSAThemePinRemoveButtonTextColorKey = themeDict[colorKey]
                break
            case "PSAThemePinRemoveButtonBackgroundColorKey";
            theme.PSAThemePinRemoveButtonBackgroundColorKey = themeDict[colorKey]
                break
            default:
            }
            
        }
        return theme
    }
    
    class CustomTheme: PSATheme{
        
    }
}

