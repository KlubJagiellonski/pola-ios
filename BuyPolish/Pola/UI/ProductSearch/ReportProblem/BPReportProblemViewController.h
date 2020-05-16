#import "BPImageContainerView.h"
#import "BPKeyboardManager.h"
#import <Foundation/Foundation.h>

@class BPReportProblemViewController;

@protocol BPReportProblemViewControllerDelegate <NSObject>
- (void)reportProblemWantsDismiss:(BPReportProblemViewController *)viewController;

- (void)reportProblem:(BPReportProblemViewController *)controller finishedWithResult:(BOOL)result;
@end

@interface BPReportProblemViewController : UIViewController <BPImageContainerViewDelegate,
                                                             UIActionSheetDelegate,
                                                             UIImagePickerControllerDelegate,
                                                             UINavigationControllerDelegate,
                                                             BPKeyboardManagerDelegate>

@property (weak, nonatomic) id<BPReportProblemViewControllerDelegate> delegate;

@property (nonatomic, readonly) NSNumber *productId;

@property (copy, nonatomic, readonly) NSString *barcode;

- (instancetype)initWithProductId:(NSNumber *)productId barcode:(NSString *)barcode;

@end
