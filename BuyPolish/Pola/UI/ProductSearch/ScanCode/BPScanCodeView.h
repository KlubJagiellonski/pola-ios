#import <Foundation/Foundation.h>

@class BPStackView;

typedef NS_ENUM(NSInteger, BPScanCodeViewLabelMode) {
    BPScanCodeViewLabelModeScan,
    BPScanCodeViewLabelModeKeyboard
};

@interface BPScanCodeView : UIView

@property(nonatomic, readonly) BPStackView *stackView;

@property(nonatomic) AVCaptureVideoPreviewLayer *videoLayer;

@property(nonatomic, readonly) UILabel *infoTextLabel;
@property(nonatomic, readonly) UIView *rectangleView;
@property(nonatomic, readonly) UIImageView *logoImageView;
@property(nonatomic, readonly) UIButton *menuButton;
@property(nonatomic, readonly) UIButton *flashButton;
@property(nonatomic, readonly) UIButton *keyboardButton;
@property(nonatomic, readonly) UIButton *teachButton;

@property(nonatomic, getter=isFlashlightButtonHidden) BOOL flashlightButtonHidden;
@property(nonatomic, readonly) CGFloat cardsHeight;

- (void)setInfoTextVisible:(BOOL)visible;
- (void)configureInfoLabelForMode:(BPScanCodeViewLabelMode)mode;

- (void)setButtonsVisible:(BOOL)visible animation:(BOOL)animation;
- (void)updateTeachButtonWithVisible:(BOOL)visible title:(NSString *)title cardsHeight:(CGFloat)cardsHeight;

- (void)updateImageRecognitionLabelsWithNames:(NSArray<NSString *> *)names predictionValues:(NSArray<NSNumber *> *)values;

@end
