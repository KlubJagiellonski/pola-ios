#import "BPKeyboardTextView.h"

static CGFloat const kCornerRadious = 2.0;
static CGFloat const kAnimationTime = 0.2;

@interface BPKeyboardTextView ()
@property (nonatomic) IBOutlet UIView *topView;
@property (nonatomic) IBOutlet UIView *errorView;
@property (nonatomic) IBOutlet UILabel *label;
@end

@implementation BPKeyboardTextView

#pragma mark - UIView

- (void)awakeFromNib {
    [super awakeFromNib];

    self.layer.cornerRadius = kCornerRadious;
    self.layer.masksToBounds = YES;

    self.topView.layer.cornerRadius = kCornerRadious;
    self.topView.layer.masksToBounds = YES;

    self.errorView.alpha = 0.0;
    self.label.text = @"";
}

#pragma mark - Public

- (void)insertValue:(NSInteger)value {
    NSString *currentString = self.label.text;
    NSString *newString = [NSString stringWithFormat:@"%@%ld", currentString, (long)value];
    self.label.text = newString;
}

- (void)showErrorMessage {
    [self setHiddenErrorView:NO];
}

- (void)hideErrorMessage {
    [self setHiddenErrorView:YES];
}

#pragma mark - Private

- (void)setHiddenErrorView:(BOOL)hidden {

    CGFloat newAlpha = hidden ? 0.0 : 1.0;
    if (newAlpha == self.errorView.alpha) {
        return;
    }

    [UIView animateWithDuration:kAnimationTime animations:^{
        self.errorView.alpha = newAlpha;
    }];
}

@end
