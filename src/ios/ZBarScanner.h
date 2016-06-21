
#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

@interface ZBarScanner : CDVPlugin

- (void)startScanning:(CDVInvokedUrlCommand*)command;

@end
