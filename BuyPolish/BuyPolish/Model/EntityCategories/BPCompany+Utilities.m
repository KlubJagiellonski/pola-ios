#import "BPCompany+Utilities.h"


@implementation BPCompany (Utilities)

- (void)parse:(NSDictionary *)dictionary {
    self.name = dictionary[@"name"];
    self.madeInPoland = dictionary[@"made_in_poland"];
    self.madeInPolandInfo = dictionary[@"made_in_poland_info"];
    self.capitalInPoland = dictionary[@"capital_in_poland"];
    self.capitalInPolandInfo = dictionary[@"capital_in_poland_info"];
    self.taxesInPoland = dictionary[@"taxes_in_poland"];
    self.taxesInPolandInfo = dictionary[@"taxes_in_poland_info"];
    self.krsUrl = dictionary[@"krs_url"];
    self.nip = dictionary[@"nip"];
    self.regon = dictionary[@"regon"];
}

@end