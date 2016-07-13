import Foundation
import UIKit
import RxSwift

extension FilterOption {
    static func from(rowType rowType: FilterRowType) -> FilterOption? {
        switch rowType {
        case .Sort:
            return .Sort
        case .Category:
            return .Category
        case .Size:
            return .Size
        case .Color:
            return .Color
        case .Brand:
            return .Brand
        default:
            return nil
        }
    }
}

protocol ProductFilterViewDelegate: class {
    func productFilterDidTapAccept(view: ProductFilterView)
    func productFilter(view: ProductFilterView, didSelectItem filterOption: FilterOption)
    func productFilter(view: ProductFilterView, didChangePriceRange priceRange: PriceRange)
    func productFilter(view: ProductFilterView, didChangePriceDiscount priceDiscountSelected: Bool)
}

class ProductFilterView: UIView, UITableViewDelegate {
    private let dataSource: ProductFilterDataSource
    weak var delegate: ProductFilterViewDelegate?
    private let disposeBag = DisposeBag()
    
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    private let acceptButton = UIButton()
    
    init(with state: ProductFilterModelState) {
        dataSource = ProductFilterDataSource(with: tableView)
        super.init(frame: CGRectZero)
        
        state.currentFilter.asObservable().subscribeNext { [weak self] filter in
            self?.dataSource.filter = filter
        }.addDisposableTo(disposeBag)
        
        dataSource.productFilterView = self
        
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.separatorColor = UIColor(named: .Separator)
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.extraSeparatorsEnabled = false
        
        acceptButton.applyBlueStyle()
        acceptButton.title = tr(.ProductListFilterShowProducts)
        acceptButton.addTarget(self, action: #selector(ProductFilterView.didTapAccept), forControlEvents: .TouchUpInside)
        
        addSubview(tableView)
        addSubview(acceptButton)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapAccept() {
        delegate?.productFilterDidTapAccept(self)
    }
    
    func updateData(with filter: Filter) {
        dataSource.filter = filter
    }
    
    func deselectRowsIfNeeded() {
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(selectedRow, animated: true)
        }
    }
    
    func didChangePriceRange(value: PriceRange) {
        delegate?.productFilter(self, didChangePriceRange: value)
    }
    
    func didChangePriceDiscount(value: Bool) {
        delegate?.productFilter(self, didChangePriceDiscount: value)
    }
    
    private func configureCustomConstraints() {
        tableView.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(acceptButton.snp_top)
        }
        
        acceptButton.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(Dimensions.bigButtonHeight)
        }
    }
    
    // MARK:- UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let rowType = FilterRowType.rowType(forIndex: indexPath)
        guard let filterItem = FilterOption.from(rowType: rowType) else { return }
        delegate?.productFilter(self, didSelectItem: filterItem)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return dataSource.height(forIndex: indexPath)
    }
}
