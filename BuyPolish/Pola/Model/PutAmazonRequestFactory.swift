import Alamofire

class PutAmazonRequestFactory: MediaUploadRequestFactory {
    
    private let fileManager: FileManager
    
    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }

    func request(url: String, mediaPath: String) throws -> DataRequest {
        guard let url = URL(string: url),
            let data = self.fileManager.contents(atPath: mediaPath) else {
            throw ReadMediaFileError(path: mediaPath)
        }
        var request = URLRequest(url: url)
        request.addValue("public-read",forHTTPHeaderField: "x-amx-acl")
        request.addValue("image/png",forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.put.rawValue
        request.httpBody = data
        return Alamofire.request(request)
    }

}
