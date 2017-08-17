#import "BPAPIAccessor+BPReport.h"
#import "BPAPIResponse.h"


@implementation BPAPIAccessor (BPReport)

- (NSDictionary *)addReportWithDescription:(NSString *)description productId:(NSNumber *)productId filesCount:(NSUInteger)filesCount error:(NSError **)error {
    NSMutableDictionary *jsonBody = [NSMutableDictionary dictionary];
    jsonBody[@"description"] = description;
    if(productId) {
        jsonBody[@"product_id"] = productId;
    }
    jsonBody[@"files_count"] = @(filesCount);
    jsonBody[@"mime_type"] = @"image/png";
    jsonBody[@"file_ext"] = @"png";
    BPAPIResponse *response = [self post:[NSString stringWithFormat:@"create_report"] jsonBody:jsonBody error:error];
    NSDictionary *result = response.responseObject;
    return result;
}

- (NSDictionary *)addImageAtPath:(NSString *)imageAtPath forUrl:(NSString *)requestUrl error:(NSError **)error {
    NSData *data = [NSData dataWithContentsOfFile:imageAtPath];
    BPAPIResponse *response = [self putAmazonMultipart:requestUrl data:data mimeType:@"image/png" error:error];
    NSDictionary *result = response.responseObject;
    return result;
}

@end
