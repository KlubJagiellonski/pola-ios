#import <Foundation/Foundation.h>


@class BPProduct;


@interface BPProductInfoViewController : UIViewController

@property(nonatomic, readonly) BPProduct *product;

- (instancetype)initWithProduct:(BPProduct *)product;

@end