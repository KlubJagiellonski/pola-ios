#import <Foundation/Foundation.h>


@class BPProductResult;
@class BPProductInfoDataSource;


@interface BPProductInfoViewController : UIViewController <UITableViewDelegate>

@property(nonatomic, readonly) BPProductResult *product;

- (instancetype)initWithProduct:(BPProductResult *)product;

@end