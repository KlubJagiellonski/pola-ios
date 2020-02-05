import Alamofire

protocol MediaUploadRequestFactory {
    func request(url: String, mediaPath: String) throws -> DataRequest
}

struct ReadMediaFileError: Error, LocalizedError {
    let path: String
    
    var errorDescription: String? {
        "Failed read media file at path: \(path)"
    }
}
