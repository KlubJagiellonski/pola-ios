@testable import Pola
import SnapshotTesting
import XCTest

class AnalyticsHelperTests: XCTestCase {
    var analyticsMock: AnalyticsProviderMock!
    var sut: AnalyticsHelper!

    let testBarcode = CodeData.Radziemska.barcode
    let testScanResult = CodeData.Radziemska.scanResult

    override func setUpWithError() throws {
        analyticsMock = AnalyticsProviderMock()
        sut = AnalyticsHelper(provider: analyticsMock)
    }

    override func tearDownWithError() throws {
        analyticsMock = nil
        sut = nil
    }

    func assertProviderInvocation(eventName: String, parametersShouldBeNil: Bool = false, file: StaticString = #file, testName: String = #function, line: UInt = #line) {
        XCTAssertEqual(analyticsMock.lastEventName, eventName)
        if parametersShouldBeNil {
            XCTAssertNil(analyticsMock.lastEventParameters)
        } else {
            assertSnapshot(matching: analyticsMock.lastEventParameters, as: .json, file: file, testName: testName, line: line)
        }
    }

    func testBarcodeScanned_whenTypeIsCamera() {
        sut.barcodeScanned(testBarcode, type: .camera)

        assertProviderInvocation(eventName: "scan_code")
    }

    func testBarcodeScanned_whenTypeIsKeyboard() {
        sut.barcodeScanned(testBarcode, type: .keyboard)

        assertProviderInvocation(eventName: "scan_code")
    }

    func testReceived() {
        sut.received(productResult: testScanResult)

        assertProviderInvocation(eventName: "company_received")
    }

    func testOpensCard() {
        sut.opensCard(productResult: testScanResult)

        assertProviderInvocation(eventName: "card_opened")
    }

    func testReportShown() {
        sut.reportShown(barcode: testBarcode)

        assertProviderInvocation(eventName: "report_started")
    }

    func testReportSent() {
        sut.reportSent(barcode: testBarcode)

        assertProviderInvocation(eventName: "report_finished")
    }

    func testPolasFriendsOpened() {
        sut.polasFriendsOpened()

        assertProviderInvocation(eventName: "polas_friends", parametersShouldBeNil: true)
    }

    func testAboutPolaOpened() {
        sut.aboutPolaOpened()

        assertProviderInvocation(eventName: "about_pola", parametersShouldBeNil: true)
    }
}
