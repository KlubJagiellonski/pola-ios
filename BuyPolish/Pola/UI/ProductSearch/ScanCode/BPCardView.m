//
// Created by Paweł on 03/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "BPCardView.h"

NSInteger const CARD_TITLE_HEIGHT = 50;
NSInteger const CARD_PADDING = 5;

@interface BPCardView ()
@property(nonatomic, readonly) UILabel *rightHeaderLabel;
@property(nonatomic, readonly) UILabel *leftHeaderLabel;
@property(nonatomic, readonly) UIActivityIndicatorView *progressView;
@end

@implementation BPCardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];

        self.layer.borderColor = [[UIColor blackColor] CGColor];
        self.layer.borderWidth = 1.0f;
        self.layer.cornerRadius = 10.0f;
        [self setClipsToBounds:YES];

        _progressView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_progressView sizeToFit];
        [self addSubview:_progressView];

        _rightHeaderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _rightHeaderLabel.adjustsFontSizeToFitWidth = YES;
        _rightHeaderLabel.minimumScaleFactor = 0.8f;
        [self addSubview:_rightHeaderLabel];

        _leftHeaderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _leftHeaderLabel.adjustsFontSizeToFitWidth = YES;
        _leftHeaderLabel.minimumScaleFactor = 0.8f;
        [self addSubview:_leftHeaderLabel];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect rect;

    rect = self.progressView.frame;
    rect.origin.x = CGRectGetWidth(self.bounds) / 2 - CGRectGetWidth(rect) / 2;
    rect.origin.y = CARD_TITLE_HEIGHT / 2 - CGRectGetHeight(rect) / 2;
    self.progressView.frame = rect;

    rect = self.leftHeaderLabel.frame;
    rect.origin.x = CARD_PADDING;
    rect.origin.y = CARD_TITLE_HEIGHT / 2 - CGRectGetHeight(rect) / 2;
    rect.size.width = CGRectGetMinX(self.progressView.frame) - CGRectGetMinX(rect);
    self.leftHeaderLabel.frame = rect;


    rect = self.rightHeaderLabel.frame;
    rect.size.width = CGRectGetWidth(self.leftHeaderLabel.frame);
    rect.origin.x = CGRectGetWidth(self.bounds) - CARD_PADDING - CGRectGetWidth(rect);
    rect.origin.y = CARD_TITLE_HEIGHT / 2 - CGRectGetHeight(rect) / 2;
    self.rightHeaderLabel.frame = rect;
}

- (BOOL)inProgress {
    return !self.progressView.hidden;
}

- (void)setInProgress:(BOOL)inProgress {
    self.progressView.hidden = !inProgress;
    if (inProgress) {
        [self.progressView startAnimating];
    } else {
        [self.progressView stopAnimating];
    }
}

- (void)setRightHeaderText:(NSString *)rightHeaderText {
    self.rightHeaderLabel.text = rightHeaderText;
    [self.rightHeaderLabel sizeToFit];
    [self setNeedsLayout];
}

- (void)setLeftHeaderText:(NSString *)leftHeaderText {
    self.leftHeaderLabel.text = leftHeaderText;
    [self.leftHeaderLabel sizeToFit];
    [self setNeedsLayout];
}

@end