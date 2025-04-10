// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/services.dart';

import 'package:iamport_webview_flutter/platform_interface.dart';

/// A [WebViewPlatformController] that uses a method channel to control the webview.
class MethodChannelWebViewPlatform implements WebViewPlatformController {
  /// Constructs an instance that will listen for webviews broadcasting to the
  /// given [id], using the given [WebViewPlatformCallbacksHandler].
  MethodChannelWebViewPlatform(int id, this._platformCallbacksHandler)
      : _channel = MethodChannel('plugins.flutter.io/imp_webview_$id') {
    _channel.setMethodCallHandler(_onMethodCall);
  }

  final WebViewPlatformCallbacksHandler _platformCallbacksHandler;

  final MethodChannel _channel;

  static const MethodChannel _cookieManagerChannel = MethodChannel('plugins.flutter.io/imp_cookie_manager');

  Future<bool?> _onMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'javascriptChannelMessage':
        final channel = (call.arguments as Map<dynamic, dynamic>)['channel']! as String;
        final message = (call.arguments as Map<dynamic, dynamic>)['message']! as String;
        _platformCallbacksHandler.onJavaScriptChannelMessage(channel, message);
        return true;
      case 'navigationRequest':
        return await _platformCallbacksHandler.onNavigationRequest(
          url: (call.arguments as Map<dynamic, dynamic>)['url']! as String,
          isForMainFrame: (call.arguments as Map<dynamic, dynamic>)['isForMainFrame']! as bool,
        );
      case 'onPageFinished':
        _platformCallbacksHandler.onPageFinished((call.arguments as Map<dynamic, dynamic>)['url']! as String);
        return null;
      case 'onProgress':
        _platformCallbacksHandler.onProgress((call.arguments as Map<dynamic, dynamic>)['progress'] as int);
        return null;
      case 'onPageStarted':
        _platformCallbacksHandler.onPageStarted((call.arguments as Map<dynamic, dynamic>)['url']! as String);
        return null;
      case 'onWebResourceError':
        _platformCallbacksHandler.onWebResourceError(
          WebResourceError(
            errorCode: (call.arguments as Map<dynamic, dynamic>)['errorCode']! as int,
            description: (call.arguments as Map<dynamic, dynamic>)['description']! as String,
            // iOS doesn't support `failingUrl`.
            failingUrl: (call.arguments as Map<dynamic, dynamic>)['failingUrl'] as String?,
            domain: (call.arguments as Map<dynamic, dynamic>)['domain'] as String?,
            errorType: (call.arguments as Map<dynamic, dynamic>)['errorType'] == null
                ? null
                : WebResourceErrorType.values.firstWhere(
                    (WebResourceErrorType type) {
                      return type.toString() ==
                          '$WebResourceErrorType.${(call.arguments as Map<dynamic, dynamic>)['errorType']}';
                    },
                  ),
          ),
        );
        return null;
    }

    throw MissingPluginException(
      '${call.method} was invoked but has no handler',
    );
  }

  @override
  Future<void> loadUrl(
    String url,
    Map<String, String>? headers,
  ) async {
    return _channel.invokeMethod<void>('loadUrl', <String, dynamic>{
      'url': url,
      'headers': headers,
    });
  }

  @override
  Future<void> loadDataWithBaseURL(
    String? baseUrl,
    String data,
    String? mimeType,
    String? encoding,
    String? failUrl,
  ) async {
    return _channel.invokeMethod<void>('loadDataWithBaseURL', <String, dynamic>{
      'baseUrl': baseUrl,
      'data': data,
      'mimeType': mimeType,
      'encoding': encoding,
      'failUrl': failUrl,
    });
  }

  @override
  Future<String?> currentUrl() => _channel.invokeMethod<String>('currentUrl');

  @override
  Future<bool> canGoBack() => _channel.invokeMethod<bool>('canGoBack').then((result) => result!);

  @override
  Future<bool> canGoForward() => _channel.invokeMethod<bool>('canGoForward').then((result) => result!);

  @override
  Future<void> goBack() => _channel.invokeMethod<void>('goBack');

  @override
  Future<void> goForward() => _channel.invokeMethod<void>('goForward');

  @override
  Future<void> reload() => _channel.invokeMethod<void>('reload');

  @override
  Future<void> clearCache() => _channel.invokeMethod<void>('clearCache');

  @override
  Future<void> updateSettings(WebSettings settings) async {
    final updatesMap = _webSettingsToMap(settings);
    if (updatesMap.isNotEmpty) {
      await _channel.invokeMethod<void>('updateSettings', updatesMap);
    }
  }

  @override
  Future<String> evaluateJavascript(String javascriptString) {
    return _channel.invokeMethod<String>('evaluateJavascript', javascriptString).then((result) => result!);
  }

  @override
  Future<void> addJavascriptChannels(Set<String> javascriptChannelNames) {
    return _channel.invokeMethod<void>('addJavascriptChannels', javascriptChannelNames.toList());
  }

  @override
  Future<void> removeJavascriptChannels(Set<String> javascriptChannelNames) {
    return _channel.invokeMethod<void>('removeJavascriptChannels', javascriptChannelNames.toList());
  }

  @override
  Future<void> setAcceptThirdPartyCookies(bool accept) {
    return _channel.invokeMethod<void>('setAcceptThirdPartyCookies', accept);
  }

  @override
  Future<String?> getTitle() => _channel.invokeMethod<String>('getTitle');

  @override
  Future<void> scrollTo(int x, int y) {
    return _channel.invokeMethod<void>('scrollTo', <String, int>{
      'x': x,
      'y': y,
    });
  }

  @override
  Future<void> scrollBy(int x, int y) {
    return _channel.invokeMethod<void>('scrollBy', <String, int>{
      'x': x,
      'y': y,
    });
  }

  @override
  Future<int> getScrollX() => _channel.invokeMethod<int>('getScrollX').then((result) => result!);

  @override
  Future<int> getScrollY() => _channel.invokeMethod<int>('getScrollY').then((result) => result!);

  /// Method channel implementation for [WebViewPlatform.clearCookies].
  static Future<bool> clearCookies() {
    return _cookieManagerChannel.invokeMethod<bool>('clearCookies').then<bool>((bool? result) => result!);
  }

  static Map<String, dynamic> _webSettingsToMap(WebSettings? settings) {
    final map = <String, dynamic>{};
    void addIfNonNull(String key, dynamic value) {
      if (value == null) {
        return;
      }
      map[key] = value;
    }

    void addSettingIfPresent<T>(String key, WebSetting<T> setting) {
      if (!setting.isPresent) {
        return;
      }
      map[key] = setting.value;
    }

    addIfNonNull('jsMode', settings!.javascriptMode?.index);
    addIfNonNull('hasNavigationDelegate', settings.hasNavigationDelegate);
    addIfNonNull('hasProgressTracking', settings.hasProgressTracking);
    addIfNonNull('debuggingEnabled', settings.debuggingEnabled);
    addIfNonNull('gestureNavigationEnabled', settings.gestureNavigationEnabled);
    addIfNonNull('allowsInlineMediaPlayback', settings.allowsInlineMediaPlayback);
    addSettingIfPresent('userAgent', settings.userAgent);
    return map;
  }

  /// Converts a [CreationParams] object to a map as expected by `platform_views` channel.
  ///
  /// This is used for the `creationParams` argument of the platform views created by
  /// `AndroidWebViewBuilder` and `CupertinoWebViewBuilder`.
  static Map<String, dynamic> creationParamsToMap(
    CreationParams creationParams, {
    bool usesHybridComposition = false,
  }) {
    return <String, dynamic>{
      'initialUrl': creationParams.initialUrl,
      'settings': _webSettingsToMap(creationParams.webSettings),
      'javascriptChannelNames': creationParams.javascriptChannelNames.toList(),
      'userAgent': creationParams.userAgent,
      'autoMediaPlaybackPolicy': creationParams.autoMediaPlaybackPolicy.index,
      'usesHybridComposition': usesHybridComposition,
    };
  }
}
