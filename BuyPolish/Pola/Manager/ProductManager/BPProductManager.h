#import <Foundation/Foundation.h>

@class BPProductResult;


@interface BPProductManager : NSObject

- (void)retrieveProductWithBarcode:(NSString *)barcode completion:(void (^)(BPProductResult *, NSError *))completion completionQueue:(NSOperationQueue *)queue;

@end