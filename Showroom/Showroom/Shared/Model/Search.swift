import Foundation

struct SearchResult {
    let rootItems: [SearchItem]
}

struct SearchItem {
    let name: String
    let link: String
    let branches: [SearchItem]?
}

struct EntrySearchInfo {
    let query: String
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
