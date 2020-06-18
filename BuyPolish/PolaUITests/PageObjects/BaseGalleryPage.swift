import XCTest

class BaseGalleryPage: BasePage {
    let openFrom: BasePage

    init(openFrom: BasePage) {
        self.openFrom = openFrom
        super.init(app: openFrom.app)
        waitForExistanceTimeout = 30
    }
}
