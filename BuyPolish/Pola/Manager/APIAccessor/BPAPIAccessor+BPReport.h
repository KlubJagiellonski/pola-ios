//
// Created by Paweł on 19/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BPAPIAccessor.h"

@interface BPAPIAccessor (BPReport)

- (NSDictionary *)addReportWithDescription:(NSString *)description productId:(NSNumber *)productId filesCount:(NSUInteger)filesCount error:(NSError **)error;

- (NSDictionary *)addImageAtPath:(NSString *)imageAtPath forUrl:(NSString *)requestUrl error:(NSError **)error;

@end