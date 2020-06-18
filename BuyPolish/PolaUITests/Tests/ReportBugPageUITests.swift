import XCTest

final class ReportBugPageUITests: PolaUITestCase {
    private var page: ReportBugPage!

    override func setUp() {
        super.setUp()
        recordMode = false
        continueAfterFailure = true

        page = startingPageObject
            .tapInformationButton()
            .tapReportBugButton()
    }

    override func tearDown() {
        page = nil
        super.tearDown()
    }

    func testOpenReportBugPage() {
        snapshotVerifyView()
    }

    func testCloseReportBugPage() {
        page.tapCloseButton().done()

        snapshotVerifyView()
    }

    func testAddImage() {
        page.addPhoto().done()

        snapshotVerifyView()

        page.tapDeleteImageButton().done()
    }

    func testAddImageTapBackAndReturnToReportBugPage_shouldDisplayPreviousPickedImage() {
        page.addPhoto()
            .tapCloseButton()
            .tapReportBugButton()
            .done()

        snapshotVerifyView()

        page.tapDeleteImageButton().done()
    }

    func testDeleteImage() {
        page.addPhoto()
            .tapDeleteImageButton().done()

        snapshotVerifyView()
    }

    func testTypeDescription() {
        page.typeDescription("Kawał dobrej aplikacji ;)")
            .tapDescriptionLabel()
            .done()

        snapshotVerifyView()
    }

    func testSendReport_shouldRemoveImagesAfterSendReport() {
        page.addPhoto()
            .typeDescription("Raport testowy")
            .tapDescriptionLabel()
            .tapSendReportButton()
            .done()

        expectRequest(path: "/create_report")
        expectRequest(path: "/image")

        page.waitForReturnToPreviousPage()
            .tapReportBugButton()
            .done()

        snapshotVerifyView()
    }
}

private extension ReportBugPage {
    func addPhoto() -> ReportBugPage {
        tapAddImageButton()
            .tapChooseFromLibrarySheetAction()
            .tapAllPhotosCell()
            .pickFirstPhoto().done()
        return waitForDeleteButton()
    }
}
