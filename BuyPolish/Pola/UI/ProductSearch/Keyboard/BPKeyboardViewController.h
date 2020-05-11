#import <UIKit/UIKit.h>

@class BPKeyboardViewController;

@protocol BPKeyboardViewControllerDelegate <NSObject>
- (void)keyboardViewController:(BPKeyboardViewController *)viewController didConfirmWithCode:(NSString *)code;
@end

@interface BPKeyboardViewController : UIViewController

@property (nonatomic, weak) id<BPKeyboardViewControllerDelegate> delegate;

- (BOOL)isPresented;

@end
