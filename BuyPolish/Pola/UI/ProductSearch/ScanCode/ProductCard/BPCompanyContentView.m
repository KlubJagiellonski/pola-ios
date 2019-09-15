#import "BPCompanyContentView.h"
#import "BPSecondaryProgressView.h"
#import <Pola-Swift.h>

CGFloat const CARD_CONTENT_VERTICAL_PADDING = 14;

@interface BPCompanyContentView ()

@property (nonatomic) BOOL friendButtonVisible;
@property (nonatomic, readonly) CompanyAltContentView *altView;
@property (nonatomic, readonly) CompanyContentDefaultView *companyView;

@end

@implementation BPCompanyContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.showsVerticalScrollIndicator = YES;

        _companyView = [[CompanyContentDefaultView alloc] initWithFrame:CGRectZero];
        [self addSubview:_companyView];

        _altView = [[CompanyAltContentView alloc] initWithFrame:CGRectZero];
        [self addSubview:_altView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    const CGFloat widthWithPadding = (CGRectGetWidth(self.bounds) - 2 * self.padding);

    UIView *viewToLayout;
    switch (self.contentType) {
    case CompanyContentTypeDefault:
        viewToLayout = self.companyView;
        break;

    case CompanyContentTypeAlt:
        viewToLayout = self.altView;

    default:
        break;
    }
    CGFloat bottom = [self layoutView:viewToLayout withWidth:widthWithPadding];
    self.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), bottom);
}

- (CGFloat)layoutView:(UIView *)view withWidth:(CGFloat)width {
    CGRect rect = view.frame;
    rect.origin.x = self.padding;
    rect.origin.y = CARD_CONTENT_VERTICAL_PADDING;
    rect.size = [view sizeThatFits:CGSizeMake(width, 0)];
    view.frame = rect;

    return CGRectGetMaxY(rect) + CARD_CONTENT_VERTICAL_PADDING;
}

- (void)setContentType:(CompanyContentType)type {
    _contentType = type;

    self.companyView.hidden = YES;
    self.altView.hidden = YES;
    switch (type) {
    case CompanyContentTypeDefault:
        self.companyView.hidden = NO;
        break;

    case CompanyContentTypeAlt:
        self.altView.hidden = NO;

    default:
        break;
    }
}

- (void)setCapitalPercent:(NSNumber *)capitalPercent {
    self.companyView.capitalProgressView.progress = capitalPercent;
    [self.companyView.capitalProgressView setNeedsLayout];
}

- (void)setWorkers:(NSNumber *)workers {
    [self.companyView.workersCheckRow setChecked:workers];
}

- (void)setRnd:(NSNumber *)rnd {
    [self.companyView.rndCheckRow setChecked:rnd];
}

- (void)setRegistered:(NSNumber *)registered {
    [self.companyView.registeredCheckRow setChecked:registered];
}

- (void)setNotGlobal:(NSNumber *)notGlobal {
    [self.companyView.notGlobalCheckRow setChecked:notGlobal];
}

- (void)setAltText:(NSString *)simpleText {
    self.altView.textLabel.text = simpleText;
    [self setNeedsLayout];
}

- (void)setDescr:(NSString *)description {
    self.companyView.descriptionLabel.text = description;
    [self setNeedsLayout];
}

- (void)setCardType:(CardType)type {
    if (type == CardTypeGrey) {
        self.companyView.capitalProgressView.fillColor = [BPTheme strongBackgroundColor];
        self.companyView.capitalProgressView.percentColor = [BPTheme clearColor];
    } else {
        self.companyView.capitalProgressView.fillColor = [BPTheme lightBackgroundColor];
        self.companyView.capitalProgressView.percentColor = [BPTheme defaultTextColor];
    }
}

- (void)setMarkAsFriend:(BOOL)isFriend {
    self.companyView.friendButton.hidden = !isFriend;
    [self setNeedsLayout];
}

- (void)addTargetOnFriendButton:(id)target action:(SEL)action {
    [self.companyView.friendButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
