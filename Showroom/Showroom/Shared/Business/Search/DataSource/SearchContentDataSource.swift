import Foundation
import UIKit

extension SearchContentType {
    private var cellClass: AnyClass {
        switch self {
        case .Normal, .Tree:
            return SelectValueTableViewCell.self
        case .BoldTree:
            return BoldSelectValueTableViewCell.self
        }
    }
}

enum SearchContentSectionType: Int {
    case Main = 0, Branches
    
    static func sectionType(forSection section: Int, mainSearchItemContainsLink: Bool) -> SearchContentSectionType {
        if mainSearchItemContainsLink && section == 0 {
            return SearchContentSectionType.Main
        } else {
            return SearchContentSectionType.Branches
        }
    }
    
    static func sectionType(forSection section: Int) -> SearchContentSectionType {
        if section == 0 {
            return SearchContentSectionType.Main
        } else {
            return SearchContentSectionType.Branches
        }
    }
}

final class SearchContentDataSource: NSObject, UITableViewDataSource {
    private weak var tableView: UITableView?
    private let mainSearchItem: SearchItem
    private let type: SearchContentType
    private let indexable: Bool
    private let indexedBranches: Dictionary<String, [SearchItem]>?
    private let sectionIndexTitles: [String]?
    
    init(with tableView: UITableView, type: SearchContentType, mainSearchItem: SearchItem) {
        self.tableView = tableView
        self.mainSearchItem = mainSearchItem
        self.type = type
        self.indexable = mainSearchItem.indexable
        if self.indexable {
            self.indexedBranches = mainSearchItem.branches?.createIndexes { $0.name }
            self.sectionIndexTitles = indexedBranches?.keys.sort { $0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending }
        } else {
            self.indexedBranches = nil
            self.sectionIndexTitles = nil
        }
        super.init()
        
        tableView.registerClass(type.cellClass, forCellReuseIdentifier: String(type.cellClass))
    }
    
    func searchItem(forIndexPath indexPath: NSIndexPath) -> SearchItem {
        if section(forIndexPath: indexPath) == .Main {
            return mainSearchItem
        }
        
        if indexedBranches != nil && sectionIndexTitles != nil {
            let index = indexPath.section - (mainSearchItem.link == nil ? 0 : 1)
            let title = sectionIndexTitles![index]
            let searchItem = indexedBranches![title]![indexPath.row]
            return searchItem
        } else {
            return mainSearchItem.branches![indexPath.row]
        }
    }
    
    private func section(forIndexPath indexPath: NSIndexPath) -> SearchContentSectionType {
        return SearchContentSectionType.sectionType(forSection: indexPath.section, mainSearchItemContainsLink: mainSearchItem.link != nil)
    }
    
    //MARK:- UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (self.indexable ? indexedBranches!.keys.count : 1) + (mainSearchItem.link == nil ? 0 : 1)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = SearchContentSectionType.sectionType(forSection: section, mainSearchItemContainsLink: mainSearchItem.link != nil)
        switch sectionType {
        case .Main:
            return 1
        case .Branches:
            if indexable {
                let indexLetter = sectionIndexTitles![section - (mainSearchItem.link == nil ? 0 : 1)]
                return indexedBranches![indexLetter]?.count ?? 0
            } else {
                return mainSearchItem.branches?.count ?? 0
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let sectionType = SearchContentSectionType.sectionType(forSection: indexPath.section, mainSearchItemContainsLink: mainSearchItem.link != nil)
        
        let cell = tableView.dequeueReusableCellWithIdentifier(String(type.cellClass)) as! SelectValueTableViewCell
        cell.selectAccessoryType = .GoTo
        switch sectionType {
        case .Main:
            cell.title = tr(.SearchAllSearchItems(mainSearchItem.name))
            cell.leftOffset = Dimensions.defaultMargin
        case .Branches:
            var searchItem: SearchItem!
            if indexable {
                let indexLetter = sectionIndexTitles![indexPath.section - (mainSearchItem.link == nil ? 0 : 1)]
                searchItem = indexedBranches![indexLetter]?[indexPath.row]
            } else {
                searchItem = mainSearchItem.branches![indexPath.row]
            }
            
            cell.title = searchItem.name
            cell.leftOffset = type == .Normal ? Dimensions.defaultMargin : 35
        }
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !self.indexable {
            return nil
        }
        
        let index = section - (mainSearchItem.link == nil ? 0 : 1)
        if index < 0 {
            return nil
        }
        let indexLetter = sectionIndexTitles![index]
        return indexLetter
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return sectionIndexTitles
    }
}