import Foundation
import UIKit

protocol SearchProductListViewDelegate: ProductListViewDelegate, ViewSwitcherDelegate {
    func searchProductList(view: SearchProductListView, didTapSearchWithQuery query: String)
    func searchProductListDidCancelEditing(view: SearchProductListView)
}

final class SearchProductListView: UIView, ProductListViewInterface, ProductListComponentDelegate {
    private let viewSwitcher: ViewSwitcher
    let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    let searchContainerView: SearchContainerView
    private let searchBar = UISearchBar()
    private let dimView = UIView()
    
    let productListComponent: ProductListComponent
    weak var delegate: ProductListViewDelegate? {
        didSet {
            viewSwitcher.switcherDelegate = searchListDelegate
        }
    }
    weak var searchListDelegate: SearchProductListViewDelegate? {
        return delegate as? SearchProductListViewDelegate
    }
    var switcherState: ViewSwitcherState {
        get { return viewSwitcher.switcherState }
    }
    var queryText: String? {
        set { searchContainerView.searchBar.text = newValue }
        get { return searchContainerView.searchBar.text }
    }
    var searchEnabled: Bool {
        set { searchContainerView.searchBar.userInteractionEnabled = newValue }
        get { return searchContainerView.searchBar.userInteractionEnabled }
    }
    
    init() {
        self.viewSwitcher = ViewSwitcher(successView: collectionView)
        self.searchContainerView = SearchContainerView(with: searchBar)
        productListComponent = ProductListComponent(withCollectionView: collectionView)
        super.init(frame: CGRectZero)
        
        backgroundColor = UIColor(named: .White)
        
        viewSwitcher.switcherDataSource = self
        
        searchBar.applyDefaultStyle()
        searchBar.showsCancelButton = false
        searchBar.delegate = self
        
        dimView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SearchProductListView.didTapDimView)))
        dimView.backgroundColor = UIColor(named: .Dim).colorWithAlphaComponent(0.7)
        dimView.hidden = true
        
        productListComponent.delegate = self
        
        collectionView.applyProductListConfiguration()
        collectionView.delegate = productListComponent
        collectionView.dataSource = productListComponent
        
        addSubview(viewSwitcher)
        addSubview(dimView)
        
        configureCustomConstraints()
    }
    
    func changeSwitcherState(switcherState: ViewSwitcherState, animated: Bool) {
        viewSwitcher.changeSwitcherState(switcherState, animated: animated)
    }
    
    func didTapDimView() {
        searchListDelegate?.searchProductListDidCancelEditing(self)
        searchBar.resignFirstResponder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        viewSwitcher.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dimView.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(Dimensions.navigationBarHeight + Dimensions.statusBarHeight) //Know that this isn't nice, but it is much easier and less code in this situation
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension SearchProductListView: UISearchBarDelegate {
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        guard dimView.hidden else { return false }
        dimView.hidden = false
        dimView.alpha = 0
        UIView.animateWithDuration(0.3) { [unowned self] in
            self.dimView.alpha = 1
        }
        return true
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        dimView.alpha = 1
        UIView.animateWithDuration(0.3, animations: { [unowned self] in
            self.dimView.alpha = 0
        }) { [weak self] _ in
            self?.dimView.hidden = true
        }
        return true
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        searchBar.resignFirstResponder()
        searchListDelegate?.searchProductList(self, didTapSearchWithQuery: query)
    }
}


extension SearchProductListView {
    func productListComponent(component: ProductListComponent, didReceiveScrollEventWithContentOffset contentOffset: CGPoint, contentSize: CGSize) {}
}

extension SearchProductListView: ViewSwitcherDataSource {
    func viewSwitcherWantsErrorView(view: ViewSwitcher) -> UIView? {
        return ErrorView(errorText: tr(.CommonError), errorImage: UIImage(asset: .Error))
    }
    
    func viewSwitcherWantsEmptyView(view: ViewSwitcher) -> UIView? {
        let emptyView = ProductListEmptyView()
        emptyView.descriptionText = tr(.ProductListEmptySearchDescription)
        return emptyView
    }
}

final class SearchContainerView: UIView {
    private let searchBar: UISearchBar
    
    init(with searchBar: UISearchBar) {
        self.searchBar = searchBar
        super.init(frame: searchBar.bounds)
        
        autoresizingMask = .FlexibleWidth
        
        addSubview(searchBar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        searchBar.frame = CGRectMake(-15, 0, self.bounds.width + 15, 44)
    }
    
    override var frame: CGRect {
        didSet {
            let leftPadding: CGFloat = -10
            //that's the only solutions I found for setting custom frame for view in navigation bar
            super.frame = CGRectMake(frame.minX + leftPadding, frame.minY, frame.width - leftPadding, searchBar.bounds.height)
        }
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        return CGSizeMake(600, 300) //some big value to make it full left space wide in navigation bar. Don't know why CGFloat.max doesn't work
    }
}

