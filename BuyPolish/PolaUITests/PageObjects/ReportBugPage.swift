import XCTest

final class ReportBugPage: BasePage {
    private let deleteButtonKey = "DeleteIcon"

    func tapAddImageButton() -> ReportBugPage {
        app.buttons["Dodaj zdjęcie"].tap()
        return self
    }

    func tapChooseFromLibrarySheetAction() -> MainGalleryPage {
        app.sheets.scrollViews.otherElements.buttons["Wybierz z biblioteki"].tap()
        return MainGalleryPage(openFrom: self)
    }

    func waitForDeleteButton(file: StaticString = #file, line: UInt = #line) -> ReportBugPage {
        let buttonVisible = app.buttons[deleteButtonKey].waitForExistence(timeout: waitForExistanceTimeout)
        XCTAssert(buttonVisible, "No delete button on report bug page", file: file, line: line)
        return self
    }

    func tapDeleteImageButton() -> ReportBugPage {
        waitForDeleteButton().done()
        app.buttons[deleteButtonKey].tap()

        return self
    }

    func tapDescriptionLabel() -> ReportBugPage {
        app.staticTexts["opis:"].tap()
        return self
    }

    func tapSendReportButton() -> ReportBugPage {
        app.buttons["WYŚLIJ"].tap()
        return self
    }

    func tapCloseButton() -> InformationPage {
        app.buttons["Zamknij"].firstMatch.tap()
        return InformationPage(openFrom: self)
    }

    func waitForReturnToPreviousPage(file: StaticString = #file, line: UInt = #line) -> InformationPage {
        let informationBarExist = app.navigationBars["Informacje"].waitForExistence(timeout: waitForExistanceTimeout)
        XCTAssert(informationBarExist, "No navigation bar with informations title", file: file, line: line)
        return InformationPage(openFrom: self)
    }

    func typeDescription(_ description: String) -> ReportBugPage {
        let textView = app.textViews.firstMatch
        textView.tap()
        textView.typeText(description)
        return self
    }
}
