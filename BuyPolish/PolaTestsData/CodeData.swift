import Foundation

struct CodeData {
    let barcode: String
    let result: String
    let responseFile: String

    static let Radziemska = CodeData(barcode: "5904284420903", result: "RADZIEMSKA", responseFile: "radziemska")
    static let Gustaw = CodeData(barcode: "5904277719045", result: "GUSTAW", responseFile: "gustaw")
    static let Staropramen = CodeData(barcode: "8593868002832", result: "Pivovary Staropramen", responseFile: "staropramen")
    static let ISBN = CodeData(barcode: "9788328053045", result: "Kod ISBN/ISSN/ISMN", responseFile: "isbn")
    static let Tymbark = CodeData(barcode: "5901067405119", result: "MWS Sp. z o.o.", responseFile: "tymbark")
    static let Lomza = CodeData(barcode: "5900535015171", result: "VAN PUR", responseFile: "lomza")
    static let Koral = CodeData(barcode: "5902121022303", result: "Lody Koral", responseFile: "koral")
    static let Naleczowianka = CodeData(barcode: "5900635001111", result: "NESTLE WATERS POLSKA", responseFile: "nestle_waters")
}
