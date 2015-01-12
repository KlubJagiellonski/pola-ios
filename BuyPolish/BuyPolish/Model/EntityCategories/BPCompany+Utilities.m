#import "BPCompany+Utilities.h"


@implementation BPCompany (Utilities)

- (void)parse:(NSDictionary *)dictionary {
    self.name = [BPUtilities handleNull:dictionary[@"name"]];
    self.madeInPoland = [BPUtilities handleNull:dictionary[@"made_in_poland"]];
    self.madeInPolandInfo = [BPUtilities handleNull:dictionary[@"made_in_poland_info"]];
    self.capitalInPoland = [BPUtilities handleNull:dictionary[@"capital_in_poland"]];
    self.capitalInPolandInfo = [BPUtilities handleNull:dictionary[@"capital_in_poland_info"]];
    self.taxesInPoland = [BPUtilities handleNull:dictionary[@"taxes_in_poland"]];
    self.taxesInPolandInfo = [BPUtilities handleNull:dictionary[@"taxes_in_poland_info"]];
    self.krsUrl = [BPUtilities handleNull:dictionary[@"krs_url"]];
    self.nip = [BPUtilities handleNull:dictionary[@"nip"]];
    self.regon = [BPUtilities handleNull:dictionary[@"regon"]];
}

@end