import UIKit

protocol WishlistViewDelegate: ViewSwitcherDelegate {
    func wishlistView(view: WishlistView, wantsDelete product: ListProduct)
    func wishlistView(view: WishlistView, didSelectProductAt indexPath: NSIndexPath)
}

final class WishlistView: ViewSwitcher, UITableViewDelegate {
    private let dataSource: WishlistDataSource
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    
    weak var delegate: WishlistViewDelegate? {
        didSet { switcherDelegate = delegate }
    }
    
    init() {
        dataSource = WishlistDataSource(tableView: tableView)
        super.init(successView: tableView)
        
        dataSource.delegate = self
        switcherDataSource = self
        
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.separatorStyle = .None
        tableView.contentInset = UIEdgeInsetsMake(Dimensions.statusBarHeight + Dimensions.navigationBarHeight, 0, Dimensions.tabViewHeight, 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMoveToWindow(newWindow: UIWindow?) {
        super.willMoveToWindow(newWindow)
        if let selectedRow = tableView.indexPathForSelectedRow where newWindow != nil {
            tableView.deselectRowAtIndexPath(selectedRow, animated: true)
        }
    }
    
    func updateData(with products: [ListProduct]) {
        dataSource.updateData(with: products)
    }
    
    // MARK:- UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return WishlistCell.cellHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.wishlistView(self, didSelectProductAt: indexPath)
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return tr(.WishlistDelete)
    }
}

extension WishlistView: ViewSwitcherDataSource {
    func viewSwitcherWantsErrorInfo(view: ViewSwitcher) -> (ErrorText, ErrorImage?) {
        return (tr(.CommonError), nil)
    }
    func viewSwitcherWantsEmptyView(view: ViewSwitcher) -> UIView? {
        let emptyView = WishlistEmptyView(contentInset: tableView.contentInset)
        return emptyView
    }
}

extension WishlistView: WishlistDataSourceDelegate {
    func wishlistDataSource(dataSource: WishlistDataSource, wantsDelete product: ListProduct) {
        delegate?.wishlistView(self, wantsDelete: product)
    }
}

final class WishlistEmptyView: UIView {
    private let label = UILabel()
    private let doubleTapAnimation = OnboardingDoubleTapAnimation()
    
    init(contentInset: UIEdgeInsets) {
        super.init(frame: CGRectZero)
        
        label.text = tr(L10n.WishlistEmptyDescription)
        label.font = UIFont(fontType: .Onboarding)
        label.numberOfLines = 0
        label.textAlignment = .Center
        label.lineBreakMode = .ByWordWrapping
        
        addSubview(label)
        addSubview(doubleTapAnimation)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        label.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(94)
            make.left.equalToSuperview().inset(24)
            make.right.equalToSuperview().inset(24)
        }
        
        doubleTapAnimation.snp_makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(181.2, 0, 0, 0))
        }
    }
    
    override func willMoveToWindow(newWindow: UIWindow?) {
        super.willMoveToWindow(newWindow)
        doubleTapAnimation.animating = newWindow !== nil
    }
}
