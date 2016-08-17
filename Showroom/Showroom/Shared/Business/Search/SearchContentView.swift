import Foundation
import UIKit

protocol SearchContentViewDelegate: class {
    func searchContent(view: SearchContentView, didSelectSearchItem searchItem: SearchItem)
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
        tableView.sectionIndexColor = UIColor(named: .Blue)
        
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
        let searchItem = dataSource.searchItem(forIndexPath: indexPath)
        delegate?.searchContent(self, didSelectSearchItem: searchItem)
    }
}
