import Foundation
import UIKit

protocol FilterDetailsViewDelegate: class {
    func filterDetailsDidTapAccept(view: FilterDetailsView)
    func filterDetails(view: FilterDetailsView, didSelectFilterItemAtIndex index: Int)
}

class FilterDetailsView: UIView, UITableViewDelegate {
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    private let acceptButton = UIButton()
    
    private let dataSource: FilterDetailsDataSource
    weak var delegate: FilterDetailsViewDelegate?
    var filterItems: [FilterItem] {
        set { dataSource.filterItems = newValue }
        get { return dataSource.filterItems }
    }
    var currentSelectedIds: [ObjectId] {
        set { dataSource.selectedIds = newValue }
        get { return dataSource.selectedIds }
    }
    var acceptButtonEnabled: Bool {
        set { acceptButton.enabled = newValue }
        get { return acceptButton.enabled }
    }
    
    init() {
        self.dataSource = FilterDetailsDataSource(with: tableView)
        super.init(frame: CGRectZero)
        
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.separatorStyle = .None
        
        acceptButton.title = tr(.ProductListFilterApply)
        acceptButton.applyBlueStyle()
        acceptButton.addTarget(self, action: #selector(FilterDetailsView.didTapAcceptButton), forControlEvents: .TouchUpInside)
        
        addSubview(tableView)
        addSubview(acceptButton)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapAcceptButton() {
        delegate?.filterDetailsDidTapAccept(self)
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
    
    //MARK:- UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        delegate?.filterDetails(self, didSelectFilterItemAtIndex: indexPath.row)
    }
}
