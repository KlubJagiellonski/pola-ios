#import <Foundation/Foundation.h>

@class BPScanResult;

@interface BPProductManager : NSObject

- (void)retrieveProductWithBarcode:(NSString *)barcode completion:(void (^)(BPScanResult *, NSError *))completion completionQueue:(NSOperationQueue *)queue;

@end
