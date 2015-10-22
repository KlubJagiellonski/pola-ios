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
#import "BPTheme.h"

NSInteger const CARD_PADDING = 10;
int const CARD_PROGRESS_IN_HEADER = 3;
int const CARD_SEPARATOR_HEIGHT = 1;
int const CARD_MAIN_PROGRESS_BOTTOM_MARGIN = 25;
int const CARD_ROW_MARGIN = 14;
int const CARD_REPORT_BUTTON_HEIGHT = 30;

@interface BPProductCardView ()
@property(nonatomic, readonly) UILabel *titleLabel;
@property(nonatomic, readonly) UIActivityIndicatorView *loadingProgressView;
@property(nonatomic, readonly) UIButton *reportProblemButton;
@property(nonatomic, readonly) UILabel *capitalTitleLabel;
@property(nonatomic, readonly) BPMainProggressView *mainProgressView;
@property(nonatomic, readonly) BPSecondaryProgressView *capitalProgressView;
@property(nonatomic, readonly) UILabel *reportInfoLabel;
@property(nonatomic, readonly) UIView *separatorView;
@property(nonatomic, readonly) BPCheckRow *notGlobalCheckRow;
@property(nonatomic, readonly) BPCheckRow *registeredInPolandCheckRow;
@property(nonatomic, readonly) BPCheckRow *rndCheckRow;
@property(nonatomic, readonly) BPCheckRow *producesInPolandCheckRow;
@end

@implementation BPProductCardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [BPTheme clearColor];

        self.layer.cornerRadius = 8.0f;
        [self setClipsToBounds:YES];

        _loadingProgressView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_loadingProgressView sizeToFit];
        [self addSubview:_loadingProgressView];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [BPTheme titleFont];
        _titleLabel.textColor = [BPTheme defaultTextColor];
        [self addSubview:_titleLabel];

        _mainProgressView = [[BPMainProggressView alloc] initWithFrame:CGRectZero];
        [_mainProgressView sizeToFit];
        [self addSubview:_mainProgressView];

        _capitalTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _capitalTitleLabel.font = [BPTheme normalFont];
        _capitalTitleLabel.textColor = [BPTheme defaultTextColor];
        _capitalTitleLabel.text = NSLocalizedString(@"percent of polish holders", @"percent of polish holders");
        [_capitalTitleLabel sizeToFit];
        [self addSubview:_capitalTitleLabel];

        _capitalProgressView = [[BPSecondaryProgressView alloc] initWithFrame:CGRectZero];
        [_capitalProgressView sizeToFit];
        [self addSubview:_capitalProgressView];

        _reportProblemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reportProblemButton.layer.borderColor = [[BPTheme actionColor] CGColor];
        _reportProblemButton.layer.borderWidth = 1;
        [_reportProblemButton addTarget:self action:@selector(didTapReportProblem) forControlEvents:UIControlEventTouchUpInside];
        _reportProblemButton.titleLabel.font = [BPTheme buttonFont];
        [_reportProblemButton setTitleColor:[BPTheme actionColor] forState:UIControlStateNormal];
        [_reportProblemButton setTitle:[NSLocalizedString(@"Report", @"Report") uppercaseString] forState:UIControlStateNormal];
        [_reportProblemButton sizeToFit];
        [self addSubview:_reportProblemButton];

        _reportInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _reportInfoLabel.text = NSLocalizedString(@"Report info", @"Report info");
        _reportInfoLabel.numberOfLines = 3;
        _reportInfoLabel.font = [BPTheme normalFont];
        _reportInfoLabel.textColor = [BPTheme defaultTextColor];
        [_reportInfoLabel sizeToFit];
        [self addSubview:_reportInfoLabel];

        _separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CARD_SEPARATOR_HEIGHT)];
        _separatorView.backgroundColor = [BPTheme lightBackgroundColor];
        [self addSubview:_separatorView];

        _notGlobalCheckRow = [[BPCheckRow alloc] initWithFrame:CGRectZero];
        [_notGlobalCheckRow setText:NSLocalizedString(@"not part of global company", @"Not part of global company")];
        [_notGlobalCheckRow sizeToFit];
        [self addSubview:_notGlobalCheckRow];

        _registeredInPolandCheckRow = [[BPCheckRow alloc] initWithFrame:CGRectZero];
        [_registeredInPolandCheckRow setText:NSLocalizedString(@"is registered in Poland", @"is registered in Poland")];
        [_registeredInPolandCheckRow sizeToFit];
        [self addSubview:_registeredInPolandCheckRow];

        _rndCheckRow = [[BPCheckRow alloc] initWithFrame:CGRectZero];
        [_rndCheckRow setText:NSLocalizedString(@"created rich salary work places", @"created rich salary work places")];
        [_rndCheckRow sizeToFit];
        [self addSubview:_rndCheckRow];

        _producesInPolandCheckRow = [[BPCheckRow alloc] initWithFrame:CGRectZero];
        [_producesInPolandCheckRow setText:NSLocalizedString(@"producing in PL", @"producing in PL")];
        [_producesInPolandCheckRow sizeToFit];
        [self addSubview:_producesInPolandCheckRow];
    }

    return self;
}

