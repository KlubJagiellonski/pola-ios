#import <Foundation/Foundation.h>
#import "BPAPIAccessor.h"
#import "BPAPIAccessor+BPCapturedImagesData.h"
#import "BPCapturedImagesData.h"
#import "BPCapturedImageManager.h"
#import "BPCapturedImageResult.h"

@interface BPCapturedImagesUploadManager: NSObject

- (void)sendImagesWithData:(BPCapturedImagesData *)imagesData captureSessionTimestamp:(int)timestamp completion:(void (^)(BPCapturedImageResult *, NSError *))completion completionQueue:(NSOperationQueue *)completionQueue;

@end
