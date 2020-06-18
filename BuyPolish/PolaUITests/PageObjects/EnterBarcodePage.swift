import XCTest

final class EnterBarcodePage: BasePage {
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

    func waitForErrorMessage(file: StaticString = #file, line: UInt = #line) -> EnterBarcodePage {
        if !app.staticTexts["błędny kod"].waitForExistence(timeout: waitForExistanceTimeout) {
            XCTFail("Error message not found", file: file, line: line)
        }
        return self
    }

    func waitForResultPage(expectedResult: String, file: StaticString = #file, line: UInt = #line) -> ScanBarcodeWithResultsPage {
        if !app.staticTexts[expectedResult].waitForExistence(timeout: waitForExistanceTimeout) {
            XCTFail("No matches found for scan result:  \(expectedResult)", file: file, line: line)
        }
        return ScanBarcodeWithResultsPage(app: app, result: expectedResult)
    }
}
