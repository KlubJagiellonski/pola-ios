import Foundation
import Decodable

struct SearchResult {
    let rootItems: [SearchItem]
}

struct SearchItem {
    let name: String
    let link: String
    let gender: Gender?
    let branches: [SearchItem]?
}

struct EntrySearchInfo {
    let query: String
}

//MARK:- Decodable, Encodable

extension SearchResult: Decodable, Encodable {
    static func decode(json: AnyObject) throws -> SearchResult {
        let array = json as! [AnyObject]
        return SearchResult(rootItems: try array.map(SearchItem.decode))
    }
    
    func encode() -> AnyObject {
        let encodedList: NSMutableArray = []
        for rootItem in rootItems {
            encodedList.addObject(rootItem.encode())
        }
        return encodedList
    }
}

extension SearchItem: Decodable, Encodable {
    static func decode(json: AnyObject) throws -> SearchItem {
        let gender: String? = try json =>? "gender"
        return try SearchItem(
            name: json => "name",
            link: json => "link",
            gender: gender != nil ? Gender(rawValue: gender!) : nil,
            branches: json =>? "branches"
        )
    }
    
    func encode() -> AnyObject {
        let dict = [
            "name": name,
            "link": link
        ] as NSMutableDictionary
        if branches != nil {
            let branchesArray: NSMutableArray = []
            for branch in branches! {
                branchesArray.addObject(branch.encode())
            }
            dict.setObject(branchesArray, forKey: "branches")
        }
        if gender != nil { dict.setObject(gender!.rawValue, forKey: "gender") }
        return dict
    }
}

//MARK:- Equatable

extension SearchResult: Equatable {}
extension SearchItem: Equatable {}

func ==(lhs: SearchResult, rhs: SearchResult) -> Bool {
    return lhs.rootItems == rhs.rootItems
}

func ==(lhs: SearchItem, rhs: SearchItem) -> Bool {
    return lhs.name == rhs.name && lhs.link == rhs.link && lhs.branches == rhs.branches
}
