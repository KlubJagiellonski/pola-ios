import XCTest

final class MainGalleryPage: BaseGalleryPage {
    func isGalleryVisible() -> Bool {
        app.navigationBars["Photos"].waitForExistence(timeout: waitForExistanceTimeout)
    }

    func tapAllPhotosCell(file: StaticString = #file, line: UInt = #line) -> PhotosGalleryPage {
        let photosNavigationBarExist = isGalleryVisible()
        XCTAssert(photosNavigationBarExist, "No navigation bar with Photos title", file: file, line: line)
        app.tables.cells["All Photos"].tap()
        return PhotosGalleryPage(openFrom: openFrom)
    }
}