- (void)didTapReportProblem {
    [self.delegate didTapReportProblem:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    const int verticalTitleSpace = self.titleHeight - CARD_PROGRESS_IN_HEADER;
    const int widthWithPadding = (const int) (CGRectGetWidth(self.bounds) - 2 * CARD_PADDING);

    CGRect rect = self.titleLabel.frame;
    rect.origin.x = CARD_PADDING;
    rect.origin.y = verticalTitleSpace / 2 - CGRectGetHeight(rect) / 2;
    rect.size.width = widthWithPadding;
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

    rect = self.capitalTitleLabel.frame;
    rect.origin.x = CARD_PADDING;
    rect.origin.y = CGRectGetMaxY(self.mainProgressView.frame) + CARD_MAIN_PROGRESS_BOTTOM_MARGIN;
    self.capitalTitleLabel.frame = rect;

    rect = self.capitalProgressView.frame;
    rect.size.width = widthWithPadding;
    rect.origin.x = CARD_PADDING;
    rect.origin.y = CGRectGetMaxY(self.capitalTitleLabel.frame) + CARD_PADDING;
    self.capitalProgressView.frame = rect;

    rect = self.reportProblemButton.frame;
    rect.size.height = CARD_REPORT_BUTTON_HEIGHT;
    rect.size.width = widthWithPadding;
    rect.origin.x = CARD_PADDING;
    rect.origin.y = CGRectGetHeight(self.bounds) - CARD_ROW_MARGIN - CGRectGetHeight(rect);
    self.reportProblemButton.frame = rect;

    rect = self.reportInfoLabel.frame;
    rect.size.width = widthWithPadding;
    rect.size.height = [self.reportInfoLabel heightForWidth:CGRectGetWidth(rect)];
    rect.origin.x = CARD_PADDING;
    rect.origin.y = CGRectGetMinY(self.reportProblemButton.frame) - CARD_ROW_MARGIN - CGRectGetHeight(rect);
    self.reportInfoLabel.frame = rect;

    rect = self.separatorView.frame;
    rect.size.width = CGRectGetWidth(self.bounds);
    rect.origin.x = 0;
    rect.origin.y = CGRectGetMinY(self.reportInfoLabel.frame) - 25 - CGRectGetHeight(rect);
    self.separatorView.frame = rect;

    rect = self.notGlobalCheckRow.frame;
    rect.size.width = widthWithPadding;
    rect.origin.x = CARD_PADDING;
    rect.origin.y = CGRectGetMinY(self.separatorView.frame) - CARD_ROW_MARGIN - CGRectGetHeight(rect);
    self.notGlobalCheckRow.frame = rect;

    rect = self.registeredInPolandCheckRow.frame;
    rect.size.width = widthWithPadding;
    rect.origin.x = CARD_PADDING;
    rect.origin.y = CGRectGetMinY(self.notGlobalCheckRow.frame) - CARD_ROW_MARGIN - CGRectGetHeight(rect);
    self.registeredInPolandCheckRow.frame = rect;

    rect = self.rndCheckRow.frame;
    rect.size.width = widthWithPadding;
    rect.origin.x = CARD_PADDING;
    rect.origin.y = CGRectGetMinY(self.registeredInPolandCheckRow.frame) - CARD_ROW_MARGIN - CGRectGetHeight(rect);
    self.rndCheckRow.frame = rect;

    rect = self.producesInPolandCheckRow.frame;
    rect.size.width = widthWithPadding;
    rect.origin.x = CARD_PADDING;
    rect.origin.y = CGRectGetMinY(self.rndCheckRow.frame) - CARD_ROW_MARGIN - CGRectGetHeight(rect);
    self.producesInPolandCheckRow.frame = rect;
}

- (BOOL)inProgress {
    return !self.loadingProgressView.hidden;
}

- (void)setInProgress:(BOOL)inProgress {
    self.loadingProgressView.hidden = !inProgress;
    self.capitalTitleLabel.hidden = inProgress;
    self.capitalProgressView.hidden = inProgress;
    self.reportProblemButton.hidden = inProgress;
    self.reportInfoLabel.hidden = inProgress;
    self.separatorView.hidden = inProgress;
    self.notGlobalCheckRow.hidden = inProgress;
    self.registeredInPolandCheckRow.hidden = inProgress;
    self.rndCheckRow.hidden = inProgress;
    self.producesInPolandCheckRow.hidden = inProgress;
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

- (void)setMainPercent:(CGFloat)mainPercent {
    self.mainProgressView.progress = mainPercent;
    [self.mainProgressView setNeedsLayout];
}

- (void)setCapitalPercent:(NSNumber *)capitalPercent {
    self.capitalProgressView.progress = capitalPercent;
    [self.capitalProgressView setNeedsLayout];
}

- (void)setProducesInPoland:(BOOL)producesInPoland {
    [self.producesInPolandCheckRow setChecked:producesInPoland];
}

- (void)setRnd:(BOOL)rnd {
    [self.rndCheckRow setChecked:rnd];
}

- (void)setRegisteredInPoland:(BOOL)registeredInPoland {
    [self.registeredInPolandCheckRow setChecked:registeredInPoland];
}

- (void)setNotGlobal:(BOOL)notGlobal {
    [self.notGlobalCheckRow setChecked:notGlobal];
}

- (void)setNeedsData:(BOOL)needsData {
    self.backgroundColor = needsData ? [BPTheme mediumBackgroundColor] : [BPTheme clearColor];
    self.mainProgressView.backgroundColor = needsData ? [BPTheme strongBackgroundColor] : [BPTheme lightBackgroundColor];
    self.capitalProgressView.fillColor = needsData ? [BPTheme strongBackgroundColor] : [BPTheme lightBackgroundColor];
    self.capitalProgressView.percentColor = needsData ? [BPTheme clearColor] : [BPTheme defaultTextColor];
}

@end