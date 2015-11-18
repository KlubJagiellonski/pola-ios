#import "BPScanResult+Utilities.h"


@implementation BPScanResult (Utilities)

- (void)parse:(NSDictionary *)dictionary {
    self.id = [BPUtilities handleNull:dictionary[@"product_id"]];
    self.code = [BPUtilities handleNull:dictionary[@"code"]];
    self.name = [BPUtilities handleNull:dictionary[@"name"]];
    self.cardType = [self parseCardType:[BPUtilities handleNull:dictionary[@"card_type"]]];
    self.plScore = [BPUtilities handleNull:dictionary[@"plScore"]];
    self.altText = [BPUtilities handleNull:dictionary[@"altText"]];
    self.plCapital = [BPUtilities handleNull:dictionary[@"plCapital"]];
    self.plCapitalNotes = [BPUtilities handleNull:dictionary[@"plCapital_notes"]];
    self.plWorkers = [BPUtilities handleNull:dictionary[@"plWorkers"]];
    self.plWorkersNotes = [BPUtilities handleNull:dictionary[@"plWorkers_notes"]];
    self.plRnD = [BPUtilities handleNull:dictionary[@"plRnD"]];
    self.plRnDNotes = [BPUtilities handleNull:dictionary[@"plRnD_notes"]];
    self.plRegistered = [BPUtilities handleNull:dictionary[@"plRegistered"]];
    self.plRegisteredNotes = [BPUtilities handleNull:dictionary[@"plRegistered_notes"]];
    self.plNotGlobEnt = [BPUtilities handleNull:dictionary[@"plNotGlobEnt"]];
    self.plNotGlobEntNotes = [BPUtilities handleNull:dictionary[@"plNotGlobEnt_notes"]];
    self.reportText = [BPUtilities handleNull:dictionary[@"report_text"]];
    self.reportButtonText = [BPUtilities handleNull:dictionary[@"report_button_text"]];
    self.reportButtonType = [self parseReportButtonType:[BPUtilities handleNull:dictionary[@"report_button_type"]]];
}

- (CardType)parseCardType:(NSString *)cardType {
    if([cardType isEqualToString:@"type_grey"]) {
        return CardTypeGrey;
    } else {
        return CardTypeWhite;
    }
}

- (ReportButtonType)parseReportButtonType:(NSString *)reportButtonType {
    if([reportButtonType isEqualToString:@"type_white"]) {
        return ReportButtonTypeWhite;
    } else {
        return ReportButtonTypeRed;
    }
}

@end