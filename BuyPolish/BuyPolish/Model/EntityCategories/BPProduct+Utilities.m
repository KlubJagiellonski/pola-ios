#import "BPProduct+Utilities.h"


@implementation BPProduct (Utilities)

- (void)parse:(NSDictionary *)dictionary {
    self.barcode = dictionary[@"barcode"];
    self.name = dictionary[@"name"];
    self.polish = [dictionary[@"polish"] boolValue];
    self.checked = [dictionary[@"checked"] boolValue];
}

- (BOOL)containsMainInfo {
    return self.name.length > 0;
}

@end