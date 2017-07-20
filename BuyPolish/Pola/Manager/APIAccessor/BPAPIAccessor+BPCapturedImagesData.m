#import "BPAPIAccessor+BPCapturedImagesData.h"
#import "BPAPIResponse.h"


@implementation BPAPIAccessor (BPCapturedImagesData)

- (NSDictionary *)addAiPicsWithCapturedImagesData:(BPCapturedImagesData *)imagesData error:(NSError **)error {
    NSMutableDictionary *jsonBody = [NSMutableDictionary dictionary];
    jsonBody[@"product_id"] = imagesData.productID;
    jsonBody[@"files_count"] = imagesData.filesCount;
    jsonBody[@"file_ext"] = imagesData.fileExtension;
    jsonBody[@"mime_type"] = imagesData.mimeType;
    jsonBody[@"original_width"] = imagesData.originalWidth;
    jsonBody[@"original_height"] = imagesData.originalHeight;
    jsonBody[@"width"] = imagesData.width;
    jsonBody[@"height"] = imagesData.height;
    jsonBody[@"device_name"] = imagesData.deviceName;
    
    BPAPIResponse *response = [self post: [NSString stringWithFormat:@"add_ai_pics"] jsonBody:jsonBody error:error];
    NSDictionary *result = response.responseObject;
    return result;
}

- (NSDictionary *)uploadImage:(NSData *)imageData toUrl:(NSString *)uploadUrl mimeType:(NSString *)mimeType error:(NSError **)error {
    BPAPIResponse *response = [self putAmazonMultipart:uploadUrl data:imageData mimeType:mimeType error:error];
    NSDictionary *result = response.responseObject;
    return result;
}

@end
