//
// Created by Paweł Janeczek on 16/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Objection/Objection.h>
#import "BPReportProblemViewController.h"
#import "BPProductImageManager.h"


@interface BPReportProblemViewController ()
@property(nonatomic, readonly) BPProductImageManager *productImageManager;
@property(nonatomic, readonly) NSString *barcode;
@property(nonatomic) int imageCount;
@end

@implementation BPReportProblemViewController
objection_initializer_sel(@selector(initWithBarcode:))
objection_requires_sel(@selector(productImageManager))

- (instancetype)initWithBarcode:(NSString *)barcode {
    self = [super init];
    if (self) {
        _barcode = barcode;
        _imageCount = 1;
    }
    return self;
}

@end