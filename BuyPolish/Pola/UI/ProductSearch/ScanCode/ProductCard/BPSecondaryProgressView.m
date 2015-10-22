//
// Created by Paweł on 21/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "BPSecondaryProgressView.h"
#import "UIColor+BPAdditions.h"


const int SECONDARY_PROGRESS_HEIGHT = 25;
const int SECONDARY_PROGRESS_TITLE_MARGIN = 10;


@interface BPSecondaryProgressView ()
@property(nonatomic, readonly) UIView *filledProgressView;
@property(nonatomic, readonly) UILabel *percentLabel;
@end


@implementation BPSecondaryProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _filledProgressView = [[UIView alloc] initWithFrame:CGRectZero];
        _filledProgressView.backgroundColor = [UIColor colorWithHexString:@"CCCCCC"];
        [self addSubview:_filledProgressView];

        _percentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _percentLabel.text = @"?";
        [_percentLabel sizeToFit];
        [self addSubview:_percentLabel];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect rect = CGRectZero;
    rect.origin = CGPointMake(0, 0);
    rect.size = CGSizeMake(CGRectGetWidth(self.bounds) * self.progress, CGRectGetHeight(self.bounds));
    self.filledProgressView.frame = rect;

    int percentLabelRequiredSpace = (int) (CGRectGetWidth(self.percentLabel.bounds) + 2 * SECONDARY_PROGRESS_TITLE_MARGIN);

    rect = self.percentLabel.frame;
    if(percentLabelRequiredSpace > CGRectGetWidth(self.filledProgressView.frame)) {
        rect.origin.x = CGRectGetMaxX(self.filledProgressView.frame) + SECONDARY_PROGRESS_TITLE_MARGIN;
    } else {
        rect.origin.x = CGRectGetMaxX(self.filledProgressView.frame) - SECONDARY_PROGRESS_TITLE_MARGIN - CGRectGetWidth(self.percentLabel.bounds);
    }
    rect.origin.y = CGRectGetHeight(self.bounds) / 2 - CGRectGetHeight(self.percentLabel.bounds) / 2;
    self.percentLabel.frame = rect;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;

    int progressInt = (int) (progress * 100);
    self.percentLabel.text = [NSString stringWithFormat:@"%i%%", progressInt];
    [self.percentLabel sizeToFit];

    [self setNeedsLayout];
    [self layoutIfNeeded];
}


- (CGSize)sizeThatFits:(CGSize)size {
    size.height = SECONDARY_PROGRESS_HEIGHT;
    return size;
}

@end