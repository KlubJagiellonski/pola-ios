#import "BPCompanyContentView.h"
#import "BPSecondaryProgressView.h"
#import "BPTheme.h"
#import "UILabel+BPAdditions.h"
#import <Pola-Swift.h>

int const CARD_CONTENT_VERTICAL_PADDING = 14;
int const CARD_CONTENT_ROW_MARGIN = 14;

@interface BPCompanyContentView ()

@property (nonatomic, readonly) UILabel *capitalTitleLabel;
@property (nonatomic, readonly) BPSecondaryProgressView *capitalProgressView;
@property (nonatomic, readonly) BPCheckRow *notGlobalCheckRow;
@property (nonatomic, readonly) BPCheckRow *registeredCheckRow;
@property (nonatomic, readonly) BPCheckRow *rndCheckRow;
@property (nonatomic, readonly) BPCheckRow *workersCheckRow;
@property (nonatomic) BOOL friendButtonVisible;
@property (nonatomic, readonly) UIButton *friendButton;
@property (nonatomic, readonly) UILabel *descriptionLabel;
@property (nonatomic, readonly) UILabel *altTextLabel;
@property (copy, nonatomic, readonly) NSDictionary *typeToViewsDictionary;
@property (copy, nonatomic, readonly) NSArray *allSubviews;

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
        _capitalTitleLabel.text = NSLocalizedString(@"percent of polish holders", nil);
        [_capitalTitleLabel sizeToFit];
        [self addSubview:_capitalTitleLabel];

        _capitalProgressView = [[BPSecondaryProgressView alloc] initWithFrame:CGRectZero];
        [_capitalProgressView sizeToFit];
        [self addSubview:_capitalProgressView];

        _notGlobalCheckRow = [[BPCheckRow alloc] initWithFrame:CGRectZero];
        [_notGlobalCheckRow setText:NSLocalizedString(@"not part of global company", nil)];
        [_notGlobalCheckRow sizeToFit];
        [self addSubview:_notGlobalCheckRow];

        _registeredCheckRow = [[BPCheckRow alloc] initWithFrame:CGRectZero];
        [_registeredCheckRow setText:NSLocalizedString(@"is registered in Poland", nil)];
        [_registeredCheckRow sizeToFit];
        [self addSubview:_registeredCheckRow];

        _rndCheckRow = [[BPCheckRow alloc] initWithFrame:CGRectZero];
        [_rndCheckRow setText:NSLocalizedString(@"created rich salary work places", nil)];
        [_rndCheckRow sizeToFit];
        [self addSubview:_rndCheckRow];

        _workersCheckRow = [[BPCheckRow alloc] initWithFrame:CGRectZero];
        [_workersCheckRow setText:NSLocalizedString(@"producing in PL", nil)];
        [_workersCheckRow sizeToFit];
        [self addSubview:_workersCheckRow];

        _friendButton = [[UIButton alloc] init];
        UIImage *heartImage = [UIImage imageNamed:@"HeartFilled"];
        [_friendButton setImage:heartImage forState:UIControlStateNormal];
        _friendButton.tintColor = [BPTheme actionColor];
        [_friendButton setTitle:NSLocalizedString(@"This is Pola's friend", nil) forState:UIControlStateNormal];
        [_friendButton setTitleColor:[BPTheme actionColor] forState:UIControlStateNormal];
        _friendButton.titleLabel.font = [BPTheme normalFont];
        CGFloat buttontitleHorizontalMargin = 7;
        _friendButton.titleEdgeInsets = UIEdgeInsetsMake(0, buttontitleHorizontalMargin, 0, 0);
        _friendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _friendButton.adjustsImageWhenHighlighted = NO;
        _friendButton.hidden = YES;
        [self addSubview:_friendButton];

        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _descriptionLabel.font = [BPTheme normalFont];
        _descriptionLabel.textColor = [BPTheme defaultTextColor];
        _descriptionLabel.numberOfLines = 0;
        [self addSubview:_descriptionLabel];

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

    const int widthWithPadding = (const int)(CGRectGetWidth(self.bounds) - 2 * self.padding);

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
    CGFloat lastY = CGRectGetMaxY(rect);

    rect = self.capitalProgressView.frame;
    rect.size.width = widthWithPadding;
    rect.origin.x = self.padding;
    rect.origin.y = lastY + self.padding;
    self.capitalProgressView.frame = rect;
    lastY = CGRectGetMaxY(rect);

    rect = self.workersCheckRow.frame;
    rect.size = [self.workersCheckRow sizeThatFits:CGSizeMake(widthWithPadding, 0)];
    rect.origin.x = self.padding;
    rect.origin.y = lastY + CARD_CONTENT_VERTICAL_PADDING;
    self.workersCheckRow.frame = rect;
    lastY = CGRectGetMaxY(rect);

    rect = self.rndCheckRow.frame;
    rect.size = [self.rndCheckRow sizeThatFits:CGSizeMake(widthWithPadding, 0)];
    rect.origin.x = self.padding;
    rect.origin.y = lastY + CARD_CONTENT_ROW_MARGIN;
    self.rndCheckRow.frame = rect;
    lastY = CGRectGetMaxY(rect);

    rect = self.registeredCheckRow.frame;
    rect.size = [self.registeredCheckRow sizeThatFits:CGSizeMake(widthWithPadding, 0)];
    rect.origin.x = self.padding;
    rect.origin.y = lastY + CARD_CONTENT_ROW_MARGIN;
    self.registeredCheckRow.frame = rect;
    lastY = CGRectGetMaxY(rect);

    rect = self.notGlobalCheckRow.frame;
    rect.size = [self.notGlobalCheckRow sizeThatFits:CGSizeMake(widthWithPadding, 0)];
    rect.origin.x = self.padding;
    rect.origin.y = lastY + CARD_CONTENT_ROW_MARGIN;
    self.notGlobalCheckRow.frame = rect;
    lastY = CGRectGetMaxY(rect);

    if (self.friendButtonVisible) {
        rect = self.friendButton.frame;
        rect.size.width = widthWithPadding;
        rect.size.height = [self.friendButton sizeThatFits:CGSizeMake(widthWithPadding, 0)].height;
        rect.origin.x = self.padding;
        rect.origin.y = lastY + CARD_CONTENT_VERTICAL_PADDING;
        self.friendButton.frame = rect;
        lastY = CGRectGetMaxY(rect);
    }

    if (self.descriptionLabel.text.length) {
        rect = self.descriptionLabel.frame;
        rect.size.width = widthWithPadding;
        rect.size.height = [self.descriptionLabel heightForWidth:CGRectGetWidth(rect)];
        rect.origin.x = self.padding;
        rect.origin.y = lastY + CARD_CONTENT_VERTICAL_PADDING;
        self.descriptionLabel.frame = rect;
        lastY = CGRectGetMaxY(rect);
    }

    return (int)lastY + CARD_CONTENT_VERTICAL_PADDING;
}

