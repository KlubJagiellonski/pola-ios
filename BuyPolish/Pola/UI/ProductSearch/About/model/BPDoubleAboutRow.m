#import "BPDoubleAboutRow.h"

@implementation BPDoubleAboutRow

- (instancetype)initWithTitle:(NSString *)title
                       action:(SEL)action
                  secondTitle:(NSString *)secondTitle
                 secondAction:(SEL)secondAction
                       target:(id)target {
    self = [super initWithTitle:title action:action];
    if (self) {
        _secondTitle = secondTitle;
        _secondAction = secondAction;
        _target = target;
        self.style = BPAboutRowStyleDouble;
    }
    return self;
}

+ (instancetype)rowWithTitle:(NSString *)title
                      action:(SEL)action
                 secondTitle:(NSString *)secondTitle
                secondAction:(SEL)secondAction
                      target:(id)target {
    return [[BPDoubleAboutRow alloc] initWithTitle:title
                                            action:action
                                       secondTitle:secondTitle
                                      secondAction:secondAction
                                            target:target];
}

@end
