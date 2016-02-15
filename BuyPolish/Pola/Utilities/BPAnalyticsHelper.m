#import <Crashlytics/Crashlytics.h>
#import "BPAnalyticsHelper.h"
#import "BPDeviceHelper.h"
#import "BPScanResult.h"


@implementation BPAnalyticsHelper

+ (void)barcodeScanned:(NSString *)barcode {
    NSDictionary *attributes = @{@"DeviceId" : [BPDeviceHelper deviceId]};
    [Answers logSearchWithQuery:barcode customAttributes:attributes];
}

+ (void)receivedProductResult:(BPScanResult *)productResult {

    [Answers logContentViewWithName:productResult.name
                        contentType:@"Card Preview"
                          contentId:productResult.productId ? productResult.productId.stringValue : nil
                   customAttributes:[self attributesForProductResult:productResult]];
}

+ (void)opensCard:(BPScanResult *)productResult {
    [Answers logContentViewWithName:productResult.name
                        contentType:@"Open Card"
                          contentId:productResult.productId ? productResult.productId.stringValue : nil
                   customAttributes:[self attributesForProductResult:productResult]];
}

+ (void)reportShown:(NSString *)barcode {
    NSDictionary *attributes = @{
        @"DeviceId" : [BPDeviceHelper deviceId],
        @"Code" : barcode
    };

    [Answers logLevelStart:@"Report" customAttributes:attributes];
}

+ (void)reportSent:(NSString *)barcode success:(BOOL)success {
    NSDictionary *attributes = @{
        @"DeviceId" : [BPDeviceHelper deviceId],
        @"Code" : barcode ?: @"No Code"
    };

    [Answers logLevelEnd:@"Report" score:nil success:@(success) customAttributes:attributes];
}

+ (void)aboutOpened:(NSString *)windowName {
    NSDictionary *attributes = @{@"DeviceId" : [BPDeviceHelper deviceId]};
    [Answers logContentViewWithName:windowName contentType:@"About" contentId:nil customAttributes:attributes];
}

+ (NSDictionary *)attributesForProductResult:(BPScanResult *)productResult {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithCapacity:3];
    attributes[@"DeviceId"] = [BPDeviceHelper deviceId];
    if (productResult.code) {
        attributes[@"Code"] = productResult.code;
    }
    return attributes;
}

@end