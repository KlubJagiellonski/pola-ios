#import "BPKeyboardTextView.h"
#import "BPTheme.h"
#import <AudioToolbox/AudioToolbox.h>

static CGFloat const kCornerRadious = 2.0;
static CGFloat const kAnimationTime = 0.2;

@interface BPKeyboardTextView ()
@property (nonatomic, strong, readonly) UIView *topView;
@property (nonatomic, strong, readonly) UILabel *codeLabel;
@property (nonatomic, strong, readonly) UIButton *removeButton;
@property (nonatomic, strong, readonly) UIView *errorView;
@property (nonatomic, strong, readonly) UILabel *errorLabel;
@end

@implementation BPKeyboardTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = kCornerRadious;
        self.layer.masksToBounds = YES;
        
        _topView = [UIView new];
        self.topView.backgroundColor = [BPTheme clearColor];
        self.topView.layer.cornerRadius = kCornerRadious;
        self.topView.layer.masksToBounds = YES;
        [self addSubview:self.topView];
        
        _codeLabel = [UILabel new];
        self.codeLabel.font = [BPTheme titleFont];
        self.codeLabel.textColor = [BPTheme defaultTextColor];
        self.codeLabel.text = @"1";
        [self.codeLabel sizeToFit];
        self.codeLabel.text = @"";
        [self.topView addSubview:self.codeLabel];
        
        _removeButton = [UIButton new];
        _removeButton.accessibilityLabel = NSLocalizedString(@"Accessibility.Keyboard.Delete", nil);
        [self.removeButton addTarget:self action:@selector(didTapRemoveButton) forControlEvents:UIControlEventTouchUpInside];
        [self.removeButton setImage:[UIImage imageNamed:@"kb_delete"] forState:UIControlStateNormal];
        [self.removeButton sizeToFit];
        [self.topView addSubview:self.removeButton];
        
        _errorView = [UIView new];
        self.errorView.alpha = 0.0;
        self.errorView.backgroundColor = [BPTheme lightBackgroundColor];
        [self addSubview:self.errorView];
        
        _errorLabel = [UILabel new];
        self.errorLabel.text = NSLocalizedString(@"Write code error", @"");
        self.errorLabel.font = [BPTheme titleFont];
        self.errorLabel.textColor = [BPTheme defaultTextColor];
        [self.errorLabel sizeToFit];
        [self.errorView addSubview:self.errorLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    
    CGRect rect = self.topView.frame;
    rect.origin = CGPointMake(0, 0);
    rect.size = CGSizeMake(self.bounds.size.width, 38);
    self.topView.frame = rect;
    
    rect = self.removeButton.frame;
    rect.origin = CGPointMake(width - 6 - CGRectGetWidth(self.removeButton.bounds) - 6, 0);
    rect.size = CGSizeMake(CGRectGetWidth(self.removeButton.bounds) + 12, CGRectGetHeight(self.topView.bounds));
    self.removeButton.frame = rect;
    
    rect = self.codeLabel.frame;
    rect.origin = CGPointMake(8, self.topView.bounds.size.height / 2 - rect.size.height / 2);
    rect.size = CGSizeMake(CGRectGetMinX(self.removeButton.frame) - 11, rect.size.height);
    self.codeLabel.frame = rect;
    
    rect = self.errorView.frame;
    rect.origin = CGPointMake(0, CGRectGetMaxY(self.topView.frame));
    rect.size = CGSizeMake(width, 27);
    self.errorView.frame = rect;
    
    rect = self.errorLabel.frame;
    rect.origin = CGPointMake(CGRectGetWidth(self.errorView.bounds) / 2 -  rect.size.width / 2, CGRectGetHeight(self.errorView.bounds) / 2 - rect.size.height / 2);
    self.errorLabel.frame = rect;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(size.width, 27 + 38);
}

#pragma mark - Public

- (void)insertValue:(NSInteger)value {
    if (self.codeLabel.text.length >= 13) {
        return;
    }
    NSString *currentString = self.codeLabel.text;
    NSString *newString = [NSString stringWithFormat:@"%@%ld", currentString, (long)value];
    self.codeLabel.text = newString;
}

- (void)showErrorMessage {
    [self setHiddenErrorView:NO];
}

- (void)hideErrorMessage {
    [self setHiddenErrorView:YES];
}

- (NSString *)code {
    return self.codeLabel.text;
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

- (void)didTapRemoveButton {
    AudioServicesPlaySystemSound(1104);
    if (self.codeLabel.text.length == 0) {
        return;
    }
    self.codeLabel.text = [self.codeLabel.text substringToIndex:[self.codeLabel.text length] - 1];
}

@end
