import Foundation
import UIKit

protocol SearchContentViewDelegate: class {
    func searchContentDidSelectMainSearchItem(view: SearchContentView)
    func searchContent(view: SearchContentView, didSelectSearchItemAtIndex index: Int)
}

final class SearchContentView: UIView, UITableViewDelegate {
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    
    private let dataSource: SearchContentDataSource
    weak var delegate: SearchContentViewDelegate?
    
    init(with mainSearchItem: SearchItem, contentType: SearchContentType) {
        dataSource = SearchContentDataSource(with: tableView, type: contentType, mainSearchItem: mainSearchItem)
        super.init(frame: CGRectZero)
        
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.separatorStyle = .None
        
        addSubview(tableView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func deselectRowsIfNeeded() {
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(selectedRow, animated: true)
        }
    }
    
    private func configureCustomConstraints() {
        tableView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK:- UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sectionType = dataSource.section(forIndexPath: indexPath)
        switch sectionType {
        case .Main:
            delegate?.searchContentDidSelectMainSearchItem(self)
        case .Branches:
            delegate?.searchContent(self, didSelectSearchItemAtIndex: indexPath.row)
        }
    }
}
