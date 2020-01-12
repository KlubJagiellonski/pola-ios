import XCTest

class PhotosGalleryPage: BasePage {
    
    let openFrom: BasePage
    
    init(openFrom: BasePage) {
        self.openFrom = openFrom
        super.init(app: openFrom.app)
    }
    
    func pickFirstPhoto(file: StaticString = #file, line: UInt = #line) -> BasePage {
        let firstPhotoMatch = app.collectionViews["PhotosGridView"].cells.firstMatch
        let photoExist = firstPhotoMatch.waitForExistence(timeout: waitForExistanceTimeout)
        XCTAssert(photoExist, "No photo found in gallery", file: file, line: line)
        firstPhotoMatch.tap()
        return openFrom
    }
}
