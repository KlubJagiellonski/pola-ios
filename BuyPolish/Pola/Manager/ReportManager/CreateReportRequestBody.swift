import Foundation

struct CreateReportRequestBody : Encodable {
    let productId: Int?
    let description: String?
    let filesCount: Int
    let fileExtension: FileExtension
    let mimeType: MimeType
    
    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case description
        case filesCount = "files_count"
        case fileExtension = "mime_type"
        case mimeType = "file_ext"
    }
    
    enum FileExtension: String, Encodable {
        case png
    }
    
    enum MimeType: String, Encodable {
        case imagePng = "image/png"
    }
}

