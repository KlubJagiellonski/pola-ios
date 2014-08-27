#import <Foundation/Foundation.h>


@interface BPActivityIndicatorView : UIView

@property(nonatomic, copy) NSString *text;

+ (BPActivityIndicatorView *)showInView:(UIView *)view withText:(NSString *)text;
+ (BOOL)existInView:(UIView *)view;
+ (void)hideInView:(UIView *)view;

@end