#import "BPProduct+Utilities.h"
#import "BPCompany.h"
#import "BPCompany+Utilities.h"


@implementation BPProduct (Utilities)

- (void)parse:(NSDictionary *)dictionary {
    self.barcode = [BPUtilities handleNull:dictionary[@"barcode"]];
    self.name = [BPUtilities handleNull:dictionary[@"name"]];
    self.madeInPoland = [BPUtilities handleNull:dictionary[@"made_in_poland"]];
    self.madeInPolandInfo = [BPUtilities handleNull:dictionary[@"made_in_poland_info"]];

    NSDictionary *companyDict = dictionary[@"company"];
    if(companyDict != nil) {
        BPCompany *company = [[BPCompany alloc] init];
        [company parse:companyDict];
        self.company = company;
    }
}

- (BOOL)containsMainInfo {
    return self.barcode.length > 0;
}

@end