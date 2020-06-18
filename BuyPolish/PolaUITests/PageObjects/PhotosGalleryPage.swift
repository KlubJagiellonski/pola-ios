import XCTest

final class PhotosGalleryPage: BaseGalleryPage {
    func pickFirstPhoto(file: StaticString = #file, line: UInt = #line) -> BasePage {
        let firstPhotoMatch = app.collectionViews["PhotosGridView"].cells.firstMatch
        let photoExist = firstPhotoMatch.waitForExistence(timeout: waitForExistanceTimeout)
        XCTAssert(photoExist, "No photo found in gallery", file: file, line: line)
        firstPhotoMatch.tap()
        return openFrom
    }
}
