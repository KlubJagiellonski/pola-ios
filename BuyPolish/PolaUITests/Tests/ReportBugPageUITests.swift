import XCTest

final class ReportBugPageUITests: PolaUITestCase {
    private var page: ReportBugPage!

    override func setUp() {
        super.setUp()
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

    func testCloseReportBugPage() throws {
        throw skipTest(issueNumber: 159)
        page.tapCloseButton().done()

        snapshotVerifyView()
    }

    func testAddImage() throws {
        throw skipTest(issueNumber: 150)
        page.addPhoto().done()

        snapshotVerifyView()

        page.tapDeleteImageButton().done()
    }

    func testAddImageTapBackAndReturnToReportBugPage_shouldDisplayPreviousPickedImage() throws {
        throw skipTest(issueNumber: 150)

        page.addPhoto()
            .tapCloseButton()
            .tapReportBugButton()
            .done()

        snapshotVerifyView()

        page.tapDeleteImageButton().done()
    }

    func testDeleteImage() throws {
        throw skipTest(issueNumber: 150)
        page.addPhoto()
            .tapDeleteImageButton().done()

        snapshotVerifyView()
    }

    func testTypeDescription() {
        page.typeDescription(";)")
            .tapDescriptionLabel()
            .done()

        snapshotVerifyView()
    }

    func testSendReport_shouldRemoveImagesAfterSendReport() throws {
        throw skipTest(issueNumber: 150)
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
