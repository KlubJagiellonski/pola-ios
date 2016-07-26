import Foundation
import UIKit

enum FilterRowType: Int {
    case Sort = 0, Category, Size, Color, Price, OnlyDiscounts, Brand
    
    static func rowCount(with filter: Filter) -> Int {
        return filter.brands == nil ? FilterRowType.OnlyDiscounts.rawValue + 1 : FilterRowType.Brand.rawValue + 1
    }
    
    static func rowType(forIndex indexPath: NSIndexPath) -> FilterRowType {
        return FilterRowType(rawValue: indexPath.row)!
    }
}

extension Filter {
    private var selectedSortOptionName: String? {
        let sortOption = sortOptions.find { $0.id == selectedSortOptionId }
        return sortOption?.name
    }
    
    private var selectedCategoryName: String? {
        guard let selectedCategoryId = selectedCategoryIds.last else { return nil }
        let category = findSelectedCategory(forId: selectedCategoryId, categories: categories)
        return category?.name
    }
    
    private func findSelectedCategory(forId id: ObjectId, categories: [FilterCategory]) -> FilterCategory? {
        for category in categories {
            if category.id == id {
                return category
            }
            if category.branches != nil {
                let foundCategory = findSelectedCategory(forId: id, categories: category.branches!)
                if foundCategory != nil {
                    return foundCategory
                }
            }
        }
        return nil
    }
    
    private var selectedSizesName: String? {
        let selectedSizes = selectedSizeIds.map { id in
            return sizes.find { $0.id == id }!
        }
        return createText(fromArray: selectedSizes) { $0.name }
    }
    
    private var selectedColorsName: String? {
        let selectedColors = selectedColorIds.map { id in
            return colors.find { $0.id == id }!
        }
        return createText(fromArray: selectedColors) { $0.name }
    }
    
    private var selectedBrandsName: String? {
        guard let brands = brands else { return nil }
        let selectedBrands = selectedBrandIds.map { id in
            return brands.find { $0.id == id }!
        }
        return createText(fromArray: selectedBrands) { $0.name }
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
    var filter: Filter! {
        didSet {
            tableView?.reloadData()
        }
    }
    
    init(with tableView: UITableView) {
        self.tableView = tableView
        super.init()
        
        tableView.registerClass(ValueTableViewCell.self, forCellReuseIdentifier: String(ValueTableViewCell))
        tableView.registerClass(SwitchValueTableViewCell.self, forCellReuseIdentifier: String(SwitchValueTableViewCell))
        tableView.registerClass(ProductFilterPriceCell.self, forCellReuseIdentifier: String(ProductFilterPriceCell))
        tableView.registerClass(ProductFilterBrandCell.self, forCellReuseIdentifier: String(ProductFilterBrandCell))
    }
    
    func height(forIndex indexPath: NSIndexPath) -> CGFloat {
        let rowType = FilterRowType.rowType(forIndex: indexPath)
        switch rowType {
        case .Sort, .Category, .Size, .Color, .OnlyDiscounts:
            return Dimensions.defaultCellHeight
        case .Price:
            return 80
        case .Brand:
            return ProductFilterBrandCell.height(forWidth: tableView!.bounds.width, andValue: filter.selectedBrandsName)
        }
    }
    
    // MARK:- UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FilterRowType.rowCount(with: filter)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let rowType = FilterRowType.rowType(forIndex: indexPath)
        
        switch rowType {
        case .Sort:
            let cell = tableView.dequeueReusableCellWithIdentifier(String(ValueTableViewCell)) as! ValueTableViewCell
            cell.removeSeparatorInset()
            cell.title = tr(.ProductListFilterRowSort)
            cell.value = filter.selectedSortOptionName
            return cell
        case .Category:
            let cell = tableView.dequeueReusableCellWithIdentifier(String(ValueTableViewCell)) as! ValueTableViewCell
            cell.removeSeparatorInset()
            cell.title = tr(.ProductListFilterRowCategory)
            cell.value = filter.selectedCategoryName
            return cell
        case .Size:
            let cell = tableView.dequeueReusableCellWithIdentifier(String(ValueTableViewCell)) as! ValueTableViewCell
            cell.removeSeparatorInset()
            cell.title = tr(.ProductListFilterRowSize)
            cell.value = filter.selectedSizesName
            return cell
        case .Color:
            let cell = tableView.dequeueReusableCellWithIdentifier(String(ValueTableViewCell)) as! ValueTableViewCell
            cell.removeSeparatorInset()
            cell.title = tr(.ProductListFilterRowColor)
            cell.value = filter.selectedColorsName
            return cell
        case .Price:
            let cell = tableView.dequeueReusableCellWithIdentifier(String(ProductFilterPriceCell.self)) as! ProductFilterPriceCell
            cell.updataData(priceRange: filter.priceRange, selectedPriceRange: filter.selectedPriceRange)
            cell.delegate = self
            return cell
        case .OnlyDiscounts:
            let cell = tableView.dequeueReusableCellWithIdentifier(String(SwitchValueTableViewCell)) as! SwitchValueTableViewCell
            cell.removeSeparatorInset()
            cell.title = tr(.ProductListFilterRowOnlyDiscounts)
            cell.value = filter.onlyDiscountsSelected
            cell.delegate = self
            return cell
        case .Brand:
            let cell = tableView.dequeueReusableCellWithIdentifier(String(ProductFilterBrandCell)) as! ProductFilterBrandCell
            cell.title = tr(.ProductListFilterRowBrand)
            cell.value = filter.selectedBrandsName
            return cell
        }
    }
}

extension ProductFilterDataSource: ProductFilterPriceCellDelegate {
    func filterPrice(cell: ProductFilterPriceCell, didChangeRange range: PriceRange) {
        productFilterView?.didChangePriceRange(range)
    }
}

extension ProductFilterDataSource: SwitchValueTableViewCellDelegate {
    func switchValue(cell: SwitchValueTableViewCell, didChangeValue value: Bool) {
        productFilterView?.didChangePriceDiscount(value)
    }
}