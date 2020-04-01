import PromiseKit
import Alamofire

final class CapturedImagesUploadManager {
    private let dataRequestFactory: DataRequestFactory
    private let uploadMediaRequestFactory: MediaUploadRequestFactory

    init(dataRequestFactory: DataRequestFactory, uploadMediaRequestFactory: MediaUploadRequestFactory) {
        self.dataRequestFactory = dataRequestFactory
        self.uploadMediaRequestFactory = uploadMediaRequestFactory
    }

    func send(images: CapturedImages) -> Promise<Void> {
        dataRequestFactory
            .request(path: "add_ai_pics",
                     method: .post,
                     parameters: AddAiPicsRequestBody(capturedImages: images),
                     encoding: JSONEncoding())
        .responseDecodable(AddAiPicsResponseBody.self)
            .then { [uploadMediaRequestFactory] response -> Promise<Void> in
                let promises =
                    try response.signedRequests.enumerated().map { (i, stringUrl) -> Promise<Void> in
                        try uploadMediaRequestFactory.request(url: stringUrl, mediaData: images.dataImages[i], mimeType: .jpg)
                            .responseData()
                            .asVoid()
                }
                return when(fulfilled: promises).asVoid()        }

    }
}

fileprivate extension AddAiPicsRequestBody {
    init(capturedImages: CapturedImages ) {
        self.init(productId: capturedImages.productId,
                  filesCount: capturedImages.dataImages.count,
                  fileExtension: .jpg,
                  mimeType: .imageJpeg,
                  originalWidth: Int(capturedImages.originalSize.width),
                  originalHeight: Int(capturedImages.originalSize.height),
                  width: Int(capturedImages.size.width),
                  height: Int(capturedImages.size.height),
                  deviceName: capturedImages.deviceName)
    }
}

