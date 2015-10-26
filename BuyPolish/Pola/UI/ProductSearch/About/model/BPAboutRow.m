//
// Created by Paweł on 26/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "BPAboutRow.h"


@implementation BPAboutRow

- (instancetype)initWithTitle:(NSString *)title action:(SEL)action {
    self = [super init];
    if (self) {
        _title = [title copy];
        _action = action;
    }

    return self;
}

+ (instancetype)rowWithTitle:(NSString *)title action:(SEL)action {
    return [[self alloc] initWithTitle:title action:action];
}

@end