import FBSnapshotTestCase
@testable import Pola

class CheckRowSnapshotTests: FBSnapshotTestCase {
    
    var sut: CheckRow!

    override func setUp() {
        super.setUp()
        recordMode = false
        sut = CheckRow(frame: .zero)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func verifyView(file: StaticString = #file, line: UInt = #line){
        sut.sizeToFit()
        FBSnapshotVerifyView(sut, file: file, line: line)
    }

    func testView_WhenCheckedIsNil() {
        sut.checked = nil
        verifyView()
    }
    
    func testView_WhenCheckedIsTrue() {
        sut.checked = true
        verifyView()
    }
    
    func testView_WhenCheckedIsFalse() {
        sut.checked = false
        verifyView()
    }
    
    func testView_WhenTextIsNotNil() {
        sut.text = "produkuje w Polsce"
        verifyView()
    }

}
