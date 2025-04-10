## 3.1.0

- Removed v1 android embedding

## 3.0.8

- Fixed a compile error when using Flutter version 3.27.0 or above.

## 3.0.7

- upgraded android gradle library version to 8.4.2

## 3.0.6

- enable mixed content in Android webview

## 3.0.5

- fix poor response performance for fast clicks in iOS webview

## 3.0.4

- Add navigation prevention logic when url is loading app

## 3.0.3

- Fix android issues with creating platform views

## 3.0.2

- fix conflict with original webview_flutter

## 3.0.1

- Add Javascript alert and confirm handlers on Android and iOS

## 3.0.0+5

- fix error in setAcceptThirdPartyCookies in ios

## 3.0.0+4

- Add setAcceptThirdPartyCookies functionality in ios

## 3.0.0+3

- fixed podspec name for ios

## 3.0.0+2

- fixed support for ios

## 3.0.0+1

- fixed methodCall argument error in setAcceptThirdPartyCookies

## 3.0.0

- Changed package name to iamport_webview_flutter
- Added support to allow third party cookies on Android
- Added support to load data with base URL on Android

## 2.0.4

- Fix a bug where `allowsInlineMediaPlayback` is not respected on iOS.

## 2.0.3

- Fixes bug where scroll bars on the Android non-hybrid WebView are rendered on
  the wrong side of the screen.

## 2.0.2

- Fixes bug where text fields are hidden behind the keyboard
  when hybrid composition is used [flutter/issues/75667](https://github.com/flutter/flutter/issues/7566 7).

## 2.0.1

- Run CocoaPods iOS tests in RunnerUITests target

## 2.0.0

- Migration to null-safety.
- Added support for progress tracking.
- Add section to the wiki explaining how to use Material components.
- Update integration test to workaround an iOS 14 issue with `evaluateJavascript`.
- Fix `onWebResourceError` on iOS.
- Fix outdated links across a number of markdown files ([#3276](https://github.com/flutter/plugins/pull/3276))
- Added `allowsInlineMediaPlayback` property.

## 1.0.8

- Update Flutter SDK constraint.

## 1.0.7

- Minor documentation update to indicate known issue on iOS 13.4 and 13.5.
  - See: https://github.com/flutter/flutter/issues/53490

## 1.0.6

- Invoke the WebView.onWebResourceError on iOS when the webview content process crashes.

## 1.0.5

- Fix example in the readme.

## 1.0.4

- Suppress the `deprecated_member_use` warning in the example app for `ScaffoldMessenger.showSnackBar`.

## 1.0.3

- Update android compileSdkVersion to 29.

## 1.0.2

- Android Code Inspection and Clean up.

## 1.0.1

- Add documentation for `WebViewPlatformCreatedCallback`.

## 1.0.0 - Out of developer preview 🎉.

- Bumped the minimal Flutter SDK to 1.22 where platform views are out of developer preview, and
  performing better on iOS. Flutter 1.22 no longer requires adding the
  `io.flutter.embedded_views_preview` flag to `Info.plist`.

- Added support for Hybrid Composition on Android (see opt-in instructions in [README](https://github.com/flutter/plugins/blob/master/packages/webview_flutter/README.md#android))
  - Lowered the required Android API to 19 (was previously 20): [#23728](https://github.com/flutter/flutter/issues/23728).
  - Fixed the following issues:
    - 🎹 Keyboard: [#41089](https://github.com/flutter/flutter/issues/41089), [#36478](https://github.com/flutter/flutter/issues/36478), [#51254](https://github.com/flutter/flutter/issues/51254), [#50716](https://github.com/flutter/flutter/issues/50716), [#55724](https://github.com/flutter/flutter/issues/55724), [#56513](https://github.com/flutter/flutter/issues/56513), [#56515](https://github.com/flutter/flutter/issues/56515), [#61085](https://github.com/flutter/flutter/issues/61085), [#62205](https://github.com/flutter/flutter/issues/62205), [#62547](https://github.com/flutter/flutter/issues/62547), [#58943](https://github.com/flutter/flutter/issues/58943), [#56361](https://github.com/flutter/flutter/issues/56361), [#56361](https://github.com/flutter/flutter/issues/42902), [#40716](https://github.com/flutter/flutter/issues/40716), [#37989](https://github.com/flutter/flutter/issues/37989), [#27924](https://github.com/flutter/flutter/issues/27924).
    - ♿️ Accessibility: [#50716](https://github.com/flutter/flutter/issues/50716).
    - ⚡️ Performance: [#61280](https://github.com/flutter/flutter/issues/61280), [#31243](https://github.com/flutter/flutter/issues/31243), [#52211](https://github.com/flutter/flutter/issues/52211).
    - 📹 Video: [#5191](https://github.com/flutter/flutter/issues/5191).

## 0.3.24

- Keep handling deprecated Android v1 classes for backward compatibility.

## 0.3.23

- Handle WebView multi-window support.

## 0.3.22+2

- Update package:e2e reference to use the local version in the flutter/plugins
  repository.

## 0.3.22+1

- Update the `setAndGetScrollPosition` to use hard coded values and add a `pumpAndSettle` call.

## 0.3.22

- Add support for passing a failing url.

## 0.3.21

- Enable programmatic scrolling using Android's WebView.scrollTo & iOS WKWebView.scrollView.contentOffset.

## 0.3.20+2

- Fix CocoaPods podspec lint warnings.

## 0.3.20+1

- OCMock module import -> #import, unit tests compile generated as library.
- Fix select drop down crash on old Android tablets (https://github.com/flutter/flutter/issues/54164).

## 0.3.20

- Added support for receiving web resource loading errors. See `WebView.onWebResourceError`.

## 0.3.19+10

- Replace deprecated `getFlutterEngine` call on Android.

## 0.3.19+9

- Remove example app's iOS workspace settings.

## 0.3.19+8

- Make the pedantic dev_dependency explicit.

## 0.3.19+7

- Remove the Flutter SDK constraint upper bound.

## 0.3.19+6

- Enable opening links that target the "\_blank" window (links open in same window).

## 0.3.19+5

- On iOS, always keep contentInsets of the WebView to be 0.
- Fix XCTest case to follow XCTest naming convention.

## 0.3.19+4

- On iOS, fix the scroll view content inset is automatically adjusted. After the fix, the content position of the WebView is customizable by Flutter.
- Fix an iOS 13 bug where the scroll indicator shows at random location.

## 0.3.19+3

- Setup XCTests.

## 0.3.19+2

- Migrate from deprecated BinaryMessages to ServicesBinding.instance.defaultBinaryMessenger.

## 0.3.19+1

- Raise min Flutter SDK requirement to the latest stable. v2 embedding apps no
  longer need to special case their Flutter SDK requirement like they have
  since v0.3.15+3.

## 0.3.19

- Add setting for iOS to allow gesture based navigation.

## 0.3.18+1

- Be explicit that keyboard is not ready for production in README.md.

## 0.3.18

- Add support for onPageStarted event.
- Remove the deprecated `author:` field from pubspec.yaml
- Migrate to the new pubspec platforms manifest.
- Require Flutter SDK 1.10.0 or greater.

## 0.3.17

- Fix pedantic lint errors. Added missing documentation and awaited some futures
  in tests and the example app.

## 0.3.16

- Add support for async NavigationDelegates. Synchronous NavigationDelegates
  should still continue to function without any change in behavior.

## 0.3.15+3

- Re-land support for the v2 Android embedding. This correctly sets the minimum
  SDK to the latest stable and avoid any compile errors. _WARNING:_ the V2
  embedding itself still requires the current Flutter master channel
  (flutter/flutter@1d4d63a) for text input to work properly on all Android
  versions.

## 0.3.15+2

- Remove AndroidX warnings.

## 0.3.15+1

- Revert the prior embedding support add since it requires an API that hasn't
  rolled to stable.

## 0.3.15

- Add support for the v2 Android embedding. This shouldn't affect existing
  functionality. Plugin authors who use the V2 embedding can now register the
  plugin and expect that it correctly responds to app lifecycle changes.

## 0.3.14+2

- Define clang module for iOS.

## 0.3.14+1

- Allow underscores anywhere for Javascript Channel name.

## 0.3.14

- Added a getTitle getter to WebViewController.

## 0.3.13

- Add an optional `userAgent` property to set a custom User Agent.

## 0.3.12+1

- Temporarily revert getTitle (doing this as a patch bump shortly after publishing).

## 0.3.12

- Added a getTitle getter to WebViewController.

## 0.3.11+6

- Calling destroy on Android webview when flutter webview is getting disposed.

## 0.3.11+5

- Reduce compiler warnings regarding iOS9 compatibility by moving a single
  method back into a `@available` block.

## 0.3.11+4

- Removed noisy log messages on iOS.

## 0.3.11+3

- Apply the display listeners workaround that was shipped in 0.3.11+1 on
  all Android versions prior to P.

## 0.3.11+2

- Add fix for input connection being dropped after a screen resize on certain
  Android devices.

## 0.3.11+1

- Work around a bug in old Android WebView versions that was causing a crash
  when resizing the webview on old devices.

## 0.3.11

- Add an initialAutoMediaPlaybackPolicy setting for controlling how auto media
  playback is restricted.

## 0.3.10+5

- Add dependency on `androidx.annotation:annotation:1.0.0`.

## 0.3.10+4

- Add keyboard text to README.

## 0.3.10+3

- Don't log an unknown setting key error for 'debuggingEnabled' on iOS.

## 0.3.10+2

- Fix InputConnection being lost when combined with route transitions.

## 0.3.10+1

- Add support for simultaenous Flutter `TextInput` and WebView text fields.

## 0.3.10

- Add partial WebView keyboard support for Android versions prior to N. Support
  for UIs that also have Flutter `TextInput` fields is still pending. This basic
  support currently only works with Flutter `master`. The keyboard will still
  appear when it previously did not when run with older versions of Flutter. But
  if the WebView is resized while showing the keyboard the text field will need
  to be focused multiple times for any input to be registered.

## 0.3.9+2

- Update Dart code to conform to current Dart formatter.

## 0.3.9+1

- Add missing template type parameter to `invokeMethod` calls.
- Bump minimum Flutter version to 1.5.0.
- Replace invokeMethod with invokeMapMethod wherever necessary.

## 0.3.9

- Allow external packages to provide webview implementations for new platforms.

## 0.3.8+1

- Suppress deprecation warning for BinaryMessages. See: https://github.com/flutter/flutter/issues/33446

## 0.3.8

- Add `debuggingEnabled` property.

## 0.3.7+1

- Fix an issue where JavaScriptChannel messages weren't sent from the platform thread on Android.

## 0.3.7

- Fix loadUrlWithHeaders flaky test.

## 0.3.6+1

- Remove un-used method params in webview_flutter

## 0.3.6

- Add an optional `headers` field to the controller.

## 0.3.5+5

- Fixed error in documentation of `javascriptChannels`.

## 0.3.5+4

- Fix bugs in the example app by updating it to use a `StatefulWidget`.

## 0.3.5+3

- Make sure to post javascript channel messages from the platform thread.

## 0.3.5+2

- Fix crash from `NavigationDelegate` on later versions of Android.

## 0.3.5+1

- Fix a bug where updates to onPageFinished were ignored.

## 0.3.5

- Added an onPageFinished callback.

## 0.3.4

- Support specifying navigation delegates that can prevent navigations from being executed.

## 0.3.3+2

- Exclude LongPress handler from semantics tree since it does nothing.

## 0.3.3+1

- Fixed a memory leak on Android - the WebView was not properly disposed.

## 0.3.3

- Add clearCache method to WebView controller.

## 0.3.2+1

- Log a more detailed warning at build time about the previous AndroidX
  migration.

## 0.3.2

- Added CookieManager to interface with WebView cookies. Currently has the ability to clear cookies.

## 0.3.1

- Added JavaScript channels to facilitate message passing from JavaScript code running inside
  the WebView to the Flutter app's Dart code.

## 0.3.0

- **Breaking change**. Migrate from the deprecated original Android Support
  Library to AndroidX. This shouldn't result in any functional changes, but it
  requires any Android apps using this plugin to [also
  migrate](https://developer.android.com/jetpack/androidx/migrate) if they're
  using the original support library.

## 0.2.0

- Added a evaluateJavascript method to WebView controller.
- (BREAKING CHANGE) Renamed the `JavaScriptMode` enum to `JavascriptMode`, and the WebView `javasScriptMode` parameter to `javascriptMode`.

## 0.1.2

- Added a reload method to the WebView controller.

## 0.1.1

- Added a `currentUrl` accessor for the WebView controller to look up what URL
  is being displayed.

## 0.1.0+1

- Fix null crash when initialUrl is unset on iOS.

## 0.1.0

- Add goBack, goForward, canGoBack, and canGoForward methods to the WebView controller.

## 0.0.1+1

- Fix case for "FLTWebViewFlutterPlugin" (iOS was failing to buld on case-sensitive file systems).

## 0.0.1

- Initial release.
