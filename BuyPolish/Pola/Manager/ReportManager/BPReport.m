//
// Created by Paweł on 19/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "BPReport.h"


@implementation BPReport

- (instancetype)initWithKey:(NSString *)key description:(NSString *)desc imagePathArray:(NSArray *)imagePathArray {
    self = [super init];
    if (self) {
        _key = key;
        _desc = desc;
        _imagePathArray = imagePathArray;
    }

    return self;
}

+ (instancetype)reportWithKey:(NSString *)key description:(NSString *)desc imagePathArray:(NSArray *)imagePathArray {
    return [[self alloc] initWithKey:key description:desc imagePathArray:imagePathArray];
}

@end