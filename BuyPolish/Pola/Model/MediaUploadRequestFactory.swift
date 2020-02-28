import Alamofire

enum MediaUploadMimeType: String {
    case png = "image/png"
    case jpg = "image/jpeg"
}

protocol MediaUploadRequestFactory {
    func request(url: String, mediaData: Data, mimeType: MediaUploadMimeType) throws -> DataRequest
}

struct InvalidStringUrlError: Error, LocalizedError {
    let url: String
    
    var errorDescription: String? {
        "Invalid string url: \(url)"
    }
}
