#import <UIKit/UIKit.h>

@interface BPWeakTimerTarget : NSObject
- (instancetype)initWithTarget:(NSObject *)target selector:(SEL)selector;
- (void)timerDidFire:(NSTimer *)timer;
@end
