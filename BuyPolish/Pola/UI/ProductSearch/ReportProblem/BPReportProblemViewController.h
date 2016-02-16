#import <Foundation/Foundation.h>
#import "BPImageContainerView.h"
#import "BPKeyboardManager.h"

@class BPReportProblemViewController;

@protocol BPReportProblemViewControllerDelegate <NSObject>
- (void)reportProblemWantsDismiss:(BPReportProblemViewController *)viewController;

- (void)reportProblem:(BPReportProblemViewController *)controller finishedWithResult:(BOOL)result;
@end


@interface BPReportProblemViewController : UIViewController <BPImageContainerViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, BPKeyboardManagerDelegate>

@property(nonatomic, weak) id <BPReportProblemViewControllerDelegate> delegate;

@property(nonatomic, readonly) NSNumber *productId;

@property(nonatomic, readonly, copy) NSString *barcode;

- (instancetype)initWithProductId:(NSNumber *)productId barcode:(NSString *)barcode;

@end