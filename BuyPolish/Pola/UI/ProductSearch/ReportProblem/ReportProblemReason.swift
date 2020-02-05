import Foundation

enum ReportProblemReason {
    case general
    case product(Int, String)
}

extension ReportProblemReason {
    var barcode: String? {
        switch self {
        case .general:
            return nil
        case .product(_, let barcode):
            return barcode
        }
    }
    
    var productId: Int? {
        switch self {
        case .product(let id, _):
            return id
        default:
            return nil
        }
    }
}
