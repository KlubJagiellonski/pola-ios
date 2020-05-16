#import "BPAboutRow.h"

@interface BPDoubleAboutRow : BPAboutRow

@property (copy, nonatomic) NSString *secondTitle;
@property (nonatomic) SEL secondAction;
@property (weak, nonatomic) id target;

+ (instancetype)rowWithTitle:(NSString *)title
                      action:(SEL)action
                 secondTitle:(NSString *)secondTitle
                secondAction:(SEL)secondAction
                      target:(id)target;

@end
