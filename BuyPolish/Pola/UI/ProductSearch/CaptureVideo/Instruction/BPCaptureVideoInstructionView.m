#import "BPCaptureVideoInstructionView.h"
#import "BPVideoPlayerView.h"
#import "UIView+SafeAreaInsets.h"
#import <Pola-Swift.h>

const int CAPTURE_TITLE_PADDING = 16;
const int CAPTURE_VERTICAL_MARGIN = 25;
const int CAPTURE_MAX_INSTRUCTION_LABEL_HEIGHT = 120;
const int CAPTURE_INSTRUCTION_VIDEO_PADDING = 10;
const int CAPTURE_BUTTON_HEIGHT = 30;

@interface BPCaptureVideoInstructionView ()
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UIButton *closeButton;
@property (nonatomic, readonly) UILabel *instructionLabel;
@property (nonatomic, readonly) BPVideoPlayerView *instructionVideoView;
@property (nonatomic, readonly) UIButton *captureButton;
@end

@implementation BPCaptureVideoInstructionView

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                  instruction:(NSString *)instruction
            captureButtonText:(NSString *)captureButtonText {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [BPTheme mediumBackgroundColor];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [BPTheme titleFont];
        _titleLabel.textColor = [BPTheme defaultTextColor];
        _titleLabel.text = title;
        [_titleLabel sizeToFit];
        [self addSubview:_titleLabel];

        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.accessibilityLabel = NSLocalizedString(@"Accessibility.Close", nil);
        [_closeButton
            setImage:[[UIImage imageNamed:@"CloseIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
            forState:UIControlStateNormal];
        _closeButton.tintColor = [BPTheme defaultTextColor];
        [_closeButton sizeToFit];
        [_closeButton addTarget:self action:@selector(closeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeButton];

        _instructionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _instructionLabel.font = [BPTheme normalFont];
        _instructionLabel.textColor = [BPTheme defaultTextColor];
        _instructionLabel.numberOfLines = 0;
        _instructionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _instructionLabel.text = instruction;
        [_instructionLabel sizeToFit];
        [self addSubview:_instructionLabel];

        _instructionVideoView = [[BPVideoPlayerView alloc] initWithFrame:CGRectZero];
        _instructionVideoView.layer.borderColor = UIColor.blackColor.CGColor;
        [self addSubview:_instructionVideoView];

        _captureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _captureButton.titleLabel.font = [BPTheme buttonFont];
        [_captureButton setBackgroundImage:[UIImage imageWithColor:[BPTheme actionColor]]
                                  forState:UIControlStateNormal];
        [_captureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_captureButton setTitle:captureButtonText forState:UIControlStateNormal];
        [_captureButton addTarget:self
                           action:@selector(captureButtonTapped:)
                 forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_captureButton];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect rect = self.closeButton.frame;
    rect.origin.x = CGRectGetWidth(self.bounds) - CAPTURE_TITLE_PADDING - CGRectGetWidth(rect);
    rect.origin.y = self.topSafeAreaInset + CAPTURE_TITLE_PADDING;
    self.closeButton.frame = rect;

    rect = self.titleLabel.frame;
    rect.origin.x = CAPTURE_TITLE_PADDING;
    rect.origin.y = (CGRectGetMinY(self.closeButton.frame) + CGRectGetHeight(self.closeButton.frame) / 2)
                    - CGRectGetHeight(rect) / 2;
    self.titleLabel.frame = rect;

    rect = self.instructionLabel.frame;
    rect.size.width = CGRectGetWidth(self.bounds) - 2 * CAPTURE_TITLE_PADDING;
    rect.size.height = [self.instructionLabel heightForWidth:rect.size.width];
    rect.origin.x = CAPTURE_TITLE_PADDING;
    rect.origin.y = CGRectGetMaxY(self.closeButton.frame) + CAPTURE_VERTICAL_MARGIN;
    self.instructionLabel.frame = rect;

    rect = self.captureButton.frame;
    rect.size = CGSizeMake(CGRectGetWidth(self.bounds) - 2 * CAPTURE_TITLE_PADDING, CAPTURE_BUTTON_HEIGHT);
    rect.origin.x = CAPTURE_TITLE_PADDING;
    rect.origin.y = CGRectGetHeight(self.bounds) - CAPTURE_TITLE_PADDING - CGRectGetHeight(rect);
    self.captureButton.frame = rect;

    rect = self.instructionVideoView.frame;
    rect.size.width = CGRectGetWidth(self.bounds) - 2 * CAPTURE_TITLE_PADDING;
    rect.size.height = CGRectGetMinY(self.captureButton.frame) - CGRectGetMaxY(self.instructionLabel.frame)
                       - (2 * CAPTURE_VERTICAL_MARGIN);
    rect.origin.x = CAPTURE_TITLE_PADDING;
    rect.origin.y = CGRectGetMaxY(self.instructionLabel.frame) + CAPTURE_VERTICAL_MARGIN;
    self.instructionVideoView.frame = rect;
}

- (void)closeButtonTapped:(UIButton *)sender {
    [self.delegate captureVideoInstructionViewDidTapClose:self];
}

- (void)captureButtonTapped:(UIButton *)sender {
    [self.delegate captureVideoInstructionViewDidTapCapture:self];
}

- (void)playVideoWithURL:(NSURL *)URL {
    [self.instructionVideoView playInLoopURL:URL];
}

- (void)stopVideo {
    [self.instructionVideoView stop];
}
@end
