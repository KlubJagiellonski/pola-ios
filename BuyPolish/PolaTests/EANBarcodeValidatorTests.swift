import DataDrivenTesting
@testable import Pola
import XCTest

class EANBarcodeValidatorTests: XCTestCase {
    func testIsValid() {
        let sut = EANBarcodeValidator()

        dataTests([
            TestData((barcode: "40170725", isValid: true)),
            TestData((barcode: "5902746641132", isValid: true)),
            TestData((barcode: "5904284420903", isValid: true)),
            TestData((barcode: "5904277719045", isValid: true)),
            TestData((barcode: "9788328053045", isValid: true)),
            TestData((barcode: "978832805304", isValid: false)),
            TestData((barcode: "97883280530", isValid: false)),
            TestData((barcode: "978832805", isValid: false)),
            TestData((barcode: "97883280", isValid: false)),
            TestData((barcode: "9788328", isValid: false)),
            TestData((barcode: "978832", isValid: false)),
            TestData((barcode: "97883", isValid: false)),
            TestData((barcode: "9788", isValid: false)),
            TestData((barcode: "978", isValid: false)),
            TestData((barcode: "97", isValid: false)),
            TestData((barcode: "7", isValid: false)),

        ]) { testData, _ in
            let result = sut.isValid(barcode: testData.data.barcode)

            XCTAssertEqual(result, testData.data.isValid, file: testData.file, line: testData.line)
        }
    }
}
