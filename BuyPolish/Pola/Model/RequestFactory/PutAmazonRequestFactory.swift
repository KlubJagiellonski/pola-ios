import Alamofire

final class PutAmazonRequestFactory: MediaUploadRequestFactory {
    func request(url stringUrl: String, mediaData: Data, mimeType: MediaUploadMimeType) throws -> DataRequest {
        guard let url = URL(string: stringUrl) else {
            throw InvalidStringUrlError(url: stringUrl)
        }
        var request = URLRequest(url: url)
        request.addValue(mimeType.rawValue, forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.put.rawValue
        request.httpBody = mediaData
        return Alamofire.request(request)
    }
}
