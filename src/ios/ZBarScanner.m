//
//  AuthInfo.m
//
//  Created by Rameez Raja <mrameezraja@gmail.com> on 3/7/16.
//
//

#import <Foundation/Foundation.h>
#import "AuthInfo.h"

#define USERNAME @"zSwSReXJGZ8Ynben2ujDMUH"
#define PASSWORD @"c8T8dFuZLP4QG7f4uL5EdTZ"

@implementation AuthInfo

- (void)getAuthInfo:(CDVInvokedUrlCommand*)command
{
    NSMutableDictionary *jsonObj = [[NSMutableDictionary alloc] init];
    [jsonObj setValue: USERNAME forKey: @"username"];
    [jsonObj setValue: PASSWORD forKey: @"password"];

    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:jsonObj];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}


@end
