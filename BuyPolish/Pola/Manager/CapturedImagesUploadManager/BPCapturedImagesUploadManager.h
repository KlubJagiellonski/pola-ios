#import <Foundation/Foundation.h>
#import "BPAPIAccessor.h"
#import "BPAPIAccessor+BPCapturedImagesData.h"
#import "BPCapturedImagesData.h"
#import "BPCapturedImageManager.h"
#import "BPCapturedImageResult.h"

@interface BPCapturedImagesUploadManager: NSObject

- (void)sendImagesWithData:(BPCapturedImagesData *)imagesData
   captureSessionTimestamp:(int)timestamp
                  progress:(void (^)(BPCapturedImageResult *, NSError *))progress
                completion:(void (^)(NSError *))completion
             dispatchQueue:(NSOperationQueue *)dispatchQueue;

@end
