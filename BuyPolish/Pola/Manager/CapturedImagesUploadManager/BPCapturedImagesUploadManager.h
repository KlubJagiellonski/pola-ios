#import "BPAPIAccessor+BPCapturedImagesData.h"
#import "BPAPIAccessor.h"
#import "BPCapturedImageManager.h"
#import "BPCapturedImageResult.h"
#import "BPCapturedImagesData.h"
#import <Foundation/Foundation.h>

@interface BPCapturedImagesUploadManager : NSObject

- (void)sendImagesWithData:(BPCapturedImagesData *)imagesData
    captureSessionTimestamp:(int)timestamp
                   progress:(void (^)(BPCapturedImageResult *, NSError *))progress
                 completion:(void (^)(NSError *))completion
              dispatchQueue:(NSOperationQueue *)dispatchQueue;

@end
