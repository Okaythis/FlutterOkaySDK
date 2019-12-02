import 'dart:async';
import 'package:flutter/services.dart';

typedef Future<dynamic> MessageHandler(bool status);

class OkaythisFlutterPlugin {
  static const MethodChannel _channel = const MethodChannel('okaythis_flutter_plugin');
  static MessageHandler _onEnrollmentHandler;
  static MessageHandler _onLinkingHandler;
  static MessageHandler _onUnLinkingHandler;
  static MessageHandler _onAuthorizationHandler;
  static String _host;


  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> initPsa() async {
    final String msg = await _channel.invokeMethod("initPsa", _host);
    return msg;
  }
  
  static Future<void> config({
    String host,
    MessageHandler onEnrollmentHandler,
    MessageHandler onLinkingHandler,
    MessageHandler onAuthorizationHandler,
    MessageHandler onUnLinkingHandler,
  }) async {
    _host = host;
    _onEnrollmentHandler = onEnrollmentHandler;
    _onLinkingHandler = onLinkingHandler;
    _onAuthorizationHandler = onAuthorizationHandler;
    _onUnLinkingHandler = onUnLinkingHandler;
    _channel.setMethodCallHandler(_methodCallHandler);
  }

  static Future<void> startEnrollment(String appPns, String pubPss, String installationId) async {
      await _channel.invokeMethod("startEnrollment", <String, dynamic>{
        "appPns": appPns,
        "pubPss": pubPss,
        "installationId": installationId,
        "host": _host
      });
  }

  static Future<void> startAuthorization(int sessionId, String appPns,  Map<String, dynamic> pageTheme) async {
      await _channel.invokeMethod("startAuthorization", <String, dynamic>{
        "sessionId": sessionId,
        "appPns": appPns,
        "pageTheme": pageTheme
      });
  }

  static Future<void> linkTenant(String linkingCode) async {
      await _channel.invokeMethod("linkTenant", <String, dynamic>{
        "linkingCode": linkingCode
      });
  }

  static Future<void> unlinkTenant(int tenantId) async {
      await _channel.invokeMethod("unlinkTenant", <String, dynamic>{
        "tenantId": tenantId
      });
  }


  static Future<List<dynamic>> requestRequiredPermissions() async {
    var permissions = await _channel.invokeMethod("requestRequiredPermissions");
    return permissions;
  }

  static Future<void> _methodCallHandler(MethodCall call) async {
    switch (call.method) {
      case "onEnrollmentHandler":
        return _onEnrollmentHandler(call.arguments);
      case "onLinkingHandler":
        return _onLinkingHandler(call.arguments);
      case "onUnLinkingHandler":
        return _onUnLinkingHandler(call.arguments);
      case "onAuthorizationHandler":
        return _onAuthorizationHandler(call.arguments);
      default: throw UnsupportedError("Callback not supported");
    }
  }
}

class PageTheme {

  static const String ACTION_BAR_BACKGROUND_COLOR = "actionBarBackgroundColor";
  static const String ACTION_BAR_TEXT_COLOR = "actionBarTextColor";
  static const String BUTTON_TEXT_COLOR = "buttonTextColor";
  static const String BUTTON_BACKGROUND_COLOR = "buttonBackgroundColor";
  static const String SCREEN_BACKGROUND_COLOR = "screenBackgroundColor";
  static const String NAME_TEXT_COLOR = "nameTextColor";
  static const String TITLE_TEXT_COLOR = "titleTextColor";
  static const String MESSAGE_TEXT_COLOR = "messageTextColor";
  static const String ACTION_BAR_LOGO_PATH = "actionBarLogoPath";
  static const String ACTION_BAR_TITLE = "actionBarTitle";
  static const String INPUT_TEXT_COLOR = "inputTextColor";
  static const String INPUT_SELECTION_COLOR = "inputSelectionColor";
  static const String INPUT_ERROR_COLOR = "inputErrorColor";
  static const String INPUT_DEFAULT_COLOR = "inputDefaultColor";
  static const String QUESTION_MARK_COLOR = "questionMarkColor";
  static const String TRANSACTION_TYPE_TEXT_COLOR = "transactionTypeTextColor";
  static const String INFO_SECTION_TITLE_COLOR = "infoSectionTitleColor";
  static const String INFO_SECTION_VALUE_COLOR = "infoSectionValueColor";
  static const String FROM_TEXT_COLOR = "fromTextColor";
  static const String AUTH_INFO_BACKGROUND_COLOR = "authInfoBackgroundColor";
  static const String SHOW_DETAILS_TEXT_COLOR = "showDetailsTextColor";
  static const String CONFIRM_BUTTON_BACKGROUND_COLOR = "confirmButtonBackgroundColor";
  static const String CONFIRM_BUTTON_TEXT_COLOR = "confirmButtonTextColor";
  static const String CANCEL_BUTTON_BACKGROUND_COLOR = "cancelButtonBackgroundColor";
  static const String CANCEL_BUTTON_TEXT_COLOR = "cancelButtonTextColor";
  static const String AUTH_CONFIRMATION_BACKGROUND_COLOR = "authConfirmationBackgroundColor";
  static const String AUTH_CONFIRMATION_TITLE_COLOR = "authConfirmationTitleColor";
  static const String AUTH_CONFIRMATION_MESSAGE_COLOR = "authConfirmationMessageColor";
  static const String AUTH_CONFIRMATION_THUMB_COLOR = "authConfirmationThumbColor";
  static const String AUTH_CONFIRMATION_APOSTROPHE_COLOR = "authConfirmationApostropheColor";
  static const String AUTH_CONFIRMATION_BUTTON_BACKGROUND_COLOR = "authConfirmationButtonBackgroundColor";
  static const String AUTH_CONFIRMATION_BUTTON_TEXT_COLOR = "authConfirmationButtonTextColor";
  static const String AUTH_CANCELLATION_BACKGROUND_COLOR = "authCancellationBackgroundColor";
  static const String AUTH_CANCELLATION_TITLE_COLOR = "authCancellationTitleColor";
  static const String AUTH_CANCELLATION_MESSAGE_COLOR = "authCancellationMessageColor";
  static const String AUTH_CANCELLATION_THUMB_COLOR = "authCancellationThumbColor";
  static const String AUTH_CANCELLATION_APOSTROPHE_COLOR = "authCancellationApostropheColor";
  static const String AUTH_CANCELLATION_BUTTON_BACKGROUND_COLOR = "authCancellationButtonBackgroundColor";
  static const String AUTH_CANCELLATION_BUTTON_TEXT_COLOR = "authCancellationButtonTextColor";
  static const String PIN_TITLE_TEXT_COLOR = "pinTitleTextColor";
  static const String PIN_VALUE_TEXT_COLOR = "pinValueTextColor";
  static const String PIN_NUMBER_BUTTON_TEXT_COLOR = "pinNumberButtonTextColor";
  static const String PIN_NUMBER_BUTTON_BACKGROUND_COLOR = "pinNumberButtonBackgroundColor";
  static const String PIN_REMOVE_BUTTON_TEXT_COLOR = "pinRemoveButtonTextColor";
  static const String PIN_REMOVE_BUTTON_BACKGROUND_COLOR = "pinRemoveButtonBackgroundColor";
  

}





