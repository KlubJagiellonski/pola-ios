#import <UIKit/UIKit.h>

@interface BPKeyboardTextView : UIView

@property(nonatomic, readonly) NSString* code;

- (void)insertValue:(NSInteger)value;

- (void)showErrorMessage;
- (void)hideErrorMessage;

@end
