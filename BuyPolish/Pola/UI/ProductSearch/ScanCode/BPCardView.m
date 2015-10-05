//
// Created by Paweł on 03/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "BPCardView.h"

NSInteger const CARD_TITLE_HEIGHT = 50;
NSInteger const CARD_PADDING = 5;

@interface BPCardView ()
@property(nonatomic, readonly) UILabel *productNameLabel;
@property(nonatomic, readonly) UILabel *barcodeLabel;
@property(nonatomic, readonly) UILabel *madeInPolandLabel;
@property(nonatomic, readonly) UILabel *madeInPolandInfoLabel;
@property(nonatomic, readonly) UILabel *companyNameLabel;
@property(nonatomic, readonly) UILabel *companyCapitalInPolandLabel;
@property(nonatomic, readonly) UILabel *companyCapitalInPolandInfoLabel;
@property(nonatomic, readonly) UILabel *companyNipLabel;
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

        _madeInPolandLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_madeInPolandLabel];

        _madeInPolandInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        [self addSubview:_madeInPolandInfoLabel];

        _productNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        [self addSubview:_productNameLabel];

        _companyNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        [self addSubview:_companyNameLabel];

        _companyCapitalInPolandLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        [self addSubview:_companyCapitalInPolandLabel];

        _companyCapitalInPolandInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        [self addSubview:_companyCapitalInPolandInfoLabel];

        _companyNipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        [self addSubview:_companyNipLabel];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect rect = CGRectZero;

    rect = self.madeInPolandLabel.frame;
    rect.origin.x = CARD_PADDING;
    rect.origin.y = CARD_TITLE_HEIGHT / 2 - CGRectGetHeight(rect) / 2;
    self.madeInPolandLabel.frame = rect;

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
    return self.companyNipLabel.text;
}

- (void)setBarcode:(NSString *)barcode {
    self.barcodeLabel.text = barcode;
    [self.barcodeLabel sizeToFit];
    [self setNeedsLayout];
}

- (NSNumber *)madeInPoland {
    return @(self.madeInPolandLabel.text.integerValue);
}

- (void)setMadeInPoland:(NSNumber *)madeInPoland {
    self.madeInPolandLabel.text = madeInPoland.stringValue;
    [self.madeInPolandLabel sizeToFit];
    [self setNeedsLayout];
}

//- (NSString *)productName {
//    return self.productNameLabel.text;
//}
//
//- (void)setProductName:(NSString *)productName {
//    self.productNameLabel.text = productName;
//    [self.productNameLabel sizeToFit];
//    [self setNeedsLayout];
//}


//- (NSString *)madeInPolandInfo {
//    return self.madeInPolandInfoLabel.text;
//}
//
//- (void)setMadeInPolandInfo:(NSString *)madeInPolandInfo {
//    self.madeInPolandInfoLabel.text = madeInPolandInfo;
//    [self.madeInPolandInfoLabel sizeToFit];
//    [self setNeedsLayout];
//}
//
//
//- (NSString *)companyName {
//    return self.companyNameLabel.text;
//}
//
//- (void)setCompanyName:(NSString *)companyName {
//    self.companyNameLabel.text = companyName;
//    [self.companyNameLabel sizeToFit];
//    [self setNeedsLayout];
//}
//
//- (NSNumber *)companyCapitalInPoland {
//    return nil;
//}
//
//- (void)setCompanyCapitalInPoland:(NSNumber *)companyCapitalInPoland {
//
//}
//
//
//- (NSString *)companyCapitalInPolandInfo {
//    return nil;
//}
//
//- (void)setCompanyCapitalInPolandInfo:(NSString *)companyCapitalInPolandInfo {
//
//}
//
//- (NSString *)companyNip {
//    return nil;
//}
//
//- (void)setCompanyNip:(NSString *)companyNip {
//
//}


@end