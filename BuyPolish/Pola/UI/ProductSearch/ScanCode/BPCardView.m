//
// Created by Paweł on 03/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "BPCardView.h"

NSInteger const CARD_TITLE_HEIGHT = 50;

@implementation BPCardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = [[UIColor blackColor] CGColor];
        self.layer.borderWidth = 1.0f;
        self.layer.cornerRadius = 10.0f;
        [self setClipsToBounds:YES];
    }

    return self;
}


@end