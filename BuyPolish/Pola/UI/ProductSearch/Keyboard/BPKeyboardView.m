#import "BPKeyboardView.h"
#import "BPTheme.h"
#import "BPKeyboardTextView.h"
#import "BPExtendedButton.h"

@interface BPKeyboardView ()
@property(nonatomic, strong, readonly) UIView *contentView;
@property(nonatomic, strong, readonly) BPKeyboardTextView *textView;
@property(nonatomic, strong, readonly) NSMutableArray<UIButton *> *buttons;
@property(nonatomic, strong, readonly) UIButton *okButton;
@end

@implementation BPKeyboardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _buttons = [NSMutableArray array];
        
        _contentView = [UIView new];
        [self addSubview:self.contentView];
        
        _textView = [BPKeyboardTextView new];
        [self.textView sizeToFit];
        [self.contentView addSubview:self.textView];
        
        for (int i = 1; i <= 10; i++ ) {
            int index = i == 10 ? 0 : i;
            
            NSString *imageName = [NSString stringWithFormat:@"kb_%d", index];
            NSString *highlightedImageName = [NSString stringWithFormat:@"kb_%d_highlighted", index];
            
            BPExtendedButton *button = [BPExtendedButton new];
            button.extendedTouchSize = 4;
            button.tag = index;
            [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateHighlighted];
            [button sizeToFit];
            [button addTarget:self action:@selector(numberButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttons addObject:button];
            [self.contentView addSubview:button];
        }
        
        _okButton = [UIButton new];
        [self.okButton setImage:[UIImage imageNamed:@"kb_ok"] forState:UIControlStateNormal];
        [self.okButton setImage:[UIImage imageNamed:@"kb_ok_highlighted"] forState:UIControlStateNormal];
        [self.okButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.okButton sizeToFit];
        [self.contentView addSubview:self.okButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat buttonMargin = 18;
    CGFloat buttonWidth = self.buttons[0].bounds.size.width;
    CGFloat buttonHeight = self.buttons[0].bounds.size.height;
    int buttonsInRow = 3;
    int buttonRows = 4;
    CGFloat verticalMargin = 16;
    
    CGFloat contentWidth = buttonWidth * buttonsInRow + buttonMargin * (buttonsInRow - 1);
    CGFloat contentHeight = CGRectGetHeight(self.textView.frame) + verticalMargin + buttonHeight * buttonRows + buttonMargin * (buttonRows - 1);
    
    CGSize contentViewSize = CGSizeMake(contentWidth, contentHeight);
    
    CGRect rect = self.contentView.frame;
    rect.origin = CGPointMake(CGRectGetWidth(self.bounds) / 2 - contentWidth / 2, CGRectGetHeight(self.bounds) / 2 - contentHeight / 2);
    rect.size = contentViewSize;
    self.contentView.frame = rect;
    
    rect = self.textView.frame;
    rect.origin = CGPointMake(0, 0);
    rect.size = CGSizeMake(contentWidth, rect.size.height);
    self.textView.frame = rect;
    
    CGPoint buttonPosition = CGPointMake(0, CGRectGetMaxY(self.textView.frame) + verticalMargin);
    
    int column = 0;
    for (UIButton* button in self.buttons) {
        button.frame = CGRectMake(buttonPosition.x, buttonPosition.y, CGRectGetWidth(button.bounds), CGRectGetHeight(button.bounds));
        column += 1;
        if (column == buttonsInRow) {
            buttonPosition.x = 0;
            buttonPosition.y += CGRectGetHeight(button.frame) + buttonMargin;
            column = 0;
        } else {
            buttonPosition.x += CGRectGetWidth(button.frame) + buttonMargin;
        }
    }
    
    rect = self.okButton.frame;
    rect.origin = CGPointMake(contentWidth - CGRectGetWidth(rect), contentHeight - CGRectGetHeight(rect));
    self.okButton.frame = rect;
}

- (void)numberButtonAction:(UIButton *)sender {
    NSInteger number = sender.tag;
    [self.textView insertValue:number];
    [self.delegate keyboardView:self didChangedCode:self.textView.code];
}

- (void)confirmButtonAction:(UIButton *)sender {
    [self.delegate keyboardView:self didConfirmWithCode:self.textView.code];
}

- (void)showErrorMessage {
    [self.textView showErrorMessage];
}

- (void)hideErrorMessage {
    [self.textView hideErrorMessage];
}

@end
