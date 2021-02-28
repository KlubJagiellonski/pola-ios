import Alamofire
import PromiseKit

struct ReadMediaFileError: Error, LocalizedError {
    let path: String

    var errorDescription: String? {
        "Failed read media file at path: \(path)"
    }
}

protocol ReportManager {
    func send(report: Report) -> Promise<Void>
}

final class PolaReportManager: ReportManager {
    private let dataRequestFactory: DataRequestFactory
    private let uploadMediaRequestFactory: MediaUploadRequestFactory
    private let fileManager: FileManager

    init(dataRequestFactory: DataRequestFactory,
         uploadMediaRequestFactory: MediaUploadRequestFactory,
         fileManager: FileManager) {
        self.dataRequestFactory = dataRequestFactory
        self.uploadMediaRequestFactory = uploadMediaRequestFactory
        self.fileManager = fileManager
    }

    func send(report: Report) -> Promise<Void> {
        dataRequestFactory
            .request(path: "create_report",
                     method: .post,
                     parameters: CreateReportRequestBody(report: report),
                     encoding: JSONEncoding())
            .responseDecodable(CreateReportResponseBody.self)
            .then { [uploadMediaRequestFactory] (createReportResponse) -> Promise<Void> in
                let promises =
                    try createReportResponse.signedRequests.enumerated().map { (i, stringUrl) -> Promise<Void> in
                            let mediaPath = report.imagePaths[i]
                            guard let data = self.fileManager.contents(atPath: mediaPath) else {
                                throw ReadMediaFileError(path: mediaPath)
                            }
                            return try uploadMediaRequestFactory.request(url: stringUrl, mediaData: data, mimeType: .png)
                                .responseData()
                                .asVoid()
                        }
                return when(fulfilled: promises).asVoid()
            }
    }
}

private extension CreateReportRequestBody {
    init(report: Report) {
        self.init(productId: report.reason.productId,
                  description: report.description,
                  filesCount: report.imagePaths.count,
                  fileExtension: .png,
                  mimeType: .imagePng)
    }
}
