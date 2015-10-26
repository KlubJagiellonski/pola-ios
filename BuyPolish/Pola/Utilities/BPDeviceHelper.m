//
// Created by Paweł Janeczek on 26/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "BPDeviceHelper.h"


@implementation BPDeviceHelper

+ (NSString *)deviceId {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (NSString *)deviceInfo {
    UIDevice *device = [UIDevice currentDevice];

    NSMutableString *deviceInfo = [NSMutableString stringWithString:@"\n\n-------App & Device info--------"];
    [deviceInfo appendFormat:@"- device: %@, %@", [device name], [device model]];
    [deviceInfo appendFormat:@"- system: %@, %@", [device systemName], [device systemVersion]];
    [deviceInfo appendFormat:@"- app: %@, %@", [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]];
    [deviceInfo appendString:@"-------End-------"];
    return deviceInfo;
}
@end