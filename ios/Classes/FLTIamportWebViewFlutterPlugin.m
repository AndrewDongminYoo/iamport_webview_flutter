// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "FLTIamportWebViewFlutterPlugin.h"
#import "FLTIamportCookieManager.h"
#import "IamportFlutterWebView.h"

@implementation FLTIamportWebViewFlutterPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FLTIamportWebViewFactory* webviewFactory =
      [[FLTIamportWebViewFactory alloc] initWithMessenger:registrar.messenger];
  [registrar registerViewFactory:webviewFactory withId:@"plugins.flutter.io/imp_webview"];
  [FLTIamportCookieManager registerWithRegistrar:registrar];
}

@end
