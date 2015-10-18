//
// Created by Paweł on 19/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "BPReport.h"


@implementation BPReport

- (instancetype)initWithBarcode:(NSString *)barcode description:(NSString *)desc imagePathArray:(NSArray *)imagePathArray {
    self = [super init];
    if (self) {
        _barcode = barcode;
        _desc = desc;
        _imagePathArray = imagePathArray;
    }

    return self;
}

+ (instancetype)reportWithBarcode:(NSString *)barcode description:(NSString *)desc imagePathArray:(NSArray *)imagePathArray {
    return [[self alloc] initWithBarcode:barcode description:desc imagePathArray:imagePathArray];
}

@end