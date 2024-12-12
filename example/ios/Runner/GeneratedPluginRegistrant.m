//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<iamport_webview_flutter/FLTIamportWebViewFlutterPlugin.h>)
#import <iamport_webview_flutter/FLTIamportWebViewFlutterPlugin.h>
#else
@import iamport_webview_flutter;
#endif

#if __has_include(<integration_test/IntegrationTestPlugin.h>)
#import <integration_test/IntegrationTestPlugin.h>
#else
@import integration_test;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FLTIamportWebViewFlutterPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTIamportWebViewFlutterPlugin"]];
  [IntegrationTestPlugin registerWithRegistrar:[registry registrarForPlugin:@"IntegrationTestPlugin"]];
}

@end
