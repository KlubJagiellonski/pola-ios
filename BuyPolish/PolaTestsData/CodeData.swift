import Foundation

struct CodeData {
    let barcode: String
    let result: String
    let responseFile: String

    static let Radziemska = CodeData(barcode: "5904284420903", result: "Radziemska Wyrób art. Chemii Gospodarczej", responseFile: "radziemska")
    static let Gustaw = CodeData(barcode: "5904277719045", result: "Woda dla firmy", responseFile: "gustaw")
    static let Staropramen = CodeData(barcode: "8593868002832", result: "Pivovary Staropramen sro", responseFile: "staropramen")
    static let ISBN = CodeData(barcode: "9788310131539", result: "Kod ISBN/ISSN/ISMN", responseFile: "isbn")
    static let Tymbark = CodeData(barcode: "5901067405119", result: "Tymbark - MWS Sp. z o.o. Sp. k.", responseFile: "tymbark")
    static let Lomza = CodeData(barcode: "5900535015171", result: "Van Pur S.A.", responseFile: "lomza")
    static let Koral = CodeData(barcode: "5902121022303", result: "P. P. L. KORAL Józef Koral S.J.", responseFile: "koral")
    static let Naleczowianka = CodeData(barcode: "5900635001111", result: "Nestle Waters Polska S.A.", responseFile: "nestle_waters")
    static let Krasnystaw = CodeData(barcode: "5902057000475", result: "OKRĘGOWA SPÓŁDZIELNIA MLECZARSKA W KRASNYMSTAWIE", responseFile: "krasnystaw")
    static let Lidl = CodeData(barcode: "20268190", result: "Marka własna - Sieć Lidl", responseFile: "lidl")
}
