#import <Foundation/Foundation.h>


@class BPProduct;
@class BPProductInfoDataSource;


@interface BPProductInfoViewController : UIViewController <UITableViewDelegate>

@property(nonatomic, readonly) BPProduct *product;

- (instancetype)initWithProduct:(BPProduct *)product;

@end