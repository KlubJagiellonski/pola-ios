#import <Foundation/Foundation.h>

@class BPProduct;


@interface BPProductManager : NSObject

- (void)retrieveProductWithBarcode:(NSString *)barcode completion:(void (^)(BPProduct *, NSError *))completion;

@end