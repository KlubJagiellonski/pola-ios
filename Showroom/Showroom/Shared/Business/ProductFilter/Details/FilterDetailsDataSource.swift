import Foundation
import UIKit

extension FilterImageInfo {
    private func toColorRepresentation() -> ColorRepresentation {
        switch type {
        case .Image:
            return ColorRepresentation.ImageUrl(value)
        case .RGB:
            return ColorRepresentation.Color(UIColor(hex: value)!)
        case .Unknown:
            logError("Cannot create color representation for filterImageInfo \(self)")
            return ColorRepresentation.Color(UIColor.whiteColor())
        }
    }
}

extension FilterItem {
    private var titleFont: UIFont {
        switch type {
        case .Default:
            return UIFont(fontType: .Normal)
        case .Bold:
            return UIFont(fontType: .FormBold)
        }
    }
    private var insetValue: CGFloat {
        switch inset {
        case .Default:
            return Dimensions.defaultMargin
        case .Big:
            return 35
        }
    }
}

final class FilterDetailsDataSource: NSObject, UITableViewDataSource {
    private let indexableItemsThreshold = 24
    
    private weak var tableView: UITableView?
    private var filterItems: [FilterItem] = []
    private var selectedIds: [FilterObjectId] = []
    private var loadingItemIndex: Int?
    private var indexable: Bool { return indexedItems != nil && sectionIndexTitles != nil }
    private var indexedItems: Dictionary<String, [FilterItem]>?
    private var sectionIndexTitles: [String]?
    
    
    init(with tableView: UITableView) {
        self.tableView = tableView
        super.init()
        
        tableView.registerClass(SelectValueTableViewCell.self, forCellReuseIdentifier: String(SelectValueTableViewCell))
        tableView.registerClass(ImageSelectValueTableViewCell.self, forCellReuseIdentifier: String(ImageSelectValueTableViewCell))
    }
    
    func updateData(with filterItems: [FilterItem], selectedIds: [FilterObjectId], loadingItemIndex: Int?, indexable: Bool) {
        self.filterItems = filterItems
        self.selectedIds = selectedIds
        self.loadingItemIndex = loadingItemIndex
        
        if indexable && filterItems.count > indexableItemsThreshold {
            self.indexedItems = filterItems.createIndexes { $0.name }
            self.sectionIndexTitles = indexedItems?.keys.sort { $0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending }
        } else {
            self.indexedItems = nil
            self.sectionIndexTitles = nil
        }
        
        tableView?.reloadData()
        return
    }
    
    func updateData(withLoadingItemIndex loadingItemIndex: Int?) {
        if loadingItemIndex != nil && indexable {
            fatalError("FilterDetailsDataSource does not work with loadingItemIndex and indexable")
        }
        self.loadingItemIndex = loadingItemIndex
        tableView?.reloadData()
    }
    
    func updateData(withSelectedIds selectedIds: [FilterObjectId]) {
        self.selectedIds = selectedIds
        tableView?.reloadData()
    }
    
    func filterItem(forIndexPath indexPath: NSIndexPath) -> FilterItem {
        if indexable {
            let index = indexPath.section
            let title = sectionIndexTitles![index]
            let filterItem = indexedItems![title]![indexPath.row]
            return filterItem
        } else {
            return filterItems[indexPath.row]
        }
    }
    
    // MARK:- UITableVIewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.indexable ? sectionIndexTitles!.count : 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if indexable {
            let indexLetter = sectionIndexTitles![section]
            return indexedItems![indexLetter]?.count ?? 0
        } else {
            return filterItems.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var filterItem: FilterItem!
        if indexable {
            let indexLetter = sectionIndexTitles![indexPath.section]
            filterItem = indexedItems![indexLetter]?[indexPath.row]
        } else {
            filterItem = filterItems[indexPath.row]
        }
        
        let cellIdentifier = filterItem.imageInfo == nil ? String(SelectValueTableViewCell) : String(ImageSelectValueTableViewCell)
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! SelectValueTableViewCell
        cell.title = filterItem.name
        if let imageInfo = filterItem.imageInfo {
            cell.setColorRepresentation(imageInfo.toColorRepresentation())
        }
        if loadingItemIndex == indexPath.row {
            cell.selectAccessoryType = .Loading
        } else if selectedIds.contains(filterItem.id) {
            cell.selectAccessoryType = .Checkmark
        } else {
            cell.selectAccessoryType = .None
        }
        cell.titleFont = filterItem.titleFont
        cell.leftOffset = filterItem.insetValue
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !self.indexable {
            return nil
        }
        
        return sectionIndexTitles![section]
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return sectionIndexTitles
    }
}
