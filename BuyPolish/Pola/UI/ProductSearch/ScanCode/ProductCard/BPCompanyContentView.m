//
// Created by Paweł on 19/11/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "BPCompanyContentView.h"
#import "BPSecondaryProgressView.h"
#import "BPCheckRow.h"
#import "BPTheme.h"
#import "UILabel+BPAdditions.h"

int const CARD_CONTENT_VERTICAL_PADDING = 14;
int const CARD_CONTENT_ROW_MARGIN = 14;
int const CARD_CONTENT_NOTES_MARGIN = 4;

@interface BPCompanyContentView ()

@property(nonatomic, readonly) UILabel *capitalTitleLabel;
@property(nonatomic, readonly) BPSecondaryProgressView *capitalProgressView;
@property(nonatomic, readonly) UILabel *capitalNotesLabel;
@property(nonatomic, readonly) BPCheckRow *notGlobalCheckRow;
@property(nonatomic, readonly) BPCheckRow *registeredCheckRow;
@property(nonatomic, readonly) BPCheckRow *rndCheckRow;
@property(nonatomic, readonly) BPCheckRow *workersCheckRow;
@property(nonatomic, readonly) UILabel *altTextLabel;
@property(nonatomic, readonly) NSDictionary *typeToViewsDictionary;
@property(nonatomic, readonly) NSArray *allSubviews;

@end

@implementation BPCompanyContentView {
    NSDictionary *_typeToViewsDictionary;
    NSArray *_allSubviews;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.showsVerticalScrollIndicator = YES;

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
        _altTextLabel.numberOfLines = 0;
        [self addSubview:_altTextLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    const int widthWithPadding = (const int) (CGRectGetWidth(self.bounds) - 2 * self.padding);


    int bottom = 0;
    if (self.contentType == CompanyContentTypeDefault) {
        bottom = [self layoutDefaultSubviews:widthWithPadding];
    } else if (self.contentType == CompanyContentTypeAlt) {
        bottom = [self layoutAltSubviews:widthWithPadding];
    }

    self.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), bottom);
}

- (int)layoutDefaultSubviews:(const int)widthWithPadding {
    CGRect rect = self.capitalTitleLabel.frame;
    rect.origin.x = self.padding;
    rect.origin.y = CARD_CONTENT_VERTICAL_PADDING;
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
    rect.origin.y = CGRectGetMaxY(self.capitalNotesLabel.frame) + CARD_CONTENT_VERTICAL_PADDING;
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

    return (int) CGRectGetMaxY(self.notGlobalCheckRow.frame) + CARD_CONTENT_VERTICAL_PADDING;
}

- (int)layoutAltSubviews:(const int)widthWithPadding {
    CGRect rect = self.altTextLabel.frame;
    rect.size.width = widthWithPadding;
    rect.size.height = [self.altTextLabel heightForWidth:CGRectGetWidth(rect)];
    rect.origin.x = self.padding;
    rect.origin.y = CARD_CONTENT_VERTICAL_PADDING;
    self.altTextLabel.frame = rect;

    return (int) CGRectGetMaxY(self.altTextLabel.frame);
}

- (void)setContentType:(CompanyContentType)type {
    _contentType = type;

    NSArray *visibleViews = self.typeToViewsDictionary[@(type)];
    for (UIView *subview in self.allSubviews) { //you cannot user self.subviews because you will hide internal UIScrollView views
        subview.hidden = ![visibleViews containsObject:subview];
    }
}

- (NSDictionary *)typeToViewsDictionary {
    if (_typeToViewsDictionary == nil) {
        _typeToViewsDictionary = @{
            @(CompanyContentTypeDefault) : @[
                self.capitalTitleLabel,
                self.capitalProgressView,
                self.capitalNotesLabel,
                self.workersCheckRow,
                self.rndCheckRow,
                self.registeredCheckRow,
                self.notGlobalCheckRow
            ],
            @(CompanyContentTypeLoading) : @[
            ],
            @(CompanyContentTypeAlt) : @[
                self.altTextLabel
            ]
        };
    }
    return _typeToViewsDictionary;
}

- (NSArray *)allSubviews {
    if(_allSubviews == nil) {
        _allSubviews = @[
            self.capitalTitleLabel,
            self.capitalProgressView,
            self.capitalNotesLabel,
            self.notGlobalCheckRow,
            self.registeredCheckRow,
            self.rndCheckRow,
            self.workersCheckRow,
            self.altTextLabel,
        ];
    }
    return _allSubviews;
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
        self.capitalProgressView.fillColor = [BPTheme strongBackgroundColor];
        self.capitalProgressView.percentColor = [BPTheme clearColor];
    } else {
        self.capitalProgressView.fillColor = [BPTheme lightBackgroundColor];
        self.capitalProgressView.percentColor = [BPTheme defaultTextColor];
    }
}


@end