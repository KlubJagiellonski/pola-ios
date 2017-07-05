#import "BPCaptureVideoInstructionView.h"
#import "BPTheme.h"

@interface BPCaptureVideoInstructionView ()

// properties
@end

@implementation BPCaptureVideoInstructionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [BPTheme mediumBackgroundColor];
        
        _testLabel = [[UILabel alloc] init];
        [self addSubview:_testLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect = self.testLabel.frame;
    rect.origin = CGPointZero;
    self.testLabel.frame = rect;
    [self.testLabel setText:@"Naucz Polę"];
}

@end
