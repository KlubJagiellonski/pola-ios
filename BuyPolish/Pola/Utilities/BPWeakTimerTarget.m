#import "BPWeakTimerTarget.h"

@interface BPWeakTimerTarget ()
@property(nonatomic, weak) NSObject *target;
@property(nonatomic) SEL selector;
@end

@implementation BPWeakTimerTarget

- (instancetype)initWithTarget:(NSObject *)target selector:(SEL)selector {
    if (self) {
        _target = target;
        _selector = selector;
    }
    
    return self;
}

- (void)timerDidFire:(NSTimer *)timer {
    if(self.target) {
        IMP imp = [self.target methodForSelector:self.selector];
        void (*func)(id, SEL) = (void *)imp;
        func(self.target, self.selector);
    }
    else {
        [timer invalidate];
    }
}
@end
