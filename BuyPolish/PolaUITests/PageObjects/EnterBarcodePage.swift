import XCTest

class EnterBarcodePage: BasePage {
    
    func tapEnterBarcodeButton() -> ScanBarcodePage {
        app.buttons["Wpisz kod kreskowy"].tap()
        return ScanBarcodePage(app: app)
    }
    
    func tapOkButton() -> EnterBarcodePage {
        app.buttons["Zatwierdź"].tap()
        return self
    }
    
    func tapDeleteButton() -> EnterBarcodePage {
        app.buttons["Usuń ostatnią cyfrę"].tap()
        return self
    }
    
    func inputBarcode(_ barcode: String) -> EnterBarcodePage {
        barcode.forEach { character in
            app.buttons[String(character)].tap()
        }
        return self
    }

    func waitForResultPageAndTap<T: ResultPage>(expectedResult: String, expectedResultType: T.Type) -> T {
        app.otherElements[expectedResult].tap()
        return T(app: app)
    }
    
    func waitForResultPage(expectedResult: String, file: StaticString = #file, line: UInt = #line) -> ScanBarcodeWithResultsPage {
        if !app.otherElements[expectedResult].waitForExistence(timeout: 3) {
            XCTFail("No matches found for scan result:  \(expectedResult)", file: file, line: line)
        }
        return ScanBarcodeWithResultsPage(app: app)
    }
    
}
