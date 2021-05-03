@testable import Pola
import SnapshotTesting
import UIKit
import XCTest

class UIButtonReportTypeSnapshotTests: XCTestCase {
    func testView(reportType: AskForReport.ButtonType,
                  highlighted: Bool,
                  text: String,
                  file: StaticString = #file,
                  testName: String = #function,
                  line: UInt = #line) {
        let sut = UIButton()
        sut.setTitle(text, for: .normal)
        sut.setReportType(reportType)
        sut.isHighlighted = highlighted
        sut.sizeToFit()
        sut.frameSize = CGSize(width: 200, height: sut.frameSize.height)

        assertSnapshot(matching: sut, as: .image, file: file, testName: testName, line: line)
    }

    func testView_whenReportTypeIsWhite_shouldLookProperlyForNormalState() {
        testView(reportType: .white, highlighted: false, text: "White Normal")
    }

    func testView_whenReportTypeIsWhite_shouldLookProperlyForHighlightedState() {
        testView(reportType: .white, highlighted: true, text: "White Highlighted")
    }

    func testView_whenReportTypeIsRed_shouldLookProperlyForNormalState() {
        testView(reportType: .red, highlighted: false, text: "Red Normal")
    }

    func testView_whenReportTypeIsRed_shouldLookProperlyForHighlightedState() {
        testView(reportType: .red, highlighted: true, text: "Red Highlighted")
    }
}
