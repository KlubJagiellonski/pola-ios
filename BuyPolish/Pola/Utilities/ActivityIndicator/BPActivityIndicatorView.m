#import "BPActivityIndicatorView.h"
#import "NSLayoutConstraint+BPAdditions.h"
#import "NSLayoutConstraint+PLVisualAttributeConstraints.h"

@interface BPActivityIndicatorView ()

@property(nonatomic, readonly) UIActivityIndicatorView *indicatorView;
@property(nonatomic, readonly) UILabel *loadingLabel;
@property(nonatomic, readonly) NSMutableArray *privateConstraints;

@end

@implementation BPActivityIndicatorView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.8f];

        _privateConstraints = [NSMutableArray array];

        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_indicatorView startAnimating];
        [self addSubview:_indicatorView];

        _loadingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _loadingLabel.textColor = [UIColor whiteColor];
        [self addSubview:_loadingLabel];

        [self setNeedsUpdateConstraints];
    }

    return self;
}

- (void)updateConstraints {
    self.indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    self.loadingLabel.translatesAutoresizingMaskIntoConstraints = NO;

    [self removeConstraints:self.privateConstraints];
    [self.privateConstraints removeAllObjects];

    NSDictionary *views = @{
        @"indicatorView" : self.indicatorView,
        @"loadingLabel" : self.loadingLabel,
        @"parentView" : self,
    };

    NSArray *formats = @[
        @"V:[indicatorView]-[loadingLabel]"
    ];

    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormats:formats options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views];
    [self.privateConstraints addObjectsFromArray:constraints];

    NSArray *attributedFormats = @[
        @"indicatorView.centerx == parentView.centerx",
        @"indicatorView.centery == parentView.centery",
        @"loadingLabel.centerx == parentView.centerx"
    ];
    NSArray *attributedConstraints = [NSLayoutConstraint attributeConstraintsWithVisualFormatsArray:attributedFormats views:views];
    [self.privateConstraints addObjectsFromArray:attributedConstraints];

    [self addConstraints:self.privateConstraints];
    [super updateConstraints];
}

- (NSString *)text {
    return self.loadingLabel.text;
}

- (void)setText:(NSString *)text {
    self.loadingLabel.text = text;
}

+ (BPActivityIndicatorView *)showInView:(UIView *)view withText:(NSString *)text {
    BPActivityIndicatorView *activityIndicatorView = [[BPActivityIndicatorView alloc] initWithFrame:CGRectZero];
    activityIndicatorView.frame = view.bounds;
    activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    activityIndicatorView.text = text;
    [view addSubview:activityIndicatorView];
    return activityIndicatorView;
}

+ (BOOL)existInView:(UIView *)view {
    __block BOOL exist = NO;
    [view.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        if ([subview isKindOfClass:[BPActivityIndicatorView class]]) {
            exist = YES;
            *stop = YES;
        }
    }];
    return exist;
}

+ (void)hideInView:(UIView *)view {
    [view.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        if ([subview isKindOfClass:[BPActivityIndicatorView class]]) {
            [subview removeFromSuperview];
        }
    }];
}

@end
