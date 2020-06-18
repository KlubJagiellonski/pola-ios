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
        case let .product(_, barcode):
            return barcode
        }
    }

    var productId: Int? {
        switch self {
        case let .product(id, _):
            return id
        default:
            return nil
        }
    }
}
