@testable import Pola
import SnapshotTesting
import XCTest

class OwnBrandContentViewSnapshotTesting: XCTestCase {
    func testView_whenResultIsLidl() {
        testView(data: .Lidl)
    }
    
    func testView_whenResultIsLidl_dark() {
        testView(data: .Lidl, enableDarkMode: true)
    }

    private func testView(data: CodeData, enableDarkMode: Bool = false, file: StaticString = #file, testName: String = #function, line: UInt = #line) {
        let sut = OwnBrandContentViewController(result: data.scanResult)
        
        if enableDarkMode, #available(iOS 13.0, *) {
            sut.overrideUserInterfaceStyle = .dark
        }
        
        sut.view.addConstraint(sut.view.widthAnchor.constraint(equalToConstant: 320))

        assertSnapshot(matching: sut.view, as: .image, file: file, testName: testName, line: line)
    }
}