- (int)layoutAltSubviews:(const int)widthWithPadding {
    CGRect rect = self.altTextLabel.frame;
    rect.size.width = widthWithPadding;
    rect.size.height = [self.altTextLabel heightForWidth:CGRectGetWidth(rect)];
    rect.origin.x = self.padding;
    rect.origin.y = CARD_CONTENT_VERTICAL_PADDING;
    self.altTextLabel.frame = rect;

    return (int)CGRectGetMaxY(self.altTextLabel.frame);
}

- (void)setContentType:(CompanyContentType)type {
    _contentType = type;

    NSArray *visibleViews = self.typeToViewsDictionary[@(type)];
    //you cannot user self.subviews because you will hide internal UIScrollView views
    for (UIView *subview in self.allSubviews) {
        subview.hidden = ![visibleViews containsObject:subview];
    }
}

- (NSDictionary *)typeToViewsDictionary {
    if (_typeToViewsDictionary == nil) {
        _typeToViewsDictionary = @{
            @(CompanyContentTypeDefault): @[
                self.capitalTitleLabel,
                self.capitalProgressView,
                self.workersCheckRow,
                self.rndCheckRow,
                self.registeredCheckRow,
                self.notGlobalCheckRow,
                self.descriptionLabel
            ],
            @(CompanyContentTypeLoading): @[],
            @(CompanyContentTypeAlt): @[self.altTextLabel]
        };
    }
    return _typeToViewsDictionary;
}

- (NSArray *)allSubviews {
    if (_allSubviews == nil) {
        _allSubviews = @[
            self.capitalTitleLabel,
            self.capitalProgressView,
            self.descriptionLabel,
            self.notGlobalCheckRow,
            self.registeredCheckRow,
            self.rndCheckRow,
            self.workersCheckRow,
            self.altTextLabel,
        ];
    }
    return _allSubviews;
}

- (void)setCapitalPercent:(NSNumber *)capitalPercent {
    self.capitalProgressView.progress = capitalPercent;
    [self.capitalProgressView setNeedsLayout];
}

- (void)setWorkers:(NSNumber *)workers {
    [self.workersCheckRow setChecked:workers];
}

- (void)setRnd:(NSNumber *)rnd {
    [self.rndCheckRow setChecked:rnd];
}

- (void)setRegistered:(NSNumber *)registered {
    [self.registeredCheckRow setChecked:registered];
}

- (void)setNotGlobal:(NSNumber *)notGlobal {
    [self.notGlobalCheckRow setChecked:notGlobal];
}

- (void)setAltText:(NSString *)simpleText {
    self.altTextLabel.text = simpleText;
    [self setNeedsLayout];
}

- (void)setDescr:(NSString *)description {
    self.descriptionLabel.text = description;
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

- (void)setMarkAsFriend:(BOOL)isFriend {
    self.friendButtonVisible = isFriend;
    self.friendButton.hidden = !isFriend;
    [self setNeedsLayout];
}

- (void)addTargetOnFriendButton:(id)target action:(SEL)action {
    [self.friendButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
