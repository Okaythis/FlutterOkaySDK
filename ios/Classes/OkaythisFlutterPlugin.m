#import "OkaythisFlutterPlugin.h"
#import <okaythis_flutter_plugin/okaythis_flutter_plugin-Swift.h>

@implementation OkaythisFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftOkaythisFlutterPlugin registerWithRegistrar:registrar];
}
@end
