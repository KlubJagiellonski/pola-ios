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
        //TODO:- remove mainSearchItem.branches?.count > 100 when api will be done (https://github.com/shwrm/iosproxy/issues/129)
        self.indexable = mainSearchItem.indexable ? true : mainSearchItem.branches?.count > 100
        if self.indexable {
            self.indexedBranches = SearchContentDataSource.createIndex(for: mainSearchItem.branches)
            self.sectionIndexTitles = indexedBranches?.keys.sort()
        } else {
            self.indexedBranches = nil
            self.sectionIndexTitles = nil
        }
        super.init()
        
        tableView.registerClass(type.cellClass, forCellReuseIdentifier: String(type.cellClass))
    }
    
    func section(forIndexPath indexPath: NSIndexPath) -> SearchContentSectionType {
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
        case .Branches:
            if indexable {
                let indexLetter = sectionIndexTitles![indexPath.section - (mainSearchItem.link == nil ? 0 : 1)]
                cell.title = indexedBranches![indexLetter]?[indexPath.row].name
            } else {
                cell.title = mainSearchItem.branches![indexPath.row].name
            }
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
    
    class func createIndex(for branches: [SearchItem]?) -> Dictionary<String, [SearchItem]> {
        var index = Dictionary<String, [SearchItem]>()
        
        guard let branches = branches else {
            return index
        }
        
        for item in branches {
            if item.name.characters.count == 0 {
                continue
            }
            let indexLetter = String(item.name.characters.first!).uppercaseString
            if index.keys.contains(indexLetter) {
                index[indexLetter]?.append(item)
            } else {
                index[indexLetter] = [item]
            }
        }
        
        logInfo(String(index.keys.first))
        
        return index
    }
}