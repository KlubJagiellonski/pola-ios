import FBSnapshotTestCase

final class LaunchScreenSnapshotTests: FBSnapshotTestCase {
    var sut: UIViewController!

    override func setUp() {
        super.setUp()
        recordMode = false
        let bundle = Bundle(identifier: "Pola")
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: bundle)
        sut = storyboard.instantiateInitialViewController()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testView(width: CGFloat, height: CGFloat) {
        sut.view.frame = CGRect(origin: .zero, size: CGSize(width: width, height: height))

        FBSnapshotVerifyView(sut.view)
    }

    // iPhone 4, 4s
    func testViewOnIPhone4() {
        testView(width: 320, height: 480)
    }

    // iPhone 5, 5s, 5c, SE
    func testViewOnIPhone5() {
        testView(width: 320, height: 568)
    }

    // iPhone 6, 6s, 7, 8
    func testViewOnIPhone6() {
        testView(width: 375, height: 667)
    }

    // iPhone 6+, 6s+, 7+, 8+
    func testViewOnIPhone6Plus() {
        testView(width: 414, height: 736)
    }

    // iPhone X, Xs
    func testViewOnIPhoneX() {
        testView(width: 375, height: 812)
    }

    // iPhone Xr, Xs Max
    func testViewOnIPhoneXr() {
        testView(width: 414, height: 896)
    }
}
