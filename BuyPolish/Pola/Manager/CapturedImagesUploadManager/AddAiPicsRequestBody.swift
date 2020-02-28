import Foundation

struct AddAiPicsRequestBody: Encodable {
    let productId: Int
    let filesCount: Int
    let fileExtension: FileExtension
    let mimeType: MimeType
    let originalWidth: Int
    let originalHeight: Int
    let width: Int
    let height: Int
    let deviceName: String
    
    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case filesCount = "files_count"
        case fileExtension = "file_ext"
        case originalWidth = "original_width"
        case originalHeight = "original_height"
        case width
        case height
        case deviceName = "device_name"
    }
    
    enum FileExtension: String, Encodable {
        case jpg
    }
    
    enum MimeType: String, Encodable {
        case imageJpeg = "image/jpeg"
    }
    
}
