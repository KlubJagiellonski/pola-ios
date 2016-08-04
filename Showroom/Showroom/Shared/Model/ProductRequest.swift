import Foundation

struct ProductRequest {
    let paginationInfo: PaginationInfo
    let link: String?
    let filter: [FilterId: [FilterObjectId]]?
}

struct PaginationInfo {
    let page: Int
    let pageSize: Int
}

// MARK:- Encodable

extension ProductRequest: Encodable {
    func encode() -> AnyObject {
        let dict = [
            "pagination": paginationInfo.encode(),
        ] as NSMutableDictionary
        
        if link != nil { dict.setObject(link!, forKey: "link") }
        if filter != nil {
            for (filterId, data) in filter! {
                dict.setObject(data, forKey: filterId)
            }
        }
        return dict
    }
}

extension PaginationInfo: Encodable {
    func encode() -> AnyObject {
        return [
            "page": page,
            "pageSize": pageSize
        ] as NSDictionary
    }
}