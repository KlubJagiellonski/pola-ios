import XCTest
@testable import Pola

class EANBarcodeValidatorTests: XCTestCase {
    
    var sut: EANBarcodeValidator!

    override func setUp() {
        super.setUp()
        sut = EANBarcodeValidator()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testReturnTrueWhen40170725() {
        XCTAssertTrue(sut.isValid(barcode: "40170725"))
    }

    func testReturnTrueWhen5902746641132() {
        XCTAssertTrue(sut.isValid(barcode: "5902746641132"))
    }

    func testReturnTrueWhen5904284420903() {
        XCTAssertTrue(sut.isValid(barcode: "5904284420903"))
    }

    func testReturnTrueWhen5904277719045() {
        XCTAssertTrue(sut.isValid(barcode: "5904277719045"))
    }
    
    func testReturnTrueWhen9788328053045() {
        XCTAssertTrue(sut.isValid(barcode: "9788328053045"))
    }
    
    func testReturnFalseWhen978832805304() {
        XCTAssertFalse(sut.isValid(barcode: "978832805304"))
    }
    
    func testReturnFalseWhen97883280530() {
        XCTAssertFalse(sut.isValid(barcode: "97883280530"))
    }

    func testReturnFalseWhen9788328053() {
        XCTAssertFalse(sut.isValid(barcode: "9788328053"))
    }
    
    func testReturnFalseWhen978832805() {
        XCTAssertFalse(sut.isValid(barcode: "978832805"))
    }
    
    func testReturnFalseWhen97883280() {
        XCTAssertFalse(sut.isValid(barcode: "97883280"))
    }
    
    func testReturnFalseWhen9788328() {
        XCTAssertFalse(sut.isValid(barcode: "9788328"))
    }
    
    func testReturnFalseWhen978832() {
        XCTAssertFalse(sut.isValid(barcode: "978832"))
    }
    
    func testReturnFalseWhen97883() {
        XCTAssertFalse(sut.isValid(barcode: "97883"))
    }
    
    func testReturnFalseWhen9788() {
        XCTAssertFalse(sut.isValid(barcode: "9788"))
    }
    
    func testReturnFalseWhen978() {
        XCTAssertFalse(sut.isValid(barcode: "978"))
    }
    
    func testReturnFalseWhen97() {
        XCTAssertFalse(sut.isValid(barcode: "97"))
    }
    
    func testReturnFalseWhen9() {
        XCTAssertFalse(sut.isValid(barcode: "9"))
    }
}
