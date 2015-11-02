//
// Created by Paweł on 03/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "BPCompanyCardView.h"
#import "BPMainProggressView.h"
#import "BPSecondaryProgressView.h"
#import "BPCheckRow.h"
#import "UILabel+BPAdditions.h"
#import "BPTheme.h"
#import "BPScanResult.h"
#import "BPCompanyContentView.h"

NSInteger const CARD_PADDING = 10;
int const CARD_SEPARATOR_HEIGHT = 1;
int const CARD_REPORT_MARGIN = 14;
int const CARD_REPORT_BUTTON_HEIGHT = 30;

@interface BPCompanyCardView ()
@property(nonatomic, readonly) BPCompanyContentView *contentView;
@property(nonatomic, readonly) UIButton *reportProblemButton;
@property(nonatomic, readonly) UILabel *reportInfoLabel;
@property(nonatomic, readonly) UIView *separatorView;
@end

@implementation BPCompanyCardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [BPTheme clearColor];

        self.layer.cornerRadius = 8.0f;
        self.layer.masksToBounds = NO;
        self.layer.shadowRadius = 2.f;
        self.layer.shadowOpacity = 0.3f;


        _contentView = [[BPCompanyContentView alloc] initWithFrame:CGRectZero];
        _contentView.padding = CARD_PADDING;
        [self addSubview:_contentView];

        _reportProblemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reportProblemButton addTarget:self action:@selector(didTapReportProblem) forControlEvents:UIControlEventTouchUpInside];
        _reportProblemButton.titleLabel.font = [BPTheme buttonFont];
        [_reportProblemButton sizeToFit];
        [self addSubview:_reportProblemButton];

        _reportInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _reportInfoLabel.numberOfLines = 3;
        _reportInfoLabel.font = [BPTheme normalFont];
        _reportInfoLabel.textColor = [BPTheme defaultTextColor];
        [_reportInfoLabel sizeToFit];
        [self addSubview:_reportInfoLabel];

        _separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CARD_SEPARATOR_HEIGHT)];
        _separatorView.backgroundColor = [BPTheme lightBackgroundColor];
        [self addSubview:_separatorView];
    }

    return self;
}

- (void)didTapReportProblem {
    [self.delegate didTapReportProblem:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    const int widthWithPadding = (const int) (CGRectGetWidth(self.bounds) - 2 * CARD_PADDING);

    CGRect rect = self.reportProblemButton.frame;
    rect.size.height = CARD_REPORT_BUTTON_HEIGHT;
    rect.size.width = widthWithPadding;
    rect.origin.x = CARD_PADDING;
    rect.origin.y = CGRectGetHeight(self.bounds) - CARD_REPORT_MARGIN - CGRectGetHeight(rect);
    self.reportProblemButton.frame = rect;

    rect = self.reportInfoLabel.frame;
    rect.size.width = widthWithPadding;
    rect.size.height = [self.reportInfoLabel heightForWidth:CGRectGetWidth(rect)];
    rect.origin.x = CARD_PADDING;
    rect.origin.y = CGRectGetMinY(self.reportProblemButton.frame) - CARD_REPORT_MARGIN - CGRectGetHeight(rect);
    self.reportInfoLabel.frame = rect;

    rect = self.separatorView.frame;
    rect.size.width = CGRectGetWidth(self.bounds);
    rect.origin.x = 0;
    rect.origin.y = CGRectGetMinY(self.reportInfoLabel.frame) - 15 - CGRectGetHeight(rect);
    self.separatorView.frame = rect;

    rect = self.contentView.frame;
    rect.size.width = CGRectGetWidth(self.bounds);
    rect.size.height = CGRectGetMinY(self.separatorView.frame);
    rect.origin.x = 0;
    rect.origin.y = 0;
    self.contentView.frame = rect;
}

- (void)setTitleHeight:(CGFloat)titleHeight {
    self.contentView.titleHeight = (int)floorf(titleHeight);
}

- (void)setContentType:(CompanyContentType)contentType {
    [self.contentView setContentType:contentType];

    BOOL subviewsHidden = contentType == CompanyContentTypeLoading;
    for (UIView *subview in self.subviews) {
        if([subview isEqual:self.contentView]) {
            continue;
        }
        self.reportProblemButton.hidden = subviewsHidden;
        self.reportInfoLabel.hidden = subviewsHidden;
        self.separatorView.hidden = subviewsHidden;
    }
}

- (void)setTitleText:(NSString *)titleText {
    [self.contentView setTitleText:titleText];
}

- (void)setMainPercent:(CGFloat)mainPercent {
    [self.contentView setMainPercent:mainPercent];
}

- (void)setCapitalPercent:(NSNumber *)capitalPercent notes:(NSString *)notes {
    [self.contentView setCapitalPercent:capitalPercent notes:notes];
}

- (void)setWorkers:(NSNumber *)workers notes:(NSString *)notes {
    [self.contentView setWorkers:workers notes:notes];
}

- (void)setRnd:(NSNumber *)rnd notes:(NSString *)notes {
    [self.contentView setRnd:rnd notes:notes];
}

- (void)setRegistered:(NSNumber *)registered notes:(NSString *)notes {
    [self.contentView setRegistered:registered notes:notes];
}

- (void)setNotGlobal:(NSNumber *)notGlobal notes:(NSString *)notes {
    [self.contentView setNotGlobal:notGlobal notes:notes];
}

- (void)setAltText:(NSString *)altText {
    [self.contentView setAltText:altText];
}

- (void)setCardType:(CardType)type {
    if (type == CardTypeGrey) {
        self.backgroundColor = [BPTheme mediumBackgroundColor];
    } else {
        self.backgroundColor = [BPTheme clearColor];
    }
    [self.contentView setCardType:type];
}

- (void)setReportButtonType:(ReportButtonType)type {
    if (type == ReportButtonTypeRed) {
        [self.reportProblemButton setTitleColor:[BPTheme clearColor] forState:UIControlStateNormal];
        [self.reportProblemButton setBackgroundImage:[BPUtilities imageWithColor:[BPTheme actionColor]] forState:UIControlStateNormal];
    } else {
        self.reportProblemButton.layer.borderColor = [[BPTheme actionColor] CGColor];
        self.reportProblemButton.layer.borderWidth = 1;
        [self.reportProblemButton setTitleColor:[BPTheme actionColor] forState:UIControlStateNormal];
        [self.reportProblemButton setTitleColor:[BPTheme clearColor] forState:UIControlStateHighlighted];
        [self.reportProblemButton setBackgroundImage:[BPUtilities imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [self.reportProblemButton setBackgroundImage:[BPUtilities imageWithColor:[BPTheme actionColor]] forState:UIControlStateHighlighted];
    }
}

- (void)setReportButtonText:(NSString *)text {
    [self.reportProblemButton setTitle:[text uppercaseString] forState:UIControlStateNormal];
    [self.reportProblemButton sizeToFit];
}

- (void)setReportText:(NSString *)text {
    self.reportInfoLabel.text = text;
    [self.reportInfoLabel sizeToFit];
}

@end