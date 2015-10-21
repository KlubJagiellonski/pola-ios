//
// Created by Paweł on 03/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "BPProductCardView.h"
#import "BPMainProggressView.h"
#import "UIColor+BPAdditions.h"
#import "BPSecondaryProgressView.h"
#import "BPCheckRow.h"
#import "UILabel+BPAdditions.h"

NSInteger const CARD_PADDING = 5;
int const CARD_PROGRESS_IN_HEADER = 3;
int const CARD_SEPARATOR_HEIGHT = 1;
int const CARD_MAIN_PROGRESS_BOTTOM_MARGIN = 20;

@interface BPProductCardView ()
@property(nonatomic, readonly) UILabel *titleLabel;
@property(nonatomic, readonly) UIActivityIndicatorView *loadingProgressView;
@property(nonatomic, readonly) UIButton *reportProblemButton;
@property(nonatomic, readonly) UILabel *notGlobalTitleLabel;
@property(nonatomic, readonly) BPMainProggressView *mainProgressView;
@property(nonatomic, readonly) BPSecondaryProgressView *notGlobalProgressView;
@property(nonatomic, readonly) UILabel *reportInfoLabel;
@property(nonatomic, readonly) UIView *separatorView;
@property(nonatomic, readonly) BPCheckRow *globalCheckRow;
@property(nonatomic, readonly) BPCheckRow *registeredInPolandCheckRow;
@property(nonatomic, readonly) BPCheckRow *rndCheckRow;
@property(nonatomic, readonly) BPCheckRow *producesInPolandCheckRow;
@end

@implementation BPProductCardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];

        self.layer.borderColor = [[UIColor blackColor] CGColor];
        self.layer.borderWidth = 1.0f;
        self.layer.cornerRadius = 10.0f;
        [self setClipsToBounds:YES];

        _loadingProgressView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_loadingProgressView sizeToFit];
        [self addSubview:_loadingProgressView];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = [UIColor blackColor];
        [self addSubview:_titleLabel];

        _mainProgressView = [[BPMainProggressView alloc] initWithFrame:CGRectZero];
        [_mainProgressView sizeToFit];
        [self addSubview:_mainProgressView];

        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setImage:[[UIImage imageNamed:@"MoreIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _moreButton.tintColor = [UIColor colorWithHexString:@"D93A2F"];
        [_moreButton sizeToFit];
        [self addSubview:_moreButton];

        _notGlobalTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _notGlobalTitleLabel.text = NSLocalizedString(@"percent of polish holders", @"percent of polish holders");
        [_notGlobalTitleLabel sizeToFit];
        [self addSubview:_notGlobalTitleLabel];

        _notGlobalProgressView = [[BPSecondaryProgressView alloc] initWithFrame:CGRectZero];
        [_notGlobalProgressView sizeToFit];
        [self addSubview:_notGlobalProgressView];

        _reportProblemButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_reportProblemButton addTarget:self action:@selector(didTapReportProblem) forControlEvents:UIControlEventTouchUpInside];
        [_reportProblemButton setTitle:[NSLocalizedString(@"Report", @"Report") uppercaseString] forState:UIControlStateNormal];
        [_reportProblemButton sizeToFit];
        [self addSubview:_reportProblemButton];
        
        _reportInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _reportInfoLabel.text = NSLocalizedString(@"Report info", @"Report info");
        _reportInfoLabel.numberOfLines = 3;
        _reportInfoLabel.textColor = [UIColor grayColor];
        [_reportInfoLabel sizeToFit];
        [self addSubview:_reportInfoLabel];

        _separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CARD_SEPARATOR_HEIGHT)];
        _separatorView.backgroundColor = [UIColor grayColor];
        [self addSubview:_separatorView];

        _globalCheckRow = [[BPCheckRow alloc] initWithFrame:CGRectZero];
        [_globalCheckRow setText:NSLocalizedString(@"not part of global company", @"Not part of global company")];
        [self addSubview:_globalCheckRow];

        _registeredInPolandCheckRow = [[BPCheckRow alloc] initWithFrame:CGRectZero];
        [_registeredInPolandCheckRow setText:NSLocalizedString(@"is registered in Poland", @"is registered in Poland")];
        [self addSubview:_registeredInPolandCheckRow];

        _rndCheckRow = [[BPCheckRow alloc] initWithFrame:CGRectZero];
        [_rndCheckRow setText:NSLocalizedString(@"created rich salary work places", @"created rich salary work places")];
        [self addSubview:_rndCheckRow];

        _producesInPolandCheckRow = [[BPCheckRow alloc] initWithFrame:CGRectZero];
        [_producesInPolandCheckRow setText:NSLocalizedString(@"producing in PL", @"producing in PL")];
        [self addSubview:_producesInPolandCheckRow];
    }

    return self;
}

- (void)didTapReportProblem {
    [self.delegate didTapReportProblem:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    int verticalTitleSpace = self.titleHeight - CARD_PROGRESS_IN_HEADER;

    CGRect rect = self.titleLabel.frame;
    rect.origin.x = CARD_PADDING;
    rect.origin.y = verticalTitleSpace / 2 - CGRectGetHeight(rect) / 2;
    rect.size.width = CGRectGetWidth(self.bounds) - 2 * CARD_PADDING;
    self.titleLabel.frame = rect;

    rect = self.loadingProgressView.frame;
    rect.origin.x = CGRectGetWidth(self.bounds) - CARD_PADDING - CGRectGetWidth(self.loadingProgressView.bounds);
    rect.origin.y = verticalTitleSpace / 2 - CGRectGetHeight(rect) / 2;
    self.loadingProgressView.frame = rect;

    rect = self.mainProgressView.frame;
    rect.size.width = CGRectGetWidth(self.bounds);
    rect.origin.x = 0;
    rect.origin.y = verticalTitleSpace;
    self.mainProgressView.frame = rect;

    rect = self.moreButton.frame;
    rect.origin.x = CGRectGetWidth(self.bounds) - CARD_PADDING - CGRectGetWidth(self.moreButton.bounds);
    rect.origin.y = CGRectGetMaxY(self.mainProgressView.frame) + 2 * CARD_PADDING;
    self.moreButton.frame = rect;

    rect = self.notGlobalTitleLabel.frame;
    rect.origin.x = CARD_PADDING;
    rect.origin.y =  CGRectGetMaxY(self.mainProgressView.frame) + CARD_MAIN_PROGRESS_BOTTOM_MARGIN;
    self.notGlobalTitleLabel.frame = rect;

    rect = self.notGlobalProgressView.frame;
    rect.size.width = CGRectGetWidth(self.bounds) - 2 * CARD_PADDING;
    rect.origin.x = CARD_PADDING;
    rect.origin.y = CGRectGetMaxY(self.notGlobalTitleLabel.frame) + CARD_PADDING;
    self.notGlobalProgressView.frame = rect;

    rect = self.reportProblemButton.frame;
    rect.size.width = CGRectGetWidth(self.bounds) - 2 * CARD_PADDING;
    rect.origin.x = CARD_PADDING;
    rect.origin.y = CGRectGetHeight(self.bounds) - CARD_PADDING - CGRectGetHeight(rect);
    self.reportProblemButton.frame = rect;

    rect = self.reportInfoLabel.frame;
    rect.size.width = CGRectGetWidth(self.bounds) - 2 * CARD_PADDING;
    rect.size.height = [self.reportInfoLabel heightForWidth:CGRectGetWidth(rect)];
    rect.origin.x = CARD_PADDING;
    rect.origin.y = CGRectGetMinY(self.reportProblemButton.frame) - CARD_PADDING - CGRectGetHeight(rect);
    self.reportInfoLabel.frame = rect;

    rect = self.separatorView.frame;


    rect = self.reportProblemButton.frame;
    rect.origin.x = 0;
    rect.origin.y = 150; //for now temporary
    self.reportProblemButton.frame = rect;
}

- (BOOL)inProgress {
    return !self.loadingProgressView.hidden;
}

- (void)setInProgress:(BOOL)inProgress {
    self.loadingProgressView.hidden = !inProgress;
    if (inProgress) {
        [self.loadingProgressView startAnimating];
    } else {
        [self.loadingProgressView stopAnimating];
    }
}

- (void)setTitleText:(NSString *)titleText {
    self.titleLabel.text = titleText;
    [self.titleLabel sizeToFit];
    [self setNeedsLayout];
}

@end