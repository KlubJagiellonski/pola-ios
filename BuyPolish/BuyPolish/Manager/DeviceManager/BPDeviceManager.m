//
// Created by Paweł on 25/08/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "BPDeviceManager.h"


@implementation BPDeviceManager

- (NSString *)deviceId {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

@end