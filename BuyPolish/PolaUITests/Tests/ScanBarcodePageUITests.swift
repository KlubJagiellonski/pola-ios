import XCTest

final class ScanBarcodePageUITests: PolaUITestCase {
    
    override func setUp() {
        super.setUp()
        recordMode = false
    }
        
    func testOpenApp() {
        snapshotVerifyView()
    }

}
