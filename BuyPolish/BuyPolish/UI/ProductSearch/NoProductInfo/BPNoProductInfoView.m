#import "BPNoProductInfoView.h"
#import "BNRDynamicTypeManager.h"
#import "NSLayoutConstraint+PLVisualAttributeConstraints.h"
#import "NSLayoutConstraint+BPAdditions.h"


@interface BPNoProductInfoView ()

@property(nonatomic, readonly) UILabel *noProductInfoLabel;
@property(nonatomic, readonly) NSMutableArray *privateConstraints;

@end


@implementation BPNoProductInfoView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        _privateConstraints = [NSMutableArray array];
        
        NSString *fontStyle = UIFontTextStyleBody;

        _noProductInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _noProductInfoLabel.text = NSLocalizedString(@"Sorry :(\nWe are working as hard as we can to gather info about all of the products, but you can still sometimes found such view.", @"Sorry :(\nWe are working as hard as we can to gather info about all of the products, but you can still sometimes found such view.");
        _noProductInfoLabel.font = [UIFont preferredFontForTextStyle:fontStyle];
        _noProductInfoLabel.textColor = [UIColor blackColor];
        _noProductInfoLabel.textAlignment = NSTextAlignmentCenter;
        _noProductInfoLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _noProductInfoLabel.numberOfLines = 0;
        [[BNRDynamicTypeManager sharedInstance] watchLabel:_noProductInfoLabel textStyle:fontStyle];
        [self addSubview:_noProductInfoLabel];
        
        [self setNeedsUpdateConstraints];
    }

    return self;
}

- (void)updateConstraints {
    self.noProductInfoLabel.translatesAutoresizingMaskIntoConstraints = NO;

    [self removeConstraints:self.privateConstraints];
    [self.privateConstraints removeAllObjects];

    NSDictionary *views = @{
        @"noProductInfoLabel" : self.noProductInfoLabel,
        @"parentView" : self
    };

    NSArray *formats = @[
        @"H:|-[noProductInfoLabel]-|"
    ];
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormats:formats views:views];
    [self.privateConstraints addObjectsFromArray:constraints];

    NSArray *attributedFormats = @[
        @"noProductInfoLabel.centery == parentView.centery"
    ];
    NSArray *attributedConstraints = [NSLayoutConstraint attributeConstraintsWithVisualFormatsArray:attributedFormats views:views];
    [self.privateConstraints addObjectsFromArray:attributedConstraints];

    [self addConstraints:self.privateConstraints];
    [super updateConstraints];
}

@end