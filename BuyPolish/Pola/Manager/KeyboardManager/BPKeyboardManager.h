#import <Foundation/Foundation.h>


@protocol BPKeyboardManagerDelegate <NSObject>

- (void)keyboardWillShowWithHeight:(CGFloat)height animationDuration:(double)animationDuration animationCurve:(NSUInteger)animationCurve;

- (void)keyboardWillHideWithAnimationDuration:(double)animationDuration animationCurve:(NSUInteger)animationCurve;

@end


@interface BPKeyboardManager : NSObject

@property(nonatomic, weak) id <BPKeyboardManagerDelegate> delegate;

- (void)turnOn;

- (void)turnOff;

@end