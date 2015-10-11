#import "Objection.h"
#import "BPProductManager.h"
#import "BPProductResult.h"
#import "BPTaskRunner.h"
#import "BPAPIAccessor.h"
#import "BPTask.h"
#import "BPProductResult+Utilities.h"
#import "BPAPIAccessor+Product.h"


@interface BPProductManager ()

@property(nonatomic, readonly) BPTaskRunner *taskRunner;
@property(nonatomic, readonly) BPAPIAccessor *apiAccessor;

@end


@implementation BPProductManager

objection_requires_sel(@selector(taskRunner), @selector(apiAccessor))

- (void)retrieveProductWithBarcode:(NSString *)barcode completion:(void (^)(BPProductResult *, NSError *))completion completionQueue:(NSOperationQueue *)completionQueue {
    __block BPProductResult *product;
    __block NSError *error;

    weakify()
    void (^block)() = ^{
        strongify()

        NSDictionary *productDictionary = [strongSelf.apiAccessor retrieveProductWithBarcode:barcode error:&error];

        if (error) {
            BPLog(@"Error while retrieve product: %@ %@", barcode, error.localizedDescription);
            return;
        }
        product = [[BPProductResult alloc] init];
        [product parse:productDictionary];
    };
    void (^blockCompletion)() = ^{
        if (completion) {
            [completionQueue addOperationWithBlock:^{
                completion(product, error);
            }];
        }
    };
    BPTask *task = [BPTask taskWithlock:block completion:blockCompletion];
    [self.taskRunner runImmediateTask:task];
}

@end