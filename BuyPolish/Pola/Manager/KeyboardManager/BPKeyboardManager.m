#import "BPKeyboardManager.h"

@implementation BPKeyboardManager

- (void)turnOn {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];

    // get the size of the keyboard
    NSNumber *animationCurve = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    NSNumber *animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey];

    [self.delegate keyboardWillHideWithAnimationDuration:animationDuration.doubleValue
                                          animationCurve:(NSUInteger)animationCurve.integerValue];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];

    // get the size of the keyboard
    CGSize keyboardSize = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSNumber *animationCurve = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    NSNumber *animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey];

    [self.delegate keyboardWillShowWithHeight:keyboardSize.height
                            animationDuration:animationDuration.doubleValue
                               animationCurve:(NSUInteger)animationCurve.integerValue];
}

- (void)turnOff {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
