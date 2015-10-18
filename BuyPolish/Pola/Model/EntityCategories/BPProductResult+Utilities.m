#import "BPProductResult+Utilities.h"
#import "BPCompany.h"
#import "BPCompany+Utilities.h"


@implementation BPProductResult (Utilities)

- (void)parse:(NSDictionary *)dictionary {
    self.plScore = [BPUtilities handleNull:dictionary[@"plScore"]];
    self.verified = [BPUtilities handleNull:dictionary[@"verified"]];
    self.report = [BPUtilities handleNull:dictionary[@"report"]];

    NSDictionary *companyDict = [BPUtilities handleNull:dictionary[@"company"]];
    if (companyDict != nil) {
        BPCompany *company = [[BPCompany alloc] init];
        [company parse:companyDict];
        self.company = company;
    }
}

@end