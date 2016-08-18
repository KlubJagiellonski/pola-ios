import Foundation
import UIKit
import RxSwift

protocol ProductFilterViewDelegate: class {
    func productFilterDidTapAccept(view: ProductFilterView)
    func productFilter(view: ProductFilterView, didSelectItemAtIndex index: Int)
    func productFilter(view: ProductFilterView, didChangeValueRange valueRange: ValueRange, forIndex index: Int)
    func productFilter(view: ProductFilterView, didChangeSelect selected: Bool, forIndex index: Int)
}

class ProductFilterView: ViewSwitcher, UITableViewDelegate {
    private let dataSource: ProductFilterDataSource
    weak var delegate: ProductFilterViewDelegate?
    
    private let contentView = UIView()
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    private let acceptButton = UIButton()
    
    var totalProductsAmount = 0 {
        didSet {
            acceptButton.title = tr(.ProductListFilterShowProducts(String(totalProductsAmount)))
        }
    }
    
    init() {
        dataSource = ProductFilterDataSource(with: tableView)
        super.init(successView: contentView, initialState: .Success)
        
        dataSource.productFilterView = self
        
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.separatorColor = UIColor(named: .Separator)
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.extraSeparatorsEnabled = false
        
        acceptButton.applyBlueStyle()
        acceptButton.addTarget(self, action: #selector(ProductFilterView.didTapAccept), forControlEvents: .TouchUpInside)
        
        contentView.addSubview(tableView)
        contentView.addSubview(acceptButton)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(with filters: [Filter]) {
        dataSource.filters = filters
    }
    
    func didTapAccept() {
        delegate?.productFilterDidTapAccept(self)
    }
    
    func deselectRowsIfNeeded() {
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(selectedRow, animated: true)
        }
    }
    
    func didChangeValueRange(value: ValueRange, forIndex index: Int) {
        delegate?.productFilter(self, didChangeValueRange: value, forIndex: index)
    }
    
    func didChangeSelect(selected: Bool, forIndex index: Int) {
        delegate?.productFilter(self, didChangeSelect: selected, forIndex: index)
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
        delegate?.productFilter(self, didSelectItemAtIndex: indexPath.row)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return dataSource.height(forIndex: indexPath)
    }
}
