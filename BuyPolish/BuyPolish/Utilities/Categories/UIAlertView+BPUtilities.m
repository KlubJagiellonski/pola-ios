#import "UIAlertView+BPUtilities.h"
#import "UIAlertView+AFNetworking.h"


@implementation UIAlertView (BPUtilities)

+ (UIAlertView *)showErrorAlert:(NSString *)error {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Ouch!", @"Ouch!")
                                                        message:error
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"Dismiss", @"Dismiss")
                                              otherButtonTitles:nil];
    [alertView show];
    return alertView;
}

@end