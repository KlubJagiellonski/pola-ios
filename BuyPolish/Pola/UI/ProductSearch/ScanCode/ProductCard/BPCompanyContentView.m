//
// Created by Paweł on 19/11/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "BPCompanyContentView.h"
#import "BPMainProggressView.h"
#import "BPSecondaryProgressView.h"
#import "BPCheckRow.h"
#import "BPTheme.h"
#import "UILabel+BPAdditions.h"

int const CARD_CONTENT_PROGRESS_IN_HEADER = 3;
int const CARD_CONTENT_PROGRESS_BOTTOM_MARGIN = 14;
int const CARD_CONTENT_ROW_MARGIN = 14;
int const CARD_CONTENT_NOTES_MARGIN = 4;

@interface BPCompanyContentView ()

@property(nonatomic, readonly) UILabel *titleLabel;
@property(nonatomic, readonly) UIActivityIndicatorView *loadingProgressView;
@property(nonatomic, readonly) UILabel *capitalTitleLabel;
@property(nonatomic, readonly) BPMainProggressView *mainProgressView;
@property(nonatomic, readonly) BPSecondaryProgressView *capitalProgressView;
@property(nonatomic, readonly) UILabel *capitalNotesLabel;
@property(nonatomic, readonly) BPCheckRow *notGlobalCheckRow;
@property(nonatomic, readonly) BPCheckRow *registeredCheckRow;
@property(nonatomic, readonly) BPCheckRow *rndCheckRow;
@property(nonatomic, readonly) BPCheckRow *workersCheckRow;
@property(nonatomic, readonly) UILabel *altTextLabel;

@end

@implementation BPCompanyContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
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

        _capitalNotesLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _capitalNotesLabel.font = [BPTheme captionFont];
        _capitalNotesLabel.textColor = [BPTheme defaultTextColor];
        _capitalNotesLabel.numberOfLines = 0;
        [self addSubview:_capitalNotesLabel];

        _notGlobalCheckRow = [[BPCheckRow alloc] initWithFrame:CGRectZero];
        [_notGlobalCheckRow setText:NSLocalizedString(@"not part of global company", @"Not part of global company")];
        [_notGlobalCheckRow sizeToFit];
        [self addSubview:_notGlobalCheckRow];

        _registeredCheckRow = [[BPCheckRow alloc] initWithFrame:CGRectZero];
        [_registeredCheckRow setText:NSLocalizedString(@"is registered in Poland", @"is registered in Poland")];
        [_registeredCheckRow sizeToFit];
        [self addSubview:_registeredCheckRow];

        _rndCheckRow = [[BPCheckRow alloc] initWithFrame:CGRectZero];
        [_rndCheckRow setText:NSLocalizedString(@"created rich salary work places", @"created rich salary work places")];
        [_rndCheckRow sizeToFit];
        [self addSubview:_rndCheckRow];

        _workersCheckRow = [[BPCheckRow alloc] initWithFrame:CGRectZero];
        [_workersCheckRow setText:NSLocalizedString(@"producing in PL", @"producing in PL")];
        [_workersCheckRow sizeToFit];
        [self addSubview:_workersCheckRow];

        _altTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _altTextLabel.font = [BPTheme normalFont];
        _altTextLabel.textColor = [BPTheme defaultTextColor];
        [self addSubview:_altTextLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    const int verticalTitleSpace = self.titleHeight - CARD_CONTENT_PROGRESS_IN_HEADER;
    const int widthWithPadding = (const int) (CGRectGetWidth(self.bounds) - 2 * self.padding);

    CGRect rect = self.titleLabel.frame;
    rect.origin.x = self.padding;
    rect.origin.y = verticalTitleSpace / 2 - CGRectGetHeight(rect) / 2;
    rect.size.width = widthWithPadding;
    self.titleLabel.frame = rect;

    int bottom = 0;
    if (self.contentType == CompanyContentTypeDefault) {
        bottom = [self layoutDefaultSubviews:verticalTitleSpace width:widthWithPadding];
    } else if (self.contentType == CompanyContentTypeLoading) {
        bottom = [self layoutLoadingSubviews:verticalTitleSpace];
    } else if (self.contentType == CompanyContentTypeAlt) {
        bottom = [self layoutAltSubviews:widthWithPadding];
    }

    self.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), bottom);
}

- (int)layoutDefaultSubviews:(const int)verticalTitleSpace width:(const int)widthWithPadding {
    CGRect rect = self.mainProgressView.frame;
    rect.size.width = CGRectGetWidth(self.bounds);
    rect.origin.x = 0;
    rect.origin.y = verticalTitleSpace;
    self.mainProgressView.frame = rect;

    rect = self.capitalTitleLabel.frame;
    rect.origin.x = self.padding;
    rect.origin.y = CGRectGetMaxY(self.mainProgressView.frame) + CARD_CONTENT_PROGRESS_BOTTOM_MARGIN;
    self.capitalTitleLabel.frame = rect;

    rect = self.capitalProgressView.frame;
    rect.size.width = widthWithPadding;
    rect.origin.x = self.padding;
    rect.origin.y = CGRectGetMaxY(self.capitalTitleLabel.frame) + self.padding;
    self.capitalProgressView.frame = rect;

    rect = self.capitalNotesLabel.frame;
    rect.size.width = widthWithPadding;
    rect.size.height = [self.capitalNotesLabel heightForWidth:widthWithPadding];
    rect.origin.x = self.padding;
    rect.origin.y = CGRectGetMaxY(self.capitalProgressView.frame) + CARD_CONTENT_NOTES_MARGIN;
    self.capitalNotesLabel.frame = rect;

    rect = self.workersCheckRow.frame;
    rect.size = [self.workersCheckRow sizeThatFits:CGSizeMake(widthWithPadding, 0)];
    rect.origin.x = self.padding;
    rect.origin.y = CGRectGetMaxY(self.capitalNotesLabel.frame) + CARD_CONTENT_PROGRESS_BOTTOM_MARGIN;
    self.workersCheckRow.frame = rect;

    rect = self.rndCheckRow.frame;
    rect.size = [self.rndCheckRow sizeThatFits:CGSizeMake(widthWithPadding, 0)];
    rect.origin.x = self.padding;
    rect.origin.y = CGRectGetMaxY(self.workersCheckRow.frame) + CARD_CONTENT_ROW_MARGIN;
    self.rndCheckRow.frame = rect;

    rect = self.registeredCheckRow.frame;
    rect.size = [self.registeredCheckRow sizeThatFits:CGSizeMake(widthWithPadding, 0)];
    rect.origin.x = self.padding;
    rect.origin.y = CGRectGetMaxY(self.rndCheckRow.frame) + CARD_CONTENT_ROW_MARGIN;
    self.registeredCheckRow.frame = rect;

    rect = self.notGlobalCheckRow.frame;
    rect.size = [self.notGlobalCheckRow sizeThatFits:CGSizeMake(widthWithPadding, 0)];
    rect.origin.x = self.padding;
    rect.origin.y = CGRectGetMaxY(self.registeredCheckRow.frame) + CARD_CONTENT_ROW_MARGIN;
    self.notGlobalCheckRow.frame = rect;

    return (int) CGRectGetMaxY(self.notGlobalCheckRow.frame);
}

- (int)layoutLoadingSubviews:(const int)verticalTitleSpace {
    CGRect rect = self.loadingProgressView.frame;
    rect.origin.x = CGRectGetWidth(self.bounds) - self.padding - CGRectGetWidth(self.loadingProgressView.bounds);
    rect.origin.y = verticalTitleSpace / 2 - CGRectGetHeight(rect) / 2;
    self.loadingProgressView.frame = rect;

    return (int) CGRectGetMaxY(self.loadingProgressView.frame);
}

- (int)layoutAltSubviews:(const int)widthWithPadding {
    CGRect rect = self.altTextLabel.frame;
    rect.size.width = widthWithPadding;
    rect.size.height = [self.altTextLabel heightForWidth:CGRectGetWidth(rect)];
    rect.origin.x = self.padding;
    rect.origin.y = CGRectGetHeight(self.bounds) / 2 - CGRectGetHeight(rect) / 2;
    self.altTextLabel.frame = rect;

    return (int) CGRectGetMaxY(self.altTextLabel.frame);
}

- (void)setContentType:(CompanyContentType)type {
    _contentType = type;

    static NSDictionary *typeToViewsDictionary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        typeToViewsDictionary = @{
            @(CompanyContentTypeDefault) : @[
                self.titleLabel,
                self.mainProgressView,
                self.capitalTitleLabel,
                self.capitalProgressView,
                self.capitalNotesLabel,
                self.workersCheckRow,
                self.rndCheckRow,
                self.registeredCheckRow,
                self.notGlobalCheckRow
            ],
            @(CompanyContentTypeLoading) : @[
                self.titleLabel,
                self.loadingProgressView
            ],
            @(CompanyContentTypeAlt) : @[
                self.titleLabel,
                self.altTextLabel
            ]
        };
    });

    NSArray *visibleViews = typeToViewsDictionary[@(type)];
    for (UIView *subview in self.subviews) {
        subview.hidden = ![visibleViews containsObject:subview];
    }

    if (type == CompanyContentTypeLoading) {
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

- (void)setCapitalPercent:(NSNumber *)capitalPercent notes:(NSString *)notes {
    self.capitalProgressView.progress = capitalPercent;
    [self.capitalProgressView setNeedsLayout];

    self.capitalNotesLabel.text = notes;
    [self setNeedsLayout];
}

- (void)setWorkers:(NSNumber *)workers notes:(NSString *)notes {
    [self.workersCheckRow configure:workers notes:notes];
    [self.workersCheckRow sizeToFit];
    [self setNeedsLayout];
}

- (void)setRnd:(NSNumber *)rnd notes:(NSString *)notes {
    [self.rndCheckRow configure:rnd notes:notes];
    [self.rndCheckRow sizeToFit];
    [self setNeedsLayout];
}

- (void)setRegistered:(NSNumber *)registered notes:(NSString *)notes {
    [self.registeredCheckRow configure:registered notes:notes];
    [self.registeredCheckRow sizeToFit];
    [self setNeedsLayout];
}

- (void)setNotGlobal:(NSNumber *)notGlobal notes:(NSString *)notes {
    [self.notGlobalCheckRow configure:notGlobal notes:notes];
    [self.notGlobalCheckRow sizeToFit];
    [self setNeedsLayout];
}

- (void)setAltText:(NSString *)simpleText {
    self.altTextLabel.text = simpleText;
    [self setNeedsLayout];
}

- (void)setCardType:(CardType)type {
    if (type == CardTypeGrey) {
        self.mainProgressView.backgroundColor = [BPTheme strongBackgroundColor];
        self.capitalProgressView.fillColor = [BPTheme strongBackgroundColor];
        self.capitalProgressView.percentColor = [BPTheme clearColor];
    } else {
        self.mainProgressView.backgroundColor = [BPTheme lightBackgroundColor];
        self.capitalProgressView.fillColor = [BPTheme lightBackgroundColor];
        self.capitalProgressView.percentColor = [BPTheme defaultTextColor];
    }
}

@end