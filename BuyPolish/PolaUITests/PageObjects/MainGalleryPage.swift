import XCTest

final class MainGalleryPage: BaseGalleryPage {
    func tapAllPhotosCell(file: StaticString = #file, line: UInt = #line) -> PhotosGalleryPage {
        let photosNavigationBarExist = app.navigationBars["Photos"].waitForExistence(timeout: waitForExistanceTimeout)
        XCTAssert(photosNavigationBarExist, "No navigation bar with Photos title", file: file, line: line)
        app.tables.cells["All Photos"].tap()
        return PhotosGalleryPage(openFrom: openFrom)
    }
}
