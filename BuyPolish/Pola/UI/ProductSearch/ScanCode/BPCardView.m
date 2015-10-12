//
// Created by Paweł on 03/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "BPCardView.h"

NSInteger const CARD_TITLE_HEIGHT = 50;
NSInteger const CARD_PADDING = 5;

@interface BPCardView ()
@property(nonatomic, readonly) UILabel *barcodeLabel;
@property(nonatomic, readonly) UILabel *verifiedLabel;
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

        _barcodeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_barcodeLabel];

        _verifiedLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_verifiedLabel];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect rect;

    rect = self.verifiedLabel.frame;
    rect.origin.x = CARD_PADDING;
    rect.origin.y = CARD_TITLE_HEIGHT / 2 - CGRectGetHeight(rect) / 2;
    self.verifiedLabel.frame = rect;

    rect = self.progressView.frame;
    rect.origin.x = CGRectGetWidth(self.bounds) / 2 - CGRectGetWidth(rect) / 2;
    rect.origin.y = CARD_TITLE_HEIGHT / 2 - CGRectGetHeight(rect) / 2;
    self.progressView.frame = rect;

    rect = self.barcodeLabel.frame;
    rect.origin.x = CGRectGetWidth(self.bounds) - CARD_PADDING - CGRectGetWidth(rect);
    rect.origin.y = CARD_TITLE_HEIGHT / 2 - CGRectGetHeight(rect) / 2;
    self.barcodeLabel.frame = rect;
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

- (NSString *)barcode {
    return self.barcodeLabel.text;
}

- (void)setBarcode:(NSString *)barcode {
    self.barcodeLabel.text = barcode;
    [self.barcodeLabel sizeToFit];
    [self setNeedsLayout];
}

- (void)setVerified:(BOOL)verified {
    self.verifiedLabel.text = verified ? @"Verified" : @"Not verified";
    [self.verifiedLabel sizeToFit];
    [self setNeedsLayout];
}

@end