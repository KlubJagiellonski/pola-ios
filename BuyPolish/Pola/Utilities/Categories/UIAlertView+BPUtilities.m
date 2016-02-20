#import "UIAlertView+BPUtilities.h"
#import "UIAlertView+AFNetworking.h"


@implementation UIAlertView (BPUtilities)

+ (UIAlertView *)showErrorAlert:(NSString *)error {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Ouch!", nil)
                                                        message:error
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"Dismiss", nil)
                                              otherButtonTitles:nil];
    [alertView show];
    return alertView;
}

@end