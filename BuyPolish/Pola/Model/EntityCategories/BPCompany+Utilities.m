#import "BPCompany+Utilities.h"


@implementation BPCompany (Utilities)

- (void)parse:(NSDictionary *)dictionary {
    self.name = [BPUtilities handleNull:dictionary[@"name"]];
    self.plRegistered = [BPUtilities handleNull:dictionary[@"plRegistered"]];
    self.plRegisteredNotes = [BPUtilities handleNull:dictionary[@"plRegistered_notes"]];
    self.plNotGlobEnt = [BPUtilities handleNull:dictionary[@"plNotGlobEnt"]];
    self.plNotGlobEntNotes = [BPUtilities handleNull:dictionary[@"plNotGlobEnt_notes"]];
    self.plWorkers = [BPUtilities handleNull:dictionary[@"plWorkers"]];
    self.plWorkersNotes = [BPUtilities handleNull:dictionary[@"plWorkers_notes"]];
    self.plCapital = [BPUtilities handleNull:dictionary[@"plCapital"]];
    self.plCapitalNotes = [BPUtilities handleNull:dictionary[@"plCapital_notes"]];
    self.plRnD = [BPUtilities handleNull:dictionary[@"plRnD"]];
    self.plRnDNotes = [BPUtilities handleNull:dictionary[@"plRnD_notes"]];
}

@end