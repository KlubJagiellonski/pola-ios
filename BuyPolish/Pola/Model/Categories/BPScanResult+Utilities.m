#import "BPScanResult+Utilities.h"
#import "NSDictionary+Parsing.h"

@implementation BPScanResult (Utilities)

- (void)parse:(NSDictionary *)dictionary {
    self.productId = [dictionary nilOrNumberForKey:@"product_id"];
    self.code = [dictionary nilOrStringForKey:@"code"];
    self.name = [dictionary nilOrStringForKey:@"name"];
    self.cardType = [self parseCardType:[dictionary nilOrStringForKey:@"card_type"]];
    self.plScore = [dictionary nilOrNumberForKey:@"plScore"];
    self.altText = [dictionary nilOrStringForKey:@"altText"];
    self.plCapital = [dictionary nilOrNumberForKey:@"plCapital"];
    self.plWorkers = [dictionary nilOrNumberForKey:@"plWorkers"];
    self.plRnD = [dictionary nilOrNumberForKey:@"plRnD"];
    self.plRegistered = [dictionary nilOrNumberForKey:@"plRegistered"];
    self.plNotGlobEnt = [dictionary nilOrNumberForKey:@"plNotGlobEnt"];
    self.descr = [dictionary nilOrStringForKey:@"description"];
    self.reportText = [dictionary nilOrStringForKey:@"report_text"];
    self.reportButtonText = [dictionary nilOrStringForKey:@"report_button_text"];
    self.reportButtonType = [self parseReportButtonType:[dictionary nilOrStringForKey:@"report_button_type"]];
}

- (CardType)parseCardType:(NSString *)cardType {
    return [cardType isEqualToString:@"type_grey"] ? CardTypeGrey : CardTypeWhite;
}

- (ReportButtonType)parseReportButtonType:(NSString *)reportButtonType {
    return [reportButtonType isEqualToString:@"type_white"] ? ReportButtonTypeWhite : ReportButtonTypeRed;
}

@end