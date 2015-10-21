//
// Created by Paweł on 21/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "BPCheckRow.h"


const int CHECK_ROW_HORIZONTAL_MARGIN = 10;


@interface BPCheckRow ()
@property(nonatomic, readonly) UIImageView *checkImageView;
@property(nonatomic, readonly) UILabel *textLabel;
@end

@implementation BPCheckRow

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _checkImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _checkImageView.tintColor = [UIColor grayColor];
        [self addSubview:_checkImageView];

        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.textColor = [UIColor grayColor];
        [self addSubview:_textLabel];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect rect = self.checkImageView.frame;
    rect.origin.x = 0;
    rect.origin.y = CGRectGetHeight(self.bounds) / 2 - CGRectGetHeight(rect) / 2;
    self.checkImageView.frame = rect;

    rect = self.textLabel.frame;
    rect.origin.x = CGRectGetMaxX(self.checkImageView.frame) + CHECK_ROW_HORIZONTAL_MARGIN;
    rect.origin.y = CGRectGetHeight(self.bounds) / 2 - CGRectGetHeight(rect) / 2;
    self.textLabel.frame = rect;
}

- (void)setText:(NSString *)text {
    self.textLabel.text = text;
    [self.textLabel sizeToFit];
    [self setNeedsLayout];
}

- (void)setChecked:(BOOL)checked {
    self.checkImageView.image = [[UIImage imageNamed:checked ? @"TrueIcon" : @"FalseIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.checkImageView sizeToFit];
    [self setNeedsLayout];
}

- (CGSize)sizeThatFits:(CGSize)size {
    size.width = CGRectGetWidth(self.checkImageView.bounds) + CHECK_ROW_HORIZONTAL_MARGIN + CGRectGetWidth(self.textLabel.bounds);
    size.height = MAX(CGRectGetHeight(self.checkImageView.bounds), CGRectGetHeight(self.textLabel.bounds));
    return size;
}


@end