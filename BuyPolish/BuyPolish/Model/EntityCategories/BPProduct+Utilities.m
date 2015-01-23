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
    if (companyDict != nil) {
        BPCompany *company = [[BPCompany alloc] init];
        [company parse:companyDict];
        self.company = company;
    }
}

- (void)fillMadeInPolandFromBarcode:(NSString *)barcode {
    int numberSystem = [[barcode substringToIndex:3] intValue];
    if (numberSystem == 590) {
        self.madeInPoland = @100;
        self.madeInPolandInfo = @"Towar zarejestrowany w polsce";
    } else if (numberSystem >= 200 && numberSystem <= 299) {
        self.madeInPoland = @50;
        self.madeInPolandInfo = @"Towar ważony. Nieznane miejsce rejestracji produktu.";
    } else if (numberSystem == 977) {
        self.madeInPoland = @50;
        self.madeInPolandInfo = @"Kod ISSN. Nieznane miejsce rejestracji produktu.";
    } else if (numberSystem == 978) {
        self.madeInPoland = @50;
        self.madeInPolandInfo = @"Kod ISBN. Nieznane miejsce rejestracji produktu.";
    } else if (numberSystem == 979) {
        self.madeInPoland = @50;
        self.madeInPolandInfo = @"Kod ISMN. Nieznane miejsce rejestracji produktu.";
    } else if (numberSystem > 980) {
        self.madeInPoland = @50;
        self.madeInPolandInfo = @"Nieznane miejsce rejestracji produktu.";
    } else {
        self.madeInPoland = @0;
        self.madeInPolandInfo = [NSString stringWithFormat:@"Kraj rejestracji: %@", [self contryNameFromNumberSystem:numberSystem]];
    }
}

- (NSString *)contryNameFromNumberSystem:(int)numberSystem {
    static NSDictionary *codeToCountryNameMap;
    if (codeToCountryNameMap == nil) {
        codeToCountryNameMap = @{
            @"30" : @"Francja",
            @"31" : @"Francja",
            @"32" : @"Francja",
            @"33" : @"Francja",
            @"34" : @"Francja",
            @"35" : @"Francja",
            @"36" : @"Francja",
            @"37" : @"Francja",
            @"380" : @"Bułgaria",
            @"383" : @"Słowenia",
            @"385" : @"Chorwacja",
            @"387" : @"Bośnia-Hercegowina",
            @"40" : @"Niemcy",
            @"41" : @"Niemcy",
            @"42" : @"Niemcy",
            @"43" : @"Niemcy",
            @"44" : @"Niemcy",
            @"45" : @"Japonia",
            @"46" : @"Federacja Rosyjska",
            @"470" : @"Kirgistan",
            @"471" : @"Taiwan",
            @"474" : @"Estonia",
            @"475" : @"Łotwa",
            @"476" : @"Azerbejdżan",
            @"477" : @"Litwa",
            @"478" : @"Uzbekistan",
            @"479" : @"Sri Lanka",
            @"480" : @"Filipiny",
            @"481" : @"Białoruś",
            @"482" : @"Ukraina",
            @"484" : @"Mołdova",
            @"485" : @"Armenia",
            @"486" : @"Gruzja",
            @"487" : @"Kazachstan",
            @"489" : @"Hong Kong",
            @"49" : @"Japonia",
            @"50" : @"Wielka Brytania",
            @"520" : @"Grecja",
            @"528" : @"Liban",
            @"529" : @"Cypr",
            @"531" : @"Macedonia",
            @"535" : @"Malta",
            @"539" : @"Irlandia",
            @"54" : @"Belgia & Luksemburg",
            @"560" : @"Portugalia",
            @"569" : @"Islandia",
            @"57" : @"Dania",
            @"590" : @"Polska",
            @"594" : @"Rumunia",
            @"599" : @"Węgry",
            @"600" : @"Południowa Afryka",
            @"601" : @"Południowa Afryka",
            @"608" : @"Bahrain",
            @"609" : @"Mauritius",
            @"611" : @"Maroko",
            @"613" : @"Algeria",
            @"619" : @"Tunezja",
            @"621" : @"Syria",
            @"622" : @"Egipt",
            @"624" : @"Libia",
            @"625" : @"Jordania",
            @"626" : @"Iran",
            @"627" : @"Kuwejt",
            @"628" : @"Arabia Saudyjska",
            @"64" : @"Finlandia",
            @"690" : @"Chiny",
            @"691" : @"Chiny",
            @"692" : @"Chiny",
            @"70" : @"Norwegia",
            @"729" : @"Izrael",
            @"73" : @"Szwecja",
            @"740" : @"Gwatemala",
            @"741" : @"Salwador",
            @"742" : @"Honduras",
            @"743" : @"Nikaragua",
            @"744" : @"Kostaryka",
            @"745" : @"Panama",
            @"746" : @"Dominikana",
            @"750" : @"Meksyk",
            @"759" : @"Wenezuela",
            @"76" : @"Szwajcaria",
            @"770" : @"Kolumbia",
            @"773" : @"Urugwaj",
            @"775" : @"Peru",
            @"777" : @"Boliwia",
            @"779" : @"Argentyna",
            @"780" : @"Chile",
            @"784" : @"Paragwaj",
            @"786" : @"Ekwador",
            @"789" : @"Brazylia",
            @"790" : @"Brazylia",
            @"80" : @"Włochy",
            @"81" : @"Włochy",
            @"82" : @"Włochy",
            @"83" : @"Włochy",
            @"84" : @"Hiszpania",
            @"850" : @"Kuba",
            @"858" : @"Słowacja",
            @"859" : @"Czechy",
            @"860" : @"Jugosławia",
            @"867" : @"Korea Północna",
            @"869" : @"Turcja",
            @"87" : @"Holandia",
            @"880" : @"Korea Południowa",
            @"885" : @"Tajlandia",
            @"888" : @"Singapur",
            @"890" : @"Indie",
            @"893" : @"Wietnam",
            @"899" : @"Indonezja",
            @"90" : @"Austria",
            @"91" : @"Austria",
            @"93" : @"Australia",
            @"94" : @"Nowa Zelandia",
            @"950" : @"EAN - IDA",
            @"955" : @"Malezja",
            @"958" : @"Makao",
        };
    }

    if (numberSystem >= 0 && numberSystem <= 139) {
        return @"USA & Kanada";
    }
    
    
    NSString *countryName = [codeToCountryNameMap objectForKey:[@(numberSystem) stringValue]];
    if (countryName) {
        return countryName;
    } else {
        int twoDigitNumberSystem = numberSystem/10;
        countryName = [codeToCountryNameMap objectForKey:[@(twoDigitNumberSystem) stringValue]];
        if(countryName) {
            return countryName;
        } else {
            return @"Nieznany";
        }
    }
}

- (BOOL)containsMainInfo {
    return self.barcode.length > 0;
}

@end