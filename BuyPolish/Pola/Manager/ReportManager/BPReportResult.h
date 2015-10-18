//
// Created by Paweł on 19/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BPReport;


extern const int REPORT_STATE_ADDED;
extern const int REPORT_STATE_IMAGE_ADDED;
extern const int REPORT_STATE_FINSIHED;


@interface BPReportResult : NSObject

@property (nonatomic) BOOL success;
@property (nonatomic) int state;
@property (nonatomic, strong) BPReport *report;
@property (nonatomic) int imageDownloadedIndex;

- (instancetype)initWithSuccess:(BOOL)success state:(int)state report:(BPReport *)report imageDownloadedIndex:(int)imageDownloadedIndex;

+ (instancetype)resultWithSuccess:(BOOL)success state:(int)state report:(BPReport *)report imageDownloadedIndex:(int)imageDownloadedIndex;


@end