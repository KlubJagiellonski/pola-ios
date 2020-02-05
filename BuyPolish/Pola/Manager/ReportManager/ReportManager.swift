import PromiseKit
import Alamofire

class ReportManager {
    
    private let dataRequestFactory: DataRequestFactory
    private let uploadMediaRequestFactory: MediaUploadRequestFactory
    
    init(dataRequestFactory: DataRequestFactory, uploadMediaRequestFactory: MediaUploadRequestFactory) {
        self.dataRequestFactory = dataRequestFactory
        self.uploadMediaRequestFactory = uploadMediaRequestFactory
    }
    
    func send(report: Report) -> Promise<Void>{
        dataRequestFactory
            .request(path: "create_report",
                     method: .post,
                     parameters: CreateReportRequestBody(report: report),
                     encoding: JSONEncoding())
            .responseDecodable(CreateReportResponseBody.self)
            .then { [uploadMediaRequestFactory](createReportResponse) -> Promise<Void>  in
                let promises =
                    try createReportResponse.signedRequests.enumerated().map { (i, stringUrl) -> Promise<Void> in
                        try uploadMediaRequestFactory.request(url: stringUrl, mediaPath: report.imagePaths[i])
                            .responseData()
                            .asVoid()
                }
                return when(fulfilled: promises).asVoid()
        }
        
    }
}

fileprivate extension CreateReportRequestBody {
    init(report: Report ) {
        self.init(productId: report.reason.productId,
                  description: report.description,
                  filesCount: report.imagePaths.count,
                  fileExtension: .png,
                  mimeType: .imagePng)
    }
}
