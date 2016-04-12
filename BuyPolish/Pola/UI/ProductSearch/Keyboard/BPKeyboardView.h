#import <UIKit/UIKit.h>

@class BPKeyboardView;

@protocol BPKeyboardViewDelegate

- (void)keyboardView:(BPKeyboardView *)keyboardView tappedNumber:(NSInteger) number;
- (void)confirmButtonTappedInKeyboardView:(BPKeyboardView *)keyboardView;

@end

@interface BPKeyboardView : UIView

@property (weak, nonatomic) id <BPKeyboardViewDelegate> delegate;

@end
