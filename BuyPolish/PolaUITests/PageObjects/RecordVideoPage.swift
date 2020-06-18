import XCTest

final class RecordVideoPage: BasePage {
    func tapStartButton() -> RecordVideoPage {
        app.buttons["START"].tap()
        return self
    }

    func waitForTimerLabel(seconds: Int, file: StaticString = #file, line: UInt = #line) -> RecordVideoPage {
        let buttonVisible = app.staticTexts["\(seconds) sek."].waitForExistence(timeout: waitForExistanceTimeout)
        XCTAssert(buttonVisible, "No timer label with \(seconds) seconds on record video page", file: file, line: line)
        return self
    }
}
