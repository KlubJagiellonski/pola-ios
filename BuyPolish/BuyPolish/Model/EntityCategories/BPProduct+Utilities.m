#import "BPProduct+Utilities.h"
#import "BPCompany.h"
#import "BPCompany+Utilities.h"


@implementation BPProduct (Utilities)

- (void)parse:(NSDictionary *)dictionary {
    self.barcode = dictionary[@"barcode"];
    self.name = dictionary[@"name"];
    self.madeInPoland = dictionary[@"made_in_poland"];
    self.madeInPolandInfo = dictionary[@"made_in_poland_info"];

    NSDictionary *companyDict = dictionary[@"company"];
    if(companyDict != nil) {
        BPCompany *company = [[BPCompany alloc] init];
        [company parse:companyDict];
        self.company = company;
    }
}

- (BOOL)containsMainInfo {
    return self.name.length > 0;
}

@end