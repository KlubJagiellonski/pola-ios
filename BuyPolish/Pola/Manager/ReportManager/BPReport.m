//
// Created by Paweł on 19/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "BPReport.h"


@implementation BPReport

- (instancetype)initWithProductId:(NSNumber *)productId description:(NSString *)desc imagePathArray:(NSArray *)imagePathArray {
    self = [super init];
    if (self) {
        _productId = productId;
        _desc = desc;
        _imagePathArray = imagePathArray;
    }

    return self;
}

+ (instancetype)reportWithProductId:(NSNumber *)productId description:(NSString *)desc imagePathArray:(NSArray *)imagePathArray {
    return [[self alloc] initWithProductId:productId description:desc imagePathArray:imagePathArray];
}

@end