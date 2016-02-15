#import <Foundation/Foundation.h>

@class BPImageContainerView;


@interface BPReportProblemView : UIView


@property(nonatomic, readonly) BPImageContainerView *imageContainerView;
@property(nonatomic, readonly) UIButton *closeButton;
@property(nonatomic, readonly) UITextView *descriptionTextView;
@property(nonatomic, readonly) UIButton *sendButton;

- (void)keyboardWillShowWithHeight:(CGFloat)height duration:(double)duration curve:(NSUInteger)curve;

- (void)keyboardWillHideWithDuration:(double)duration curve:(NSUInteger)curve;
@end