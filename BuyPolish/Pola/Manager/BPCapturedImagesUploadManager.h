#import <Foundation/Foundation.h>
#import "BPAPIAccessor.h"
#import "BPAPIAccessor+BPCapturedImagesData.h"
#import "BPCapturedImagesData.h"
#import "BPCapturedImageManager.h"
//#import "BPCapturedImagesResult.h"

@interface BPCapturedImagesUploadManager: NSObject

- (void)sendImagesWithData:(BPCapturedImagesData *)imagesData captureSessionTimestamp:(int)timestamp singleUploadCompletion:(void (^)(NSError *))completion completionQueue:(NSOperationQueue *)completionQueue;
@end
