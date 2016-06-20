import UIKit

class CheckoutDeliveryView: UIView, UITableViewDelegate {
    
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    private let dataSource: CheckoutDeliveryDataSource
    
    weak var delegate: ProductColorViewDelegate?
    
    init() {
        dataSource = CheckoutDeliveryDataSource(tableView: tableView, delivery: .Kiosk)
        super.init(frame: CGRectZero)
        
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .None
        addSubview(tableView)
        
        configureCustomCostraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCustomCostraints() {
        tableView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}