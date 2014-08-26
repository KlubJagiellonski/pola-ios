#import "BPActivityIndicatorView.h"
#import "NSLayoutConstraint+BPAdditions.h"


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

        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_indicatorView startAnimating];
        [self addSubview:_indicatorView];
        
        _loadingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_loadingLabel];
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
    };

    NSArray *formats = @[
            @"H:|-(>0)-[indicatorView]-(>0)-|",
            @"V:|-(>0)-[indicatorView]-(>0)-|",
            @"H:|-(>0)-[loadingLabel]-(>0)-|",
            @"V:[indicatorView]-[loadingLabel]"
    ];

    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormats:formats options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views];
    [self.privateConstraints addObjectsFromArray:constraints];

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

+ (void)hideInView:(UIView *)view {
    [view.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        if([subview isKindOfClass:[BPActivityIndicatorView class]]) {
            [subview removeFromSuperview];
        }
    }];
}

@end