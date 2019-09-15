#import "BPImageContainerView.h"
#import "BPKeyboardManager.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

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

@property (weak, nonatomic, nullable) id<BPReportProblemViewControllerDelegate> delegate;

@property (nonatomic, readonly) NSNumber *productId;

@property (copy, nonatomic, readonly) NSString *barcode;

- (instancetype)initWithProductId:(NSNumber *)productId barcode:(NSString *)barcode;

@end

NS_ASSUME_NONNULL_END
