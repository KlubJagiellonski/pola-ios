//
// Created by Paweł on 19/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BPReport;
@class BPReportResult;


@interface BPReportManager : NSObject
- (void)sendReport:(BPReport *)report completion:(void (^)(BPReportResult *, NSError *))completion completionQueue:(NSOperationQueue *)completionQueue;
@end