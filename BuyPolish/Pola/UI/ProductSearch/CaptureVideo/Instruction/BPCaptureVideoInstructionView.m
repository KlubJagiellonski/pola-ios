#import "BPCaptureVideoInstructionView.h"
#import "BPTheme.h"
#import "UIApplication+BPStatusBarHeight.h"

const int CAPTURE_TITLE_PADDING = 16;
const int CAPTURE_VERTICAL_MARGIN = 25;
const int CAPTURE_MAX_INSTRUCTION_LABEL_HEIGHT = 120;
const int CAPTURE_BUTTON_HEIGHT = 30;

@interface BPCaptureVideoInstructionView ()
@property(nonatomic, readonly) UILabel *titleLabel;
@property(nonatomic, readonly) UIButton *closeButton;
@property(nonatomic, readonly) UILabel *instructionLabel;

@property(nonatomic, readonly) UIButton *sendButton;


@end

@implementation BPCaptureVideoInstructionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [BPTheme mediumBackgroundColor];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [BPTheme titleFont];
        _titleLabel.textColor = [BPTheme defaultTextColor];
        _titleLabel.text = NSLocalizedString(@"Report", nil);
        [_titleLabel sizeToFit];
        [self addSubview:_titleLabel];
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.accessibilityLabel = NSLocalizedString(@"Accessibility.Close", nil);
        [_closeButton setImage:[[UIImage imageNamed:@"CloseIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _closeButton.tintColor = [BPTheme defaultTextColor];
        [_closeButton sizeToFit];
        [self addSubview:_closeButton];
        
        _instructionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _instructionLabel.font = [BPTheme normalFont];
        _instructionLabel.textColor = [BPTheme defaultTextColor];
        _instructionLabel.text = NSLocalizedString(@"Report help", nil);
        _instructionLabel.numberOfLines = 0;
        [_instructionLabel sizeToFit];
        [self addSubview:_instructionLabel];
        
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.titleLabel.font = [BPTheme buttonFont];
        [_sendButton setTitle:[NSLocalizedString(@"Send", nil) uppercaseString] forState:UIControlStateNormal];
        [_sendButton setBackgroundImage:[BPUtilities imageWithColor:[BPTheme actionColor]] forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_sendButton];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect = self.closeButton.frame;
    rect.origin.x = CGRectGetWidth(self.bounds) - CAPTURE_TITLE_PADDING - CGRectGetWidth(rect);
    rect.origin.y = [UIApplication statusBarHeight] + CAPTURE_TITLE_PADDING;
    self.closeButton.frame = rect;
    
    rect = self.titleLabel.frame;
    rect.origin.x = CAPTURE_TITLE_PADDING;
    rect.origin.y = (CGRectGetMinY(self.closeButton.frame) + CGRectGetHeight(self.closeButton.frame) / 2) - CGRectGetHeight(rect) / 2;
    self.titleLabel.frame = rect;
    
    rect = self.instructionLabel.frame;
    rect.size.width = CGRectGetWidth(self.bounds) - 2 * CAPTURE_TITLE_PADDING;
    rect.size.height = CAPTURE_MAX_INSTRUCTION_LABEL_HEIGHT;
    rect.origin.x = CAPTURE_TITLE_PADDING;
    rect.origin.y = CGRectGetMaxY(self.closeButton.frame) + CAPTURE_VERTICAL_MARGIN;
    self.instructionLabel.frame = rect;
    
    rect.size = CGSizeMake(CGRectGetWidth(self.bounds) - 2 * CAPTURE_TITLE_PADDING, CAPTURE_BUTTON_HEIGHT);
    rect.origin.x = CAPTURE_TITLE_PADDING;
    rect.origin.y = CGRectGetHeight(self.bounds) - CAPTURE_TITLE_PADDING - CGRectGetHeight(rect);
    self.sendButton.frame = rect;

}

@end
