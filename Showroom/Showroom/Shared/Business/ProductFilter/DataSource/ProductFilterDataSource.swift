import Foundation
import UIKit

extension Filter {
    private var selectedChoiceLabels: String? {
        var selectedChoices: [FilterChoice] = []
        for selectedId in data {
            if let choice = choices!.find({ $0.id == selectedId }) {
                selectedChoices.append(choice)
            } else {
                logError("There is no choice for selectedId \(self)")
            }
        }
        
        if let defaultId = defaultId where selectedChoices.isEmpty {
            if let choice = choices!.find({ $0.id == defaultId }) {
                selectedChoices.append(choice)
            } else {
                logError("There is no choice for defaultId \(self)")
            }
        }
        
        return createText(fromArray: selectedChoices) { $0.name }
    }
    
    private var selectedBranchLabels: String? {
        guard data.count > 0 else { return nil }
        let selectedBranches = findSelectedBranches(forIds: data, branches: branches!)
        return createText(fromArray: selectedBranches) { $0.label }
    }
    
    private func findSelectedBranches(forIds ids: [FilterObjectId], branches: [FilterBranch]) -> [FilterBranch] {
        var selectedBranches: [FilterBranch] = []
        for branch in branches {
            if ids.contains(branch.id)  {
                selectedBranches.append(branch)
            }
            let foundBranches = findSelectedBranches(forIds: ids, branches: branch.branches)
            selectedBranches.appendContentsOf(foundBranches)
        }
        return selectedBranches
    }

    private func createText<T>(fromArray array: [T], toStringValue: T -> String) -> String? {
        if array.isEmpty {
            return nil
        }
        let separator = ", "
        let result: String = array.reduce("", combine: {$0 + toStringValue($1) + separator})
        return result.substringToIndex(result.endIndex.advancedBy(-separator.characters.count))
    }
}

class ProductFilterDataSource: NSObject, UITableViewDataSource {
    private weak var tableView: UITableView?
    weak var productFilterView: ProductFilterView?
    var filters: [Filter] = [] {
        didSet {
            tableView?.reloadData()
        }
    }
    
    init(with tableView: UITableView) {
        self.tableView = tableView
        super.init()
        
        tableView.registerClass(ValueTableViewCell.self, forCellReuseIdentifier: String(ValueTableViewCell))
        tableView.registerClass(SwitchValueTableViewCell.self, forCellReuseIdentifier: String(SwitchValueTableViewCell))
        tableView.registerClass(ProductFilterRangeCell.self, forCellReuseIdentifier: String(ProductFilterRangeCell))
        tableView.registerClass(ProductFilterMultipleCell.self, forCellReuseIdentifier: String(ProductFilterMultipleCell))
    }
    
    func height(forIndex indexPath: NSIndexPath) -> CGFloat {
        let filter = filters[indexPath.row]
        switch filter.type {
        case .Choice:
            if filter.multiple {
                return ProductFilterMultipleCell.height(forWidth: tableView!.bounds.width, andValue: filter.selectedChoiceLabels)
            } else {
                return Dimensions.defaultCellHeight
            }
        case .Select:
            return Dimensions.defaultCellHeight
        case .Range:
            return 80
        case .Tree:
            return ProductFilterMultipleCell.height(forWidth: tableView!.bounds.width, andValue: filter.selectedBranchLabels)
        case .Unknown:
            logError("Received unknown type for filter \(filter)")
            return 0
        }
    }
    
    // MARK:- UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let filter = filters[indexPath.row]
        
        switch filter.type {
        case .Choice:
            if filter.multiple {
                let cell = tableView.dequeueReusableCellWithIdentifier(String(ProductFilterMultipleCell), forIndexPath: indexPath) as! ProductFilterMultipleCell
                cell.title = filter.label
                cell.value = filter.selectedChoiceLabels
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(String(ValueTableViewCell), forIndexPath: indexPath) as! ValueTableViewCell
                cell.removeSeparatorInset()
                cell.title = filter.label
                cell.value = filter.selectedChoiceLabels
                return cell
            }
        case .Select:
            let cell = tableView.dequeueReusableCellWithIdentifier(String(SwitchValueTableViewCell), forIndexPath: indexPath) as! SwitchValueTableViewCell
            cell.removeSeparatorInset()
            cell.title = filter.label
            cell.value = filter.data.isEmpty ? false : filter.data[0] == 1
            cell.delegate = self
            return cell
        case .Range:
            let cell = tableView.dequeueReusableCellWithIdentifier(String(ProductFilterRangeCell), forIndexPath: indexPath) as! ProductFilterRangeCell
            cell.title = filter.label
            let selectedValueRange: ValueRange? = filter.data.count == 0 ? nil : ValueRange(min: filter.data[0], max: filter.data[1])
            cell.updataData(valueRange: filter.range!, selectedValueRange: selectedValueRange, step: filter.step!)
            cell.delegate = self
            return cell
        case .Tree:
            let cell = tableView.dequeueReusableCellWithIdentifier(String(ProductFilterMultipleCell), forIndexPath: indexPath) as! ProductFilterMultipleCell
            cell.title = filter.label
            cell.value = filter.selectedBranchLabels
            return cell
        case .Unknown:
            logError("Received unknown type for filter \(filter)")
            return UITableViewCell(style: .Default, reuseIdentifier: "UnknownCell")
        }
    }
}

extension ProductFilterDataSource: ProductFilterRangeCellDelegate {
    func filterRange(cell: ProductFilterRangeCell, didChangeRange range: ValueRange) {
        guard let index = tableView?.indexPathForCell(cell)?.row else { return }
        logInfo("Filter range did change to: \(range)")
        productFilterView?.didChangeValueRange(range, forIndex: index)
    }
}

extension ProductFilterDataSource: SwitchValueTableViewCellDelegate {
    func switchValue(cell: SwitchValueTableViewCell, didChangeValue value: Bool) {
        guard let index = tableView?.indexPathForCell(cell)?.row else { return }
        logInfo("Switch value did change to: \(value)")
        productFilterView?.didChangeSelect(value, forIndex: index)
    }
}