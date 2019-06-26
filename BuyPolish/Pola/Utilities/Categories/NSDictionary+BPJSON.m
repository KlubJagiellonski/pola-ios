#import "NSDictionary+BPJSON.h"

@implementation NSDictionary (BPJSON)

- (NSString *)jsonString {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:0
                                                         error:&error];
    if (error) {
        BPLog(@"Error while parsing dict to json: %@", error);
        return nil;
    }

    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
