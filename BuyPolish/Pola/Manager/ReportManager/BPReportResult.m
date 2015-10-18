//
// Created by Paweł on 19/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "BPReportResult.h"
#import "BPReport.h"

const int REPORT_STATE_ADDED = 0;
const int REPORT_STATE_IMAGE_ADDED = 1;
const int REPORT_STATE_FINSIHED = 2;

@implementation BPReportResult {

}
- (instancetype)initWithSuccess:(BOOL)success state:(int)state report:(BPReport *)report imageDownloadedIndex:(int)imageDownloadedIndex {
    self = [super init];
    if (self) {
        _success = success;
        _state = state;
        _report = report;
        _imageDownloadedIndex = imageDownloadedIndex;
    }

    return self;
}

+ (instancetype)resultWithSuccess:(BOOL)success state:(int)state report:(BPReport *)report imageDownloadedIndex:(int)imageDownloadedIndex {
    return [[self alloc] initWithSuccess:success state:state report:report imageDownloadedIndex:imageDownloadedIndex];
}

@end