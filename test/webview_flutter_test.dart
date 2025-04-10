// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/basic_types.dart';
import 'package:flutter/src/gestures/recognizer.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iamport_webview_flutter/platform_interface.dart';
import 'package:iamport_webview_flutter/iamport_webview_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final fakePlatformViewsController = _FakePlatformViewsController();

  final fakeCookieManager = _FakeCookieManager();

  setUpAll(() {
    SystemChannels.platform_views.setMockMethodCallHandler(fakePlatformViewsController.fakePlatformViewsMethodHandler);
    SystemChannels.platform.setMockMethodCallHandler(fakeCookieManager.onMethodCall);
  });

  setUp(() {
    fakePlatformViewsController.reset();
    fakeCookieManager.reset();
  });

  testWidgets('Create WebView', (WidgetTester tester) async {
    await tester.pumpWidget(const WebView());
  });

  testWidgets('Initial url', (WidgetTester tester) async {
    late WebViewController controller;
    await tester.pumpWidget(
      WebView(
        initialUrl: 'https://youtube.com',
        onWebViewCreated: (WebViewController webViewController) {
          controller = webViewController;
        },
      ),
    );

    expect(await controller.currentUrl(), 'https://youtube.com');
  });

  testWidgets('Javascript mode', (WidgetTester tester) async {
    await tester.pumpWidget(
      const WebView(
        initialUrl: 'https://youtube.com',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );

    final platformWebView = fakePlatformViewsController.lastCreatedView!;

    expect(platformWebView.javascriptMode, JavascriptMode.unrestricted);

    await tester.pumpWidget(
      const WebView(
        initialUrl: 'https://youtube.com',
      ),
    );
    expect(platformWebView.javascriptMode, JavascriptMode.disabled);
  });

  testWidgets('Load url', (WidgetTester tester) async {
    WebViewController? controller;
    await tester.pumpWidget(
      WebView(
        onWebViewCreated: (WebViewController webViewController) {
          controller = webViewController;
        },
      ),
    );

    expect(controller, isNotNull);

    await controller!.loadUrl('https://flutter.io');

    expect(await controller!.currentUrl(), 'https://flutter.io');
  });

  testWidgets('Invalid urls', (WidgetTester tester) async {
    WebViewController? controller;
    await tester.pumpWidget(
      WebView(
        onWebViewCreated: (WebViewController webViewController) {
          controller = webViewController;
        },
      ),
    );

    expect(controller, isNotNull);

    expect(await controller!.currentUrl(), isNull);

    expect(() => controller!.loadUrl(''), throwsA(anything));
    expect(await controller!.currentUrl(), isNull);

    // Missing schema.
    expect(() => controller!.loadUrl('flutter.io'), throwsA(anything));
    expect(await controller!.currentUrl(), isNull);
  });

  testWidgets('Headers in loadUrl', (WidgetTester tester) async {
    WebViewController? controller;
    await tester.pumpWidget(
      WebView(
        onWebViewCreated: (WebViewController webViewController) {
          controller = webViewController;
        },
      ),
    );

    expect(controller, isNotNull);

    final headers = <String, String>{'CACHE-CONTROL': 'ABC'};
    await controller!.loadUrl('https://flutter.io', headers: headers);
    expect(await controller!.currentUrl(), equals('https://flutter.io'));
  });

  testWidgets("Can't go back before loading a page", (WidgetTester tester) async {
    WebViewController? controller;
    await tester.pumpWidget(
      WebView(
        onWebViewCreated: (WebViewController webViewController) {
          controller = webViewController;
        },
      ),
    );

    expect(controller, isNotNull);

    final canGoBackNoPageLoaded = await controller!.canGoBack();

    expect(canGoBackNoPageLoaded, false);
  });

  testWidgets('Clear Cache', (WidgetTester tester) async {
    WebViewController? controller;
    await tester.pumpWidget(
      WebView(
        onWebViewCreated: (WebViewController webViewController) {
          controller = webViewController;
        },
      ),
    );

    expect(controller, isNotNull);
    expect(fakePlatformViewsController.lastCreatedView!.hasCache, true);

    await controller!.clearCache();

    expect(fakePlatformViewsController.lastCreatedView!.hasCache, false);
  });

  testWidgets("Can't go back with no history", (WidgetTester tester) async {
    WebViewController? controller;
    await tester.pumpWidget(
      WebView(
        initialUrl: 'https://flutter.io',
        onWebViewCreated: (WebViewController webViewController) {
          controller = webViewController;
        },
      ),
    );

    expect(controller, isNotNull);
    final canGoBackFirstPageLoaded = await controller!.canGoBack();

    expect(canGoBackFirstPageLoaded, false);
  });

  testWidgets('Can go back', (WidgetTester tester) async {
    WebViewController? controller;
    await tester.pumpWidget(
      WebView(
        initialUrl: 'https://flutter.io',
        onWebViewCreated: (WebViewController webViewController) {
          controller = webViewController;
        },
      ),
    );

    expect(controller, isNotNull);

    await controller!.loadUrl('https://www.google.com');
    final canGoBackSecondPageLoaded = await controller!.canGoBack();

    expect(canGoBackSecondPageLoaded, true);
  });

  testWidgets("Can't go forward before loading a page", (WidgetTester tester) async {
    WebViewController? controller;
    await tester.pumpWidget(
      WebView(
        onWebViewCreated: (WebViewController webViewController) {
          controller = webViewController;
        },
      ),
    );

    expect(controller, isNotNull);

    final canGoForwardNoPageLoaded = await controller!.canGoForward();

    expect(canGoForwardNoPageLoaded, false);
  });

  testWidgets("Can't go forward with no history", (WidgetTester tester) async {
    WebViewController? controller;
    await tester.pumpWidget(
      WebView(
        initialUrl: 'https://flutter.io',
        onWebViewCreated: (WebViewController webViewController) {
          controller = webViewController;
        },
      ),
    );

    expect(controller, isNotNull);
    final canGoForwardFirstPageLoaded = await controller!.canGoForward();

    expect(canGoForwardFirstPageLoaded, false);
  });

  testWidgets('Can go forward', (WidgetTester tester) async {
    WebViewController? controller;
    await tester.pumpWidget(
      WebView(
        initialUrl: 'https://flutter.io',
        onWebViewCreated: (WebViewController webViewController) {
          controller = webViewController;
        },
      ),
    );

    expect(controller, isNotNull);

    await controller!.loadUrl('https://youtube.com');
    await controller!.goBack();
    final canGoForwardFirstPageBacked = await controller!.canGoForward();

    expect(canGoForwardFirstPageBacked, true);
  });

  testWidgets('Go back', (WidgetTester tester) async {
    WebViewController? controller;
    await tester.pumpWidget(
      WebView(
        initialUrl: 'https://youtube.com',
        onWebViewCreated: (WebViewController webViewController) {
          controller = webViewController;
        },
      ),
    );

    expect(controller, isNotNull);

    expect(await controller!.currentUrl(), 'https://youtube.com');

    await controller!.loadUrl('https://flutter.io');

    expect(await controller!.currentUrl(), 'https://flutter.io');

    await controller!.goBack();

    expect(await controller!.currentUrl(), 'https://youtube.com');
  });

  testWidgets('Go forward', (WidgetTester tester) async {
    WebViewController? controller;
    await tester.pumpWidget(
      WebView(
        initialUrl: 'https://youtube.com',
        onWebViewCreated: (WebViewController webViewController) {
          controller = webViewController;
        },
      ),
    );

    expect(controller, isNotNull);

    expect(await controller!.currentUrl(), 'https://youtube.com');

    await controller!.loadUrl('https://flutter.io');

    expect(await controller!.currentUrl(), 'https://flutter.io');

    await controller!.goBack();

    expect(await controller!.currentUrl(), 'https://youtube.com');

    await controller!.goForward();

    expect(await controller!.currentUrl(), 'https://flutter.io');
  });

  testWidgets('Current URL', (WidgetTester tester) async {
    WebViewController? controller;
    await tester.pumpWidget(
      WebView(
        onWebViewCreated: (WebViewController webViewController) {
          controller = webViewController;
        },
      ),
    );

    expect(controller, isNotNull);

    // Test a WebView without an explicitly set first URL.
    expect(await controller!.currentUrl(), isNull);

    await controller!.loadUrl('https://youtube.com');
    expect(await controller!.currentUrl(), 'https://youtube.com');

    await controller!.loadUrl('https://flutter.io');
    expect(await controller!.currentUrl(), 'https://flutter.io');

    await controller!.goBack();
    expect(await controller!.currentUrl(), 'https://youtube.com');
  });

  testWidgets('Reload url', (WidgetTester tester) async {
    late WebViewController controller;
    await tester.pumpWidget(
      WebView(
        initialUrl: 'https://flutter.io',
        onWebViewCreated: (WebViewController webViewController) {
          controller = webViewController;
        },
      ),
    );

    final platformWebView = fakePlatformViewsController.lastCreatedView!;

    expect(platformWebView.currentUrl, 'https://flutter.io');
    expect(platformWebView.amountOfReloadsOnCurrentUrl, 0);

    await controller.reload();

    expect(platformWebView.currentUrl, 'https://flutter.io');
    expect(platformWebView.amountOfReloadsOnCurrentUrl, 1);

    await controller.loadUrl('https://youtube.com');

    expect(platformWebView.amountOfReloadsOnCurrentUrl, 0);
  });

  testWidgets('evaluate Javascript', (WidgetTester tester) async {
    late WebViewController controller;
    await tester.pumpWidget(
      WebView(
        initialUrl: 'https://flutter.io',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          controller = webViewController;
        },
      ),
    );
    expect(await controller.evaluateJavascript('fake js string'), 'fake js string', reason: 'should get the argument');
  });

  testWidgets('evaluate Javascript with JavascriptMode disabled', (WidgetTester tester) async {
    late WebViewController controller;
    await tester.pumpWidget(
      WebView(
        initialUrl: 'https://flutter.io',
        onWebViewCreated: (WebViewController webViewController) {
          controller = webViewController;
        },
      ),
    );
    expect(
      () => controller.evaluateJavascript('fake js string'),
      throwsA(anything),
    );
  });

  testWidgets('Cookies can be cleared once', (WidgetTester tester) async {
    await tester.pumpWidget(
      const WebView(
        initialUrl: 'https://flutter.io',
      ),
    );
    final cookieManager = CookieManager();
    final hasCookies = await cookieManager.clearCookies();
    expect(hasCookies, true);
  });

  testWidgets('Second cookie clear does not have cookies', (WidgetTester tester) async {
    await tester.pumpWidget(
      const WebView(
        initialUrl: 'https://flutter.io',
      ),
    );
    final cookieManager = CookieManager();
    final hasCookies = await cookieManager.clearCookies();
    expect(hasCookies, true);
    final hasCookiesSecond = await cookieManager.clearCookies();
    expect(hasCookiesSecond, false);
  });

  testWidgets('Initial JavaScript channels', (WidgetTester tester) async {
    await tester.pumpWidget(
      WebView(
        initialUrl: 'https://youtube.com',
        javascriptChannels: <JavascriptChannel>{
          JavascriptChannel(name: 'Tts', onMessageReceived: (JavascriptMessage msg) {}),
          JavascriptChannel(name: 'Alarm', onMessageReceived: (JavascriptMessage msg) {}),
        },
      ),
    );

    final platformWebView = fakePlatformViewsController.lastCreatedView!;

    expect(platformWebView.javascriptChannelNames, unorderedEquals(<String>['Tts', 'Alarm']));
  });

  test('Only valid JavaScript channel names are allowed', () {
    void noOp(JavascriptMessage msg) {}
    JavascriptChannel(name: 'Tts1', onMessageReceived: noOp);
    JavascriptChannel(name: '_Alarm', onMessageReceived: noOp);
    JavascriptChannel(name: 'foo_bar_', onMessageReceived: noOp);

    VoidCallback createChannel(String name) {
      return () {
        JavascriptChannel(name: name, onMessageReceived: noOp);
      };
    }

    expect(createChannel('1Alarm'), throwsAssertionError);
    expect(createChannel('foo.bar'), throwsAssertionError);
    expect(createChannel(''), throwsAssertionError);
  });

  testWidgets('Unique JavaScript channel names are required', (WidgetTester tester) async {
    await tester.pumpWidget(
      WebView(
        initialUrl: 'https://youtube.com',
        javascriptChannels: <JavascriptChannel>{
          JavascriptChannel(name: 'Alarm', onMessageReceived: (JavascriptMessage msg) {}),
          JavascriptChannel(name: 'Alarm', onMessageReceived: (JavascriptMessage msg) {}),
        },
      ),
    );
    expect(tester.takeException(), isNot(null));
  });

  testWidgets('JavaScript channels update', (WidgetTester tester) async {
    await tester.pumpWidget(
      WebView(
        initialUrl: 'https://youtube.com',
        javascriptChannels: <JavascriptChannel>{
          JavascriptChannel(name: 'Tts', onMessageReceived: (JavascriptMessage msg) {}),
          JavascriptChannel(name: 'Alarm', onMessageReceived: (JavascriptMessage msg) {}),
        },
      ),
    );

    await tester.pumpWidget(
      WebView(
        initialUrl: 'https://youtube.com',
        javascriptChannels: <JavascriptChannel>{
          JavascriptChannel(name: 'Tts', onMessageReceived: (JavascriptMessage msg) {}),
          JavascriptChannel(name: 'Alarm2', onMessageReceived: (JavascriptMessage msg) {}),
          JavascriptChannel(name: 'Alarm3', onMessageReceived: (JavascriptMessage msg) {}),
        },
      ),
    );

    final platformWebView = fakePlatformViewsController.lastCreatedView!;

    expect(platformWebView.javascriptChannelNames, unorderedEquals(<String>['Tts', 'Alarm2', 'Alarm3']));
  });

  testWidgets('Remove all JavaScript channels and then add', (WidgetTester tester) async {
    // This covers a specific bug we had where after updating javascriptChannels to null,
    // updating it again with a subset of the previously registered channels fails as the
    // widget's cache of current channel wasn't properly updated when updating javascriptChannels to
    // null.
    await tester.pumpWidget(
      WebView(
        initialUrl: 'https://youtube.com',
        javascriptChannels: <JavascriptChannel>{
          JavascriptChannel(name: 'Tts', onMessageReceived: (JavascriptMessage msg) {}),
        },
      ),
    );

    await tester.pumpWidget(
      const WebView(
        initialUrl: 'https://youtube.com',
      ),
    );

    await tester.pumpWidget(
      WebView(
        initialUrl: 'https://youtube.com',
        javascriptChannels: <JavascriptChannel>{
          JavascriptChannel(name: 'Tts', onMessageReceived: (JavascriptMessage msg) {}),
        },
      ),
    );

    final platformWebView = fakePlatformViewsController.lastCreatedView!;

    expect(platformWebView.javascriptChannelNames, unorderedEquals(<String>['Tts']));
  });

  testWidgets('JavaScript channel messages', (WidgetTester tester) async {
    final ttsMessagesReceived = <String>[];
    final alarmMessagesReceived = <String>[];
    await tester.pumpWidget(
      WebView(
        initialUrl: 'https://youtube.com',
        javascriptChannels: <JavascriptChannel>{
          JavascriptChannel(
            name: 'Tts',
            onMessageReceived: (JavascriptMessage msg) {
              ttsMessagesReceived.add(msg.message);
            },
          ),
          JavascriptChannel(
            name: 'Alarm',
            onMessageReceived: (JavascriptMessage msg) {
              alarmMessagesReceived.add(msg.message);
            },
          ),
        },
      ),
    );

    final platformWebView = fakePlatformViewsController.lastCreatedView!;

    expect(ttsMessagesReceived, isEmpty);
    expect(alarmMessagesReceived, isEmpty);

    platformWebView.fakeJavascriptPostMessage('Tts', 'Hello');
    platformWebView.fakeJavascriptPostMessage('Tts', 'World');

    expect(ttsMessagesReceived, <String>['Hello', 'World']);
  });

  group('$PageStartedCallback', () {
    testWidgets('onPageStarted is not null', (WidgetTester tester) async {
      String? returnedUrl;

      await tester.pumpWidget(
        WebView(
          initialUrl: 'https://youtube.com',
          onPageStarted: (String url) {
            returnedUrl = url;
          },
        ),
      );

      final platformWebView = fakePlatformViewsController.lastCreatedView!;

      platformWebView.fakeOnPageStartedCallback();

      expect(platformWebView.currentUrl, returnedUrl);
    });

    testWidgets('onPageStarted is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        const WebView(
          initialUrl: 'https://youtube.com',
        ),
      );

      final platformWebView = fakePlatformViewsController.lastCreatedView!;

      // The platform side will always invoke a call for onPageStarted. This is
      // to test that it does not crash on a null callback.
      platformWebView.fakeOnPageStartedCallback();
    });

    testWidgets('onPageStarted changed', (WidgetTester tester) async {
      String? returnedUrl;

      await tester.pumpWidget(
        WebView(
          initialUrl: 'https://youtube.com',
          onPageStarted: (String url) {},
        ),
      );

      await tester.pumpWidget(
        WebView(
          initialUrl: 'https://youtube.com',
          onPageStarted: (String url) {
            returnedUrl = url;
          },
        ),
      );

      final platformWebView = fakePlatformViewsController.lastCreatedView!;

      platformWebView.fakeOnPageStartedCallback();

      expect(platformWebView.currentUrl, returnedUrl);
    });
  });

  group('$PageFinishedCallback', () {
    testWidgets('onPageFinished is not null', (WidgetTester tester) async {
      String? returnedUrl;

      await tester.pumpWidget(
        WebView(
          initialUrl: 'https://youtube.com',
          onPageFinished: (String url) {
            returnedUrl = url;
          },
        ),
      );

      final platformWebView = fakePlatformViewsController.lastCreatedView!;

      platformWebView.fakeOnPageFinishedCallback();

      expect(platformWebView.currentUrl, returnedUrl);
    });

    testWidgets('onPageFinished is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        const WebView(
          initialUrl: 'https://youtube.com',
        ),
      );

      final platformWebView = fakePlatformViewsController.lastCreatedView!;

      // The platform side will always invoke a call for onPageFinished. This is
      // to test that it does not crash on a null callback.
      platformWebView.fakeOnPageFinishedCallback();
    });

    testWidgets('onPageFinished changed', (WidgetTester tester) async {
      String? returnedUrl;

      await tester.pumpWidget(
        WebView(
          initialUrl: 'https://youtube.com',
          onPageFinished: (String url) {},
        ),
      );

      await tester.pumpWidget(
        WebView(
          initialUrl: 'https://youtube.com',
          onPageFinished: (String url) {
            returnedUrl = url;
          },
        ),
      );

      final platformWebView = fakePlatformViewsController.lastCreatedView!;

      platformWebView.fakeOnPageFinishedCallback();

      expect(platformWebView.currentUrl, returnedUrl);
    });
  });

  group('$PageLoadingCallback', () {
    testWidgets('onLoadingProgress is not null', (WidgetTester tester) async {
      int? loadingProgress;

      await tester.pumpWidget(
        WebView(
          initialUrl: 'https://youtube.com',
          onProgress: (int progress) {
            loadingProgress = progress;
          },
        ),
      );

      final platformWebView = fakePlatformViewsController.lastCreatedView;

      platformWebView?.fakeOnProgressCallback(50);

      expect(loadingProgress, 50);
    });

    testWidgets('onLoadingProgress is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        const WebView(
          initialUrl: 'https://youtube.com',
        ),
      );

      final platformWebView = fakePlatformViewsController.lastCreatedView!;

      // This is to test that it does not crash on a null callback.
      platformWebView.fakeOnProgressCallback(50);
    });

    testWidgets('onLoadingProgress changed', (WidgetTester tester) async {
      int? loadingProgress;

      await tester.pumpWidget(
        WebView(
          initialUrl: 'https://youtube.com',
          onProgress: (int progress) {},
        ),
      );

      await tester.pumpWidget(
        WebView(
          initialUrl: 'https://youtube.com',
          onProgress: (int progress) {
            loadingProgress = progress;
          },
        ),
      );

      final platformWebView = fakePlatformViewsController.lastCreatedView!;

      platformWebView.fakeOnProgressCallback(50);

      expect(loadingProgress, 50);
    });
  });

  group('navigationDelegate', () {
    testWidgets('hasNavigationDelegate', (WidgetTester tester) async {
      await tester.pumpWidget(
        const WebView(
          initialUrl: 'https://youtube.com',
        ),
      );

      final platformWebView = fakePlatformViewsController.lastCreatedView!;

      expect(platformWebView.hasNavigationDelegate, false);

      await tester.pumpWidget(
        WebView(
          initialUrl: 'https://youtube.com',
          navigationDelegate: (NavigationRequest r) => NavigationDecision.navigate,
        ),
      );

      expect(platformWebView.hasNavigationDelegate, true);
    });

    testWidgets('Block navigation', (WidgetTester tester) async {
      final navigationRequests = <NavigationRequest>[];

      await tester.pumpWidget(
        WebView(
          initialUrl: 'https://youtube.com',
          navigationDelegate: (NavigationRequest request) {
            navigationRequests.add(request);
            // Only allow navigating to https://flutter.dev
            return request.url == 'https://flutter.dev' ? NavigationDecision.navigate : NavigationDecision.prevent;
          },
        ),
      );

      final platformWebView = fakePlatformViewsController.lastCreatedView!;

      expect(platformWebView.hasNavigationDelegate, true);

      platformWebView.fakeNavigate('https://www.google.com');
      // The navigation delegate only allows navigation to https://flutter.dev
      // so we should still be in https://youtube.com.
      expect(platformWebView.currentUrl, 'https://youtube.com');
      expect(navigationRequests.length, 1);
      expect(navigationRequests[0].url, 'https://www.google.com');
      expect(navigationRequests[0].isForMainFrame, true);

      platformWebView.fakeNavigate('https://flutter.dev');
      await tester.pump();
      expect(platformWebView.currentUrl, 'https://flutter.dev');
    });
  });

  group('debuggingEnabled', () {
    testWidgets('enable debugging', (WidgetTester tester) async {
      await tester.pumpWidget(
        const WebView(
          debuggingEnabled: true,
        ),
      );

      final platformWebView = fakePlatformViewsController.lastCreatedView!;

      expect(platformWebView.debuggingEnabled, true);
    });

    testWidgets('defaults to false', (WidgetTester tester) async {
      await tester.pumpWidget(const WebView());

      final platformWebView = fakePlatformViewsController.lastCreatedView!;

      expect(platformWebView.debuggingEnabled, false);
    });

    testWidgets('can be changed', (WidgetTester tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(WebView(key: key));

      final platformWebView = fakePlatformViewsController.lastCreatedView!;

      await tester.pumpWidget(
        WebView(
          key: key,
          debuggingEnabled: true,
        ),
      );

      expect(platformWebView.debuggingEnabled, true);

      await tester.pumpWidget(
        WebView(
          key: key,
        ),
      );

      expect(platformWebView.debuggingEnabled, false);
    });
  });

  group('Custom platform implementation', () {
    setUpAll(() {
      WebView.platform = MyWebViewPlatform();
    });
    tearDownAll(() {
      WebView.platform = null;
    });

    testWidgets('creation', (WidgetTester tester) async {
      await tester.pumpWidget(
        const WebView(
          initialUrl: 'https://youtube.com',
          gestureNavigationEnabled: true,
        ),
      );

      final builder = WebView.platform as MyWebViewPlatform;
      final platform = builder.lastPlatformBuilt!;

      expect(
        platform.creationParams,
        MatchesCreationParams(
          CreationParams(
            initialUrl: 'https://youtube.com',
            webSettings: WebSettings(
              javascriptMode: JavascriptMode.disabled,
              hasNavigationDelegate: false,
              debuggingEnabled: false,
              userAgent: WebSetting<String?>.of(null),
              gestureNavigationEnabled: true,
            ),
          ),
        ),
      );
    });

    testWidgets('loadUrl', (WidgetTester tester) async {
      late WebViewController controller;
      await tester.pumpWidget(
        WebView(
          initialUrl: 'https://youtube.com',
          onWebViewCreated: (WebViewController webViewController) {
            controller = webViewController;
          },
        ),
      );

      final builder = WebView.platform as MyWebViewPlatform;
      final platform = builder.lastPlatformBuilt!;

      final headers = <String, String>{
        'header': 'value',
      };

      await controller.loadUrl('https://google.com', headers: headers);

      expect(platform.lastUrlLoaded, 'https://google.com');
      expect(platform.lastRequestHeaders, headers);
    });
  });
  testWidgets('Set UserAgent', (WidgetTester tester) async {
    await tester.pumpWidget(
      const WebView(
        initialUrl: 'https://youtube.com',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );

    final platformWebView = fakePlatformViewsController.lastCreatedView!;

    expect(platformWebView.userAgent, isNull);

    await tester.pumpWidget(
      const WebView(
        initialUrl: 'https://youtube.com',
        javascriptMode: JavascriptMode.unrestricted,
        userAgent: 'UA',
      ),
    );

    expect(platformWebView.userAgent, 'UA');
  });
}

class FakePlatformWebView {
  FakePlatformWebView(int? id, Map<dynamic, dynamic> params) {
    if (params.containsKey('initialUrl')) {
      final initialUrl = params['initialUrl'] as String?;
      if (initialUrl != null) {
        history.add(initialUrl);
        currentPosition++;
      }
    }
    if (params.containsKey('javascriptChannelNames')) {
      javascriptChannelNames = List<String>.from(params['javascriptChannelNames'] as Iterable<dynamic>);
    }
    final settings = params['settings'] as Map<dynamic, dynamic>;
    javascriptMode = JavascriptMode.values[settings['jsMode'] as int];
    hasNavigationDelegate = settings['hasNavigationDelegate'] as bool? ?? false;
    debuggingEnabled = settings['debuggingEnabled'] as bool?;
    userAgent = settings['userAgent'] as String?;
    channel = MethodChannel('plugins.flutter.io/webview_$id');
    channel.setMockMethodCallHandler(onMethodCall);
  }

  late MethodChannel channel;

  List<String?> history = <String?>[];
  int currentPosition = -1;
  int amountOfReloadsOnCurrentUrl = 0;
  bool hasCache = true;

  String? get currentUrl => history.isEmpty ? null : history[currentPosition];
  JavascriptMode? javascriptMode;
  List<String>? javascriptChannelNames;

  bool? hasNavigationDelegate;
  bool? debuggingEnabled;
  String? userAgent;

  Future<dynamic> onMethodCall(MethodCall call) {
    switch (call.method) {
      case 'loadUrl':
        final request = call.arguments as Map<dynamic, dynamic>;
        _loadUrl(request['url'] as String?);
        return Future<void>.sync(() {});
      case 'updateSettings':
        final request = call.arguments as Map<dynamic, dynamic>;
        if (request['jsMode'] != null) {
          javascriptMode = JavascriptMode.values[request['jsMode'] as int];
        }
        if (request['hasNavigationDelegate'] != null) {
          hasNavigationDelegate = request['hasNavigationDelegate'] as bool?;
        }
        if (request['debuggingEnabled'] != null) {
          debuggingEnabled = request['debuggingEnabled'] as bool?;
        }
        userAgent = request['userAgent'] as String?;
        break;
      case 'canGoBack':
        return Future<bool>.sync(() => currentPosition > 0);
      case 'canGoForward':
        return Future<bool>.sync(() => currentPosition < history.length - 1);
      case 'goBack':
        currentPosition = max(-1, currentPosition - 1);
        return Future<void>.sync(() {});
      case 'goForward':
        currentPosition = min(history.length - 1, currentPosition + 1);
        return Future<void>.sync(() {});
      case 'reload':
        amountOfReloadsOnCurrentUrl++;
        return Future<void>.sync(() {});
      case 'currentUrl':
        return Future<String?>.value(currentUrl);
      case 'evaluateJavascript':
        return Future<dynamic>.value(call.arguments);
      case 'addJavascriptChannels':
        final channelNames = List<String>.from(call.arguments as Iterable<dynamic>);
        javascriptChannelNames!.addAll(channelNames);
        break;
      case 'removeJavascriptChannels':
        final channelNames = List<String>.from(call.arguments as Iterable<dynamic>);
        javascriptChannelNames!.removeWhere(channelNames.contains);
        break;
      case 'clearCache':
        hasCache = false;
        return Future<void>.sync(() {});
    }
    return Future<void>.sync(() {});
  }

  void fakeJavascriptPostMessage(String jsChannel, String message) {
    const codec = StandardMethodCodec();
    final arguments = <String, dynamic>{'channel': jsChannel, 'message': message};
    final data = codec.encodeMethodCall(MethodCall('javascriptChannelMessage', arguments));
    ServicesBinding.instance.defaultBinaryMessenger.handlePlatformMessage(channel.name, data, (ByteData? data) {});
  }

  // Fakes a main frame navigation that was initiated by the webview, e.g when
  // the user clicks a link in the currently loaded page.
  void fakeNavigate(String url) {
    if (!hasNavigationDelegate!) {
      print('no navigation delegate');
      _loadUrl(url);
      return;
    }
    const codec = StandardMethodCodec();
    final arguments = <String, dynamic>{'url': url, 'isForMainFrame': true};
    final data = codec.encodeMethodCall(MethodCall('navigationRequest', arguments));
    ServicesBinding.instance.defaultBinaryMessenger.handlePlatformMessage(channel.name, data, (ByteData? data) {
      final allow = codec.decodeEnvelope(data!) as bool;
      if (allow) {
        _loadUrl(url);
      }
    });
  }

  void fakeOnPageStartedCallback() {
    const codec = StandardMethodCodec();

    final data = codec.encodeMethodCall(
      MethodCall(
        'onPageStarted',
        <dynamic, dynamic>{'url': currentUrl},
      ),
    );

    ServicesBinding.instance.defaultBinaryMessenger.handlePlatformMessage(
      channel.name,
      data,
      (ByteData? data) {},
    );
  }

  void fakeOnPageFinishedCallback() {
    const codec = StandardMethodCodec();

    final data = codec.encodeMethodCall(
      MethodCall(
        'onPageFinished',
        <dynamic, dynamic>{'url': currentUrl},
      ),
    );

    ServicesBinding.instance.defaultBinaryMessenger.handlePlatformMessage(
      channel.name,
      data,
      (ByteData? data) {},
    );
  }

  void fakeOnProgressCallback(int progress) {
    const codec = StandardMethodCodec();

    final data = codec.encodeMethodCall(
      MethodCall(
        'onProgress',
        <dynamic, dynamic>{'progress': progress},
      ),
    );

    ServicesBinding.instance.defaultBinaryMessenger.handlePlatformMessage(channel.name, data, (ByteData? data) {});
  }

  void _loadUrl(String? url) {
    history = history.sublist(0, currentPosition + 1);
    history.add(url);
    currentPosition++;
    amountOfReloadsOnCurrentUrl = 0;
  }
}

class _FakePlatformViewsController {
  FakePlatformWebView? lastCreatedView;

  Future<dynamic> fakePlatformViewsMethodHandler(MethodCall call) {
    switch (call.method) {
      case 'create':
        final args = call.arguments as Map<dynamic, dynamic>;
        final params = _decodeParams(args['params'] as Uint8List)!;
        lastCreatedView = FakePlatformWebView(
          args['id'] as int?,
          params,
        );
        return Future<int>.sync(() => 1);
      default:
        return Future<void>.sync(() {});
    }
  }

  void reset() {
    lastCreatedView = null;
  }
}

Map<dynamic, dynamic>? _decodeParams(Uint8List paramsMessage) {
  final buffer = paramsMessage.buffer;
  final messageBytes = buffer.asByteData(
    paramsMessage.offsetInBytes,
    paramsMessage.lengthInBytes,
  );
  return const StandardMessageCodec().decodeMessage(messageBytes) as Map<dynamic, dynamic>?;
}

class _FakeCookieManager {
  _FakeCookieManager() {
    const channel = MethodChannel(
      'plugins.flutter.io/cookie_manager',
    );
    channel.setMockMethodCallHandler(onMethodCall);
  }

  bool hasCookies = true;

  Future<bool> onMethodCall(MethodCall call) {
    switch (call.method) {
      case 'clearCookies':
        var hadCookies = false;
        if (hasCookies) {
          hadCookies = true;
          hasCookies = false;
        }
        return Future<bool>.sync(() {
          return hadCookies;
        });
    }
    return Future<bool>.sync(() => true);
  }

  void reset() {
    hasCookies = true;
  }
}

class MyWebViewPlatform implements WebViewPlatform {
  MyWebViewPlatformController? lastPlatformBuilt;

  @override
  Widget build({
    BuildContext? context,
    CreationParams? creationParams,
    required WebViewPlatformCallbacksHandler webViewPlatformCallbacksHandler,
    WebViewPlatformCreatedCallback? onWebViewPlatformCreated,
    Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers,
  }) {
    assert(onWebViewPlatformCreated != null);
    lastPlatformBuilt =
        MyWebViewPlatformController(creationParams, gestureRecognizers, webViewPlatformCallbacksHandler);
    onWebViewPlatformCreated!(lastPlatformBuilt);
    return Container();
  }

  @override
  Future<bool> clearCookies() {
    return Future<bool>.sync(() => true);
  }
}

class MyWebViewPlatformController extends WebViewPlatformController {
  MyWebViewPlatformController(
    this.creationParams,
    this.gestureRecognizers,
    WebViewPlatformCallbacksHandler platformHandler,
  ) : super(platformHandler);

  CreationParams? creationParams;
  Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;

  String? lastUrlLoaded;
  Map<String, String>? lastRequestHeaders;

  @override
  Future<void> loadUrl(String url, Map<String, String>? headers) async {
    equals(1, 1);
    lastUrlLoaded = url;
    lastRequestHeaders = headers;
  }
}

class MatchesWebSettings extends Matcher {
  MatchesWebSettings(this._webSettings);

  final WebSettings? _webSettings;

  @override
  Description describe(Description description) => description.add('$_webSettings');

  @override
  bool matches(covariant WebSettings webSettings, Map<dynamic, dynamic> matchState) {
    return _webSettings!.javascriptMode == webSettings.javascriptMode &&
        _webSettings!.hasNavigationDelegate == webSettings.hasNavigationDelegate &&
        _webSettings!.debuggingEnabled == webSettings.debuggingEnabled &&
        _webSettings!.gestureNavigationEnabled == webSettings.gestureNavigationEnabled &&
        _webSettings!.userAgent == webSettings.userAgent;
  }
}

class MatchesCreationParams extends Matcher {
  MatchesCreationParams(this._creationParams);

  final CreationParams _creationParams;

  @override
  Description describe(Description description) => description.add('$_creationParams');

  @override
  bool matches(covariant CreationParams creationParams, Map<dynamic, dynamic> matchState) {
    return _creationParams.initialUrl == creationParams.initialUrl &&
        MatchesWebSettings(_creationParams.webSettings).matches(creationParams.webSettings!, matchState) &&
        orderedEquals(_creationParams.javascriptChannelNames)
            .matches(creationParams.javascriptChannelNames, matchState);
  }
}
