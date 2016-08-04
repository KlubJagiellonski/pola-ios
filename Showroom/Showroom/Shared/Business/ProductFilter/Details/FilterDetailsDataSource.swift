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
    private weak var tableView: UITableView?
    private var filterItems: [FilterItem] = []
    private var selectedIds: [FilterObjectId] = []
    private var loadingItemIndex: Int?
    
    init(with tableView: UITableView) {
        self.tableView = tableView
        super.init()
        
        tableView.registerClass(SelectValueTableViewCell.self, forCellReuseIdentifier: String(SelectValueTableViewCell))
        tableView.registerClass(ImageSelectValueTableViewCell.self, forCellReuseIdentifier: String(ImageSelectValueTableViewCell))
    }
    
    func updateData(with filterItems: [FilterItem], selectedIds: [FilterObjectId], loadingItemIndex: Int?) {
        self.filterItems = filterItems
        self.selectedIds = selectedIds
        self.loadingItemIndex = loadingItemIndex
        tableView?.reloadData()
        return
    }
    
    func updateData(withLoadingItemIndex loadingItemIndex: Int?) {
        self.loadingItemIndex = loadingItemIndex
        tableView?.reloadData()
    }
    
    func updateData(withSelectedIds selectedIds: [FilterObjectId]) {
        self.selectedIds = selectedIds
        tableView?.reloadData()
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
        if loadingItemIndex == indexPath.row {
            cell.selectAccessoryType = .Loading
        } else if isChecked(forIndex: indexPath) {
            cell.selectAccessoryType = .Checkmark
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
