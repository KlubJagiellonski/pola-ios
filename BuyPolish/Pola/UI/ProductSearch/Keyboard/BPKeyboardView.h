#import <UIKit/UIKit.h>

@class BPKeyboardView;

@protocol BPKeyboardViewDelegate

- (void)keyboardView:(BPKeyboardView *)keyboardView didConfirmWithCode:(NSString *)code;
- (void)keyboardView:(BPKeyboardView *)keyboardView didChangedCode:(NSString *)code;

@end

@interface BPKeyboardView : UIView

@property (weak, nonatomic) id <BPKeyboardViewDelegate> delegate;

- (void)showErrorMessage;
- (void)hideErrorMessage;

@end
