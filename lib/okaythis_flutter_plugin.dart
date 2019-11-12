import 'dart:async';
import 'dart:ffi';

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
    try {
      await _channel.invokeMethod("startEnrollment", <String, dynamic>{
        "appPns": appPns,
        "pubPss": pubPss,
        "installationId": installationId,
        "host": _host
      });
    } on PlatformException catch (e) {

    } on MissingPluginException catch (e) {

    }
  }

  static Future<void> startAuthorization(int sessionId, String appPns,  Map<String, dynamic> pageTheme) async {
    print("SessionId ${sessionId}");
    try {
      await _channel.invokeMethod("startAuthorization", <String, dynamic>{
        "sessionId": sessionId,
        "appPns": appPns,
        "pageTheme": pageTheme
      });
    } on PlatformException catch (e) {

    } on MissingPluginException catch (e) {

    }
  }

  static Future<void> linkTenant(String linkingCode) async {
    try {
      await _channel.invokeMethod("linkTenant", <String, dynamic>{
        "linkingCode": linkingCode
      });
    } on PlatformException catch (e) {

    } on MissingPluginException catch (e) {

    }
  }

  static Future<void> unlinkTenant(int tenantId) async {
    try {
      await _channel.invokeMethod("unlinkTenant", <String, dynamic>{
        "tenantId": tenantId
      });
    } on PlatformException catch (e) {

    } on MissingPluginException catch (e) {

    }
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

  static final String ACTION_BAR_BACKGROUND_COLOR = "actionBarBackgroundColor";
  static final String ACTION_BAR_TEXT_COLOR = "actionBarTextColor";
  static final String BUTTON_TEXT_COLOR = "buttonTextColor";
  static final String BUTTON_BACKGROUND_COLOR = "buttonBackgroundColor";
  static final String SCREEN_BACKGROUND_COLOR = "screenBackgroundColor";
  static final String NAME_TEXT_COLOR = "nameTextColor";
  static final String TITLE_TEXT_COLOR = "titleTextColor";
  static final String MESSAGE_TEXT_COLOR = "messageTextColor";
  static final String ACTION_BAR_LOGO_PATH = "actionBarLogoPath";
  static final String ACTION_BAR_TITLE = "actionBarTitle";
  static final String INPUT_TEXT_COLOR = "inputTextColor";
  static final String INPUT_SELECTION_COLOR = "inputSelectionColor";
  static final String INPUT_DEFAULT_COLOR = "inputDefaultColor";
  static final String QUESTION_MARK_COLOR = "questionMarkColor";
  static final String TRANSACTION_TYPE_TEXT_COLOR = "transactionTypeTextColor";
  static final String INFO_SECTION_TITLE_COLOR = "infoSectionTitleColor";
  static final String INFO_SECTION_VALUE_COLOR = "infoSectionValueColor";
  static final String FROM_TEXT_COLOR = "fromTextColor";
  static final String AUTH_INFO_BACKGROUND_COLOR = "authInfoBackgroundColor";
  static final String SHOW_DETAILS_TEXT_COLOR = "showDetailsTextColor";
  static final String CONFIRM_BUTTON_BACKGROUND_COLOR = "confirmButtonBackgroundColor";
  static final String CONFIRM_BUTTON_TEXT_COLOR = "confirmButtonTextColor";
  static final String CANCEL_BUTTON_BACKGROUND_COLOR = "cancelButtonBackgroundColor";
  static final String CANCEL_BUTTON_TEXT_COLOR = "cancelButtonTextColor";
  static final String AUTH_CONFIRMATION_BACKGROUND_COLOR = "authConfirmationBackgroundColor";
  static final String AUTH_CONFIRMATION_TITLE_COLOR = "authConfirmationTitleColor";
  static final String AUTH_CONFIRMATION_MESSAGE_COLOR = "authConfirmationMessageColor";
  static final String AUTH_CONFIRMATION_THUMB_COLOR = "authConfirmationThumbColor";
  static final String AUTH_CONFIRMATION_APOSTROPHE_COLOR = "authConfirmationApostropheColor";
  static final String AUTH_CONFIRMATION_BUTTON_BACKGROUND_COLOR = "authConfirmationButtonBackgroundColor";
  static final String AUTH_CONFIRMATION_BUTTON_TEXT_COLOR = "authConfirmationButtonTextColor";
  static final String AUTH_CANCELLATION_BACKGROUND_COLOR = "authCancellationBackgroundColor";
  static final String AUTH_CANCELLATION_TITLE_COLOR = "authCancellationTitleColor";
  static final String AUTH_CANCELLATION_MESSAGE_COLOR = "authCancellationMessageColor";
  static final String AUTH_CANCELLATION_THUMB_COLOR = "authCancellationThumbColor";
  static final String AUTH_CANCELLATION_APOSTROPHE_COLOR = "authCancellationApostropheColor";
  static final String AUTH_CANCELLATION_BUTTON_BACKGROUND_COLOR = "authCancellationButtonBackgroundColor";
  static final String AUTH_CANCELLATION_BUTTON_TEXT_COLOR = "authCancellationButtonTextColor";
  static final String PIN_TITLE_TEXT_COLOR = "pinTitleTextColor";
  static final String PIN_VALUE_TEXT_COLOR = "pinValueTextColor";
  static final String PIN_NUMBER_BUTTON_TEXT_COLOR = "pinNumberButtonTextColor";
  static final String PIN_NUMBER_BUTTON_BACKGROUND_COLOR = "pinNumberButtonBackgroundColor";
  static final String PIN_REMOVE_BUTTON_TEXT_COLOR = "pinRemoveButtonTextColor";
  static final String PIN_REMOVE_BUTTON_BACKGROUND_COLOR = "pinRemoveButtonBackgroundColor";

}





