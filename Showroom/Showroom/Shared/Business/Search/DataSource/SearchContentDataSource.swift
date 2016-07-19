import Foundation
import UIKit

extension SearchContentType {
    private var cellClass: AnyClass {
        switch self {
        case .Normal:
            return SelectValueTableViewCell.self
        case .Bold:
            return BoldSelectValueTableViewCell.self
        }
    }
}

enum SearchContentSectionType: Int {
    case Main = 0, Branches
}

final class SearchContentDataSource: NSObject, UITableViewDataSource {
    private weak var tableView: UITableView?
    private let mainSearchItem: SearchItem
    private let type: SearchContentType
    
    init(with tableView: UITableView, type: SearchContentType, mainSearchItem: SearchItem) {
        self.tableView = tableView
        self.mainSearchItem = mainSearchItem
        self.type = type
        super.init()
        
        tableView.registerClass(type.cellClass, forCellReuseIdentifier: String(type.cellClass))
    }
    
    //MARK:- UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = SearchContentSectionType(rawValue: section)!
        switch sectionType {
        case .Main:
            return 1
        case .Branches:
            return mainSearchItem.branches?.count ?? 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let sectionType = SearchContentSectionType(rawValue: indexPath.section)!
        
        let cell = tableView.dequeueReusableCellWithIdentifier(String(type.cellClass)) as! SelectValueTableViewCell
        cell.selectAccessoryType = .GoTo
        switch sectionType {
        case .Main:
            cell.title = tr(.SearchAllSearchItems(mainSearchItem.name))
        case .Branches:
            cell.title = mainSearchItem.branches![indexPath.row].name
        }
        return cell
    }
}