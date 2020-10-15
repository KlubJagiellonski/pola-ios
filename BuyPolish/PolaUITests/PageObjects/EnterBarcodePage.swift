import XCTest

final class EnterBarcodePage: BasePage {
    private let deleteActionKey = "Usuń"
    private let pasteActionKey = "Wklej"

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

    func longTapOnBarcodeLabel() -> EnterBarcodePage {
        let polaKeyboardbarcodeButton = app.buttons["Pola.KeyboardLabel"]
        polaKeyboardbarcodeButton.press(forDuration: 1.0)
        return self
    }

    func tapCopyAction() -> EnterBarcodePage {
        app.staticTexts["Kopiuj"].tap()
        return self
    }

    func tapCutAction() -> EnterBarcodePage {
        app.staticTexts["Wytnij"].tap()
        return self
    }

    func tapPasteAction() -> EnterBarcodePage {
        app.staticTexts[pasteActionKey].tap()
        return self
    }

    func tapPasteAndActivateAction() -> EnterBarcodePage {
        app.staticTexts["Wklej i aktywuj"].tap()
        return self
    }

    func tapDeleteAction() -> EnterBarcodePage {
        app.staticTexts[deleteActionKey].tap()
        return self
    }

    func waitForDeleteActionDisappear(file: StaticString = #file, line: UInt = #line) -> EnterBarcodePage {
        if !app.staticTexts[deleteActionKey].waitForDisappear(timeout: waitForExistanceTimeout) {
            XCTFail("Delete action still visible", file: file, line: line)
        }
        return self
    }

    func waitForPasteActionDisappear(file: StaticString = #file, line: UInt = #line) -> EnterBarcodePage {
        if !app.staticTexts[pasteActionKey].waitForDisappear(timeout: waitForExistanceTimeout) {
            XCTFail("Paste action still visible", file: file, line: line)
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
