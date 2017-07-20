#import <Foundation/Foundation.h>
#import "BPAPIAccessor.h"
#import "BPCapturedImagesData.h"

@interface BPAPIAccessor (BPCapturedImagesData)

- (NSDictionary *)addAiPicsWithCapturedImagesData:(BPCapturedImagesData *)imagesData error:(NSError **)error;

- (NSDictionary *)uploadImage:(NSData *)imageData toUrl:(NSString *)uploadUrl mimeType:(NSString *)mimeType error:(NSError **)error;

@end
