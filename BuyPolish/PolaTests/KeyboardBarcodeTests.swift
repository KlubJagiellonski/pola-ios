@testable import Pola
import XCTest

class KeyboardBarcodeTests: XCTestCase {
    func testRemoveLast_shouldRemoveLast_whenCodeIsNotEmpty() {
        let sut = KeyboardBarcode(code: "123")

        sut.removeLast()

        XCTAssertEqual(sut.code, "12")
    }

    func testRemoveLast_shouldNotChangeCode_whenCodeIsEmpty() {
        let sut = KeyboardBarcode(code: "")

        sut.removeLast()

        XCTAssertEqual(sut.code, "")
    }

    func testRemoveAll() {
        let sut = KeyboardBarcode(code: "123456789")

        sut.removeAll()

        XCTAssertEqual(sut.code, "")
    }

    func testIsAppeandable_shouldReturnTrue_whenCodeLenghtIsSmallerThan13() {
        let sut = KeyboardBarcode(code: "012345678912")

        XCTAssertTrue(sut.isAppendable)
    }

    func testIsAppeandable_shouldReturnFalse_whenCodeLenghtIs13() {
        let sut = KeyboardBarcode(code: "0123456789123")

        XCTAssertFalse(sut.isAppendable)
    }

    func testAppendNumber_shouldAppend_whenCodeLenghtIsSmallerThan13() {
        let sut = KeyboardBarcode(code: "0123")

        sut.append(number: 4)

        XCTAssertEqual(sut.code, "01234")
    }

    func testAppendNumber_shouldNotChangeCode_whenCodeLenghtIs13() {
        let sut = KeyboardBarcode(code: "0123456789123")

        sut.append(number: 4)

        XCTAssertEqual(sut.code, "0123456789123")
    }

    func testAppendString_shouldAppend_whenCodeLenghtIsSmallerThan13() {
        let sut = KeyboardBarcode(code: "0123")

        sut.append(string: "456789123")

        XCTAssertEqual(sut.code, "0123456789123")
    }

    func testAppendString_shouldNotChangeCode_whenCodeLenghtIs13() {
        let sut = KeyboardBarcode(code: "0123456789123")

        sut.append(string: "456789123")

        XCTAssertEqual(sut.code, "0123456789123")
    }

    func testAppendString_shouldAppendUsingOnlyNumber() {
        let sut = KeyboardBarcode(code: "0123")

        sut.append(string: "4asd5%^& 6f7f8@9-1))2!3")

        XCTAssertEqual(sut.code, "0123456789123")
    }

    func testAppendString_shouldAppendToMaxLenghy() {
        let sut = KeyboardBarcode(code: "0123")

        sut.append(string: "456789123456789")

        XCTAssertEqual(sut.code, "0123456789123")
    }
}
