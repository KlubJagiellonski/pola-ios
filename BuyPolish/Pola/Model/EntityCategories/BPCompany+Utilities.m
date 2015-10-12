#import "BPCompany+Utilities.h"


@implementation BPCompany (Utilities)

- (void)parse:(NSDictionary *)dictionary {
    self.name = [BPUtilities handleNull:dictionary[@"name"]];
    self.plWorkers = [BPUtilities handleNull:dictionary[@"plWorkers"]];
    self.plWorkersNotes = [BPUtilities handleNull:dictionary[@"plWorkers_notes"]];
    self.plBrand = [BPUtilities handleNull:dictionary[@"plBrand"]];
    self.plBrandNotes = [BPUtilities handleNull:dictionary[@"plBrand_notes"]];
    self.plTaxes = [BPUtilities handleNull:dictionary[@"plTaxes"]];
    self.plTaxesNotes = [BPUtilities handleNull:dictionary[@"plTaxes_notes"]];
    self.plCapital = [BPUtilities handleNull:dictionary[@"plCapital"]];
    self.plCapitalNotes = [BPUtilities handleNull:dictionary[@"plCapital_notes"]];
    self.plRnD = [BPUtilities handleNull:dictionary[@"plRnD"]];
    self.plRnDNotes = [BPUtilities handleNull:dictionary[@"plRnD_notes"]];
}

@end