import Foundation
import UIKit

extension FilterImageInfo {
    private func toColorRepresentation() -> ColorRepresentation {
        switch type {
        case .Image:
            return ColorRepresentation.ImageUrl(value)
        case .RGB:
            return ColorRepresentation.Color(UIColor(hex: value)!)
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
    private weak var tableView: UITableView?
    private var filterItems: [FilterItem] = []
    private var selectedIds: [Int] = []
    private var loadingItemIndex: Int?
    
    init(with tableView: UITableView) {
        self.tableView = tableView
        super.init()
        
        tableView.registerClass(SelectValueTableViewCell.self, forCellReuseIdentifier: String(SelectValueTableViewCell))
        tableView.registerClass(ImageSelectValueTableViewCell.self, forCellReuseIdentifier: String(ImageSelectValueTableViewCell))
    }
    
    func updateData(with filterItems: [FilterItem], selectedIds: [ObjectId], loadingItemIndex: Int?) {
        guard !self.filterItems.isEmpty else {
            self.filterItems = filterItems
            self.selectedIds = selectedIds
            self.loadingItemIndex = loadingItemIndex
            tableView?.reloadData()
            return
        }
        
        let oldFilterItems = self.filterItems
        self.filterItems = filterItems
        self.selectedIds = selectedIds
        self.loadingItemIndex = loadingItemIndex
        
        var deleteIndexPaths: [NSIndexPath] = []
        var insertIndexPaths: [NSIndexPath] = []
        var reloadIndexPaths: [NSIndexPath] = []
        
        for (index, oldFilterItem) in oldFilterItems.enumerate() {
            if !filterItems.contains({ $0.id == oldFilterItem.id }) {
                deleteIndexPaths.append(NSIndexPath(forRow: index, inSection: 0))
            } else {
                reloadIndexPaths.append(NSIndexPath(forRow: index, inSection: 0))
            }
        }
        
        for (index, newFilterItem) in filterItems.enumerate() {
            if !oldFilterItems.contains({ $0.id == newFilterItem.id }) {
                insertIndexPaths.append(NSIndexPath(forRow: index, inSection: 0))
            }
        }
        
        if deleteIndexPaths.isEmpty && insertIndexPaths.isEmpty && reloadIndexPaths.isEmpty {
            return
        }
        
        tableView?.beginUpdates()
        tableView?.deleteRowsAtIndexPaths(deleteIndexPaths, withRowAnimation: .Automatic)
        tableView?.reloadRowsAtIndexPaths(reloadIndexPaths, withRowAnimation: .None)
        tableView?.insertRowsAtIndexPaths(insertIndexPaths, withRowAnimation: .Automatic)
        tableView?.endUpdates()
    }
    
    func updateData(withLoadingItemIndex loadingItemIndex: Int?) {
        let oldValue = self.loadingItemIndex
        self.loadingItemIndex = loadingItemIndex
        
        var indexPathsToReload: [NSIndexPath] = []
        if let oldValue = oldValue {
            indexPathsToReload.append(NSIndexPath(forRow: oldValue, inSection: 0))
        }
        if let newValue = loadingItemIndex {
            indexPathsToReload.append(NSIndexPath(forRow: newValue, inSection: 0))
        }
        
        guard !indexPathsToReload.isEmpty else { return }
        
        tableView?.reloadRowsAtIndexPaths(indexPathsToReload, withRowAnimation: .Automatic)
    }
    
    func updateData(withSelectedIds selectedIds: [Int]) {
        var indexPathsToReload: [NSIndexPath] = []
        
        let oldValue = self.selectedIds
        self.selectedIds = selectedIds
        
        indexPathsToReload.appendContentsOf(selectedIds.filter { !oldValue.contains($0) }.map { id in
            return NSIndexPath(forRow: filterItems.indexOf { $0.id == id }!, inSection: 0)
            })
        indexPathsToReload.appendContentsOf(oldValue.filter { !selectedIds.contains($0) }.map { id in
            return NSIndexPath(forRow: filterItems.indexOf { $0.id == id }!, inSection: 0)
            })
        
        guard !indexPathsToReload.isEmpty else { return }
        
        tableView?.reloadRowsAtIndexPaths(indexPathsToReload, withRowAnimation: .Automatic)
    }
    
    // MARK:- UITableVIewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let filterItem = filterItems[indexPath.row]
        let cellIdentifier = filterItem.imageInfo == nil ? String(SelectValueTableViewCell) : String(ImageSelectValueTableViewCell)
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! SelectValueTableViewCell
        cell.title = filterItem.name
        if let imageInfo = filterItem.imageInfo {
            cell.setColorRepresentation(imageInfo.toColorRepresentation())
        }
        if isChecked(forIndex: indexPath) {
            cell.selectAccessoryType = .Checkmark
        } else if loadingItemIndex == indexPath.row {
            cell.selectAccessoryType = .Loading
        } else {
            cell.selectAccessoryType = .None
        }
        cell.titleFont = filterItem.titleFont
        cell.leftOffset = filterItem.insetValue
        return cell
    }
    
    func isChecked(forIndex indexPath: NSIndexPath) -> Bool {
        let id = filterItems[indexPath.row].id
        return selectedIds.contains(id)
    }
}
