import SnapshotTesting
import XCTest

class PolaDarkModeUITestCase: PolaUITestCase {
    override func setUp() {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchEnvironment = ["POLA_URL": "http://localhost:8888"]
        app.launchArguments += ["--disableAnimations"]
        app.launchArguments += ["--enableDarkMode"]
        app.launch()

        startingPageObject = ScanBarcodePage(app: app)
    }
}
