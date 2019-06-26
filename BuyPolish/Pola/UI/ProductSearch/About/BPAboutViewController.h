#import <MessageUI/MessageUI.h>
#import <Foundation/Foundation.h>
#import "BPReportProblemViewController.h"

@class BPAboutViewController;

@protocol BPInfoViewControllerDelegate <NSObject>
- (void)infoCancelled:(BPAboutViewController *)viewController;

- (void)showWebWithUrl:(NSString *)url title:(NSString *)title;
@end

@interface BPAboutViewController : UITableViewController <MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, BPReportProblemViewControllerDelegate>

@property(weak, nonatomic) id <BPInfoViewControllerDelegate> delegate;

@end
