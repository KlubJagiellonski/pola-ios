import Foundation

@objc
protocol BarcodeValidator {
    func isValid(barcode: String) -> Bool
}

@objc
class EANBarcodeValidator: NSObject, BarcodeValidator {
    
    func isValid(barcode: String) -> Bool {
        let characters = Array(barcode)
        let numbers = characters.compactMap({Int(String($0))})
        guard characters.count == numbers.count else {
            return false
        }
        
        if isValidEAN8(code: numbers) { return true }
        if isValidEAN13(code: numbers) { return true }

        return false
    }
    
    private func isValidEAN13(code: [Int]) -> Bool {
        guard code.count == 13 else {
            return false
        }

        let check = code[12]
        let val = (10 -
                   ((code[0] + code[2] + code[4] + code[6] + code[8] + code[10] +
                     (code[1] + code[3] + code[5] + code[7] + code[9] + code[11]) *
                     3) % 10)) % 10
        
        return check == val;
    }
    
    private func isValidEAN8(code: [Int]) -> Bool {
        guard code.count == 8 else {
            return false
        }
        
        let check = code[7]
        let val = (10 -
                   ((code[1] + code[3] + code[5] +
                     (code[0] + code[2] + code[4] + code[6]) *
                     3) % 10)) % 10

        return check == val;
    }
    
}
