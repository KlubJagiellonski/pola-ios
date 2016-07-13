import Foundation
import UIKit

extension FilterImageInfo {
    func toColorRepresentation() -> ColorRepresentation {
        switch type {
        case .Image:
            return ColorRepresentation.ImageUrl(value)
        case .RGB:
            return ColorRepresentation.Color(UIColor(hex: value)!)
        }
    }
}

final class FilterDetailsDataSource: NSObject, UITableViewDataSource {
    private weak var tableView: UITableView?
    var filterItems: [FilterItem] = [] {
        didSet {
            tableView?.reloadData()
        }
    }
    var selectedIds: [Int] = [] {
        didSet {
            guard !oldValue.isEmpty else {
                if !selectedIds.isEmpty {
                    tableView?.reloadData()
                }
                return
            }
            
            var indexPathsToReload: [NSIndexPath] = []
            
            indexPathsToReload.appendContentsOf(selectedIds.filter { !oldValue.contains($0) }.map { id in
                return NSIndexPath(forRow: filterItems.indexOf { $0.id == id }!, inSection: 0)
                })
            indexPathsToReload.appendContentsOf(oldValue.filter { !selectedIds.contains($0) }.map { id in
                return NSIndexPath(forRow: filterItems.indexOf { $0.id == id }!, inSection: 0)
                })
            tableView?.reloadRowsAtIndexPaths(indexPathsToReload, withRowAnimation: .Automatic)
        }
    }
    
    init(with tableView: UITableView) {
        self.tableView = tableView
        super.init()
        
        tableView.registerClass(SelectValueTableViewCell.self, forCellReuseIdentifier: String(SelectValueTableViewCell))
        tableView.registerClass(ImageSelectValueTableViewCell.self, forCellReuseIdentifier: String(ImageSelectValueTableViewCell))
    }
    
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
        } else {
            cell.selectAccessoryType = filterItem.goToEnabled ? .GoTo : .None
        }
        return cell
    }
    
    func isChecked(forIndex indexPath: NSIndexPath) -> Bool {
        let id = filterItems[indexPath.row].id
        return selectedIds.contains(id)
    }
}
