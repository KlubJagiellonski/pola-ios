#import "BPCompany+Utilities.h"


@implementation BPCompany (Utilities)

- (void)parse:(NSDictionary *)dictionary {
    self.name = [BPUtilities handleNull:dictionary[@"name"]];
    self.nip = [BPUtilities handleNull:dictionary[@"nip"]];
    self.address = [BPUtilities handleNull:dictionary[@"address"]];
    self.capitalInPoland = [BPUtilities handleNull:dictionary[@"plCapital"]];
    self.capitalInPolandInfo = [BPUtilities handleNull:dictionary[@"plCapital_notes"]];
}

@end