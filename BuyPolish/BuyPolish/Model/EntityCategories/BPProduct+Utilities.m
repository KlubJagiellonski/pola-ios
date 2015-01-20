#import "BPProduct+Utilities.h"
#import "BPCompany.h"
#import "BPCompany+Utilities.h"
#import "NSString+BPUtilities.h"


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

- (void)fillMadeInPolandFromBarcode:(NSString *)barcode {
    int numberSystem = [barcode rangeint(barcode[0:3])
    if number_system == 590:
    self.made_in_poland = 100
    self.made_in_poland_info = 'Towar zarejestrowany w polsce'
    elif number_system >= 200 and number_system <= 299:
    self.made_in_poland = 50
    self.made_in_poland_info = 'Towar ważony. Nieznane miejsce rejestracji produktu.'
    elif number_system == 977:
    self.made_in_poland = 50
    self.made_in_poland_info = 'Kod ISSN. Nieznane miejsce rejestracji produktu.'
    elif number_system == 978:
    self.made_in_poland = 50
    self.made_in_poland_info = 'Kod ISBN. Nieznane miejsce rejestracji produktu.'
    elif number_system == 979:
    self.made_in_poland = 50
    self.made_in_poland_info = 'Kod ISMN. Nieznane miejsce rejestracji produktu.'
    elif number_system > 980:
    self.made_in_poland = 50
    self.made_in_poland_info = 'Nieznane miejsce rejestracji produktu.'
    else:
    self.made_in_poland = 0
    self.made_in_poland_info = 'Kraj rejestracji: ' + country_name_from_number_system(number_system)
}

- (BOOL)containsMainInfo {
    return self.barcode.length > 0;
}

@end