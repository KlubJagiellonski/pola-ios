//
// Created by Paweł on 19/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BPAPIAccessor.h"

@interface BPAPIAccessor (BPReport)

- (NSDictionary *)addReportWithDescription:(NSString *)description error:(NSError **)error;
- (NSDictionary *)addImageAtPath:(NSString *)imageAtPath forReportId:(NSNumber *)reportId error:(NSError **)error;

@end