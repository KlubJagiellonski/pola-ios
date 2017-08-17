#import "BPCaptureVideoView.h"
#import "BPTheme.h"
#import "UIApplication+BPStatusBarHeight.h"
#import "UILabel+BPAdditions.h"

const int CAPTURE_PADDING = 16;
const int CAPTURE_START_BUTTON_HEIGHT = 30;
const int DIM_MARGIN = 30;

@interface BPCaptureVideoView ()
@property(nonatomic, readonly) CAGradientLayer *dimLayer;
@end

@implementation BPCaptureVideoView

- (instancetype)initWithFrame:(CGRect)frame productLabelText:(NSString *)productLabelText initialTimerSeconds:(int)initialTimerSeconds {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _dimLayer = [CAGradientLayer layer];
        _dimLayer.colors = @[(id)[UIColor blackColor].CGColor, (id)[UIColor clearColor].CGColor];
        [self.layer insertSublayer:_dimLayer atIndex:0];
        
        _productLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _productLabel.font = [BPTheme titleFont];
        _productLabel.textColor = [UIColor whiteColor];
        _productLabel.text = productLabelText;
        _productLabel.numberOfLines = 0;
        _productLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [_productLabel sizeToFit];
        [self addSubview:_productLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = [BPTheme titleFont];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.text = [self timeLabelStringWithSeconds:initialTimerSeconds];
        [_timeLabel sizeToFit];
        [_timeLabel setHidden:YES];
        [self addSubview:_timeLabel];
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.accessibilityLabel = NSLocalizedString(@"Accessibility.Close", nil);
        [_closeButton setImage:[[UIImage imageNamed:@"CloseIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _closeButton.tintColor = [UIColor whiteColor];
        [_closeButton sizeToFit];
        [_closeButton addTarget:self action:@selector(closeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeButton];
        
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _startButton.titleLabel.font = [BPTheme buttonFont];
        [_startButton setBackgroundImage:[BPUtilities imageWithColor:[BPTheme actionColor]] forState:UIControlStateNormal];
        [_startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_startButton setTitle:NSLocalizedString(@"CaptureVideo.Start", nil) forState:UIControlStateNormal];
        [_startButton addTarget:self action:@selector(startButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_startButton];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect = self.closeButton.frame;
    rect.origin.x = CGRectGetWidth(self.bounds) - CAPTURE_PADDING - CGRectGetWidth(rect);
    rect.origin.y = [UIApplication statusBarHeight] + CAPTURE_PADDING;
    self.closeButton.frame = rect;
    
    rect = self.productLabel.frame;
    rect.origin.x = CAPTURE_PADDING;
    rect.origin.y = [UIApplication statusBarHeight] + CAPTURE_PADDING;
    rect.size.width = CGRectGetWidth(self.bounds) - 3*CAPTURE_PADDING - CGRectGetWidth(self.closeButton.frame);
    rect.size.height = [self.productLabel heightForWidth:rect.size.width];
    self.productLabel.frame = rect;
    
    CGFloat dimHeight = CGRectGetMaxY(self.productLabel.frame) - self.bounds.origin.x + DIM_MARGIN;
    self.dimLayer.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, dimHeight);
    
    self.timeLabel.center = CGPointMake(self.bounds.size.width/2, CGRectGetMidY(self.closeButton.frame));
    
    rect = self.startButton.frame;
    rect.size = CGSizeMake(CGRectGetWidth(self.bounds) - 2 * CAPTURE_PADDING, CAPTURE_START_BUTTON_HEIGHT);
    rect.origin.x = CAPTURE_PADDING;
    rect.origin.y = CGRectGetHeight(self.bounds) - CAPTURE_PADDING - CGRectGetHeight(rect);
    self.startButton.frame = rect;
}

- (void)closeButtonTapped:(UIButton*)sender {
    [self.delegate captureVideoViewDidTapClose:self];
}

- (void)startButtonTapped:(UIButton*)sender {
    [self.delegate captureVideoViewDidTapStart:self];
}

- (void)setVideoLayer:(AVCaptureVideoPreviewLayer *)videoLayer {
    if (_videoLayer == videoLayer) {
        return;
    }
    
    [_videoLayer removeFromSuperlayer];
    _videoLayer = videoLayer;
    [videoLayer setFrame:self.layer.bounds];
    [self.layer insertSublayer:videoLayer atIndex:0];
}

- (void)updateProductAndTimeLabelsWithCapturing:(BOOL)capturing {
    [self.productLabel setHidden:capturing];
    [self.timeLabel setHidden:!capturing];
}

- (void)setTimeLabelSec:(int)seconds {
    self.timeLabel.text = [self timeLabelStringWithSeconds:seconds];
}

- (NSString*)timeLabelStringWithSeconds:(int)seconds {
    return [NSString stringWithFormat:@"%d %@", seconds, NSLocalizedString(@"CaptureVideo.Timer.Seconds", nil)];
}
@end
