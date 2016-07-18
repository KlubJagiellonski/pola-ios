import Foundation
import UIKit
import SnapKit

protocol SearchViewDelegate: class {
    func search(view: SearchView, didTapSearchWithQuery query: String)
}

final class SearchView: UIView, ExtendedView, UICollectionViewDelegateFlowLayout {
    private let headerView = UIView()
    private let searchBar = UISearchBar()
    private let tabView = SearchTabView()
    private let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    private let dimView = UIView()
    
    private let dataSource: SearchDataSource
    private var topOffsetConstraint: Constraint?
    var extendedContentInset: UIEdgeInsets? {
        didSet {
            let inset = extendedContentInset ?? UIEdgeInsetsZero
            topOffsetConstraint?.updateOffset(inset)
            collectionView.contentInset = UIEdgeInsetsMake(0, 0, inset.bottom, 0)
        }
    }
    var pageHandler: SearchPageHandler? {
        set { dataSource.pageHandler = newValue }
        get { return dataSource.pageHandler }
    }
    weak var delegate: SearchViewDelegate?
    
    init() {
        self.dataSource = SearchDataSource(with: collectionView)
        
        super.init(frame: CGRectZero)
        
        backgroundColor = UIColor(named: .White)
        
        searchBar.showsCancelButton = false
        searchBar.placeholder = tr(.SearchPlaceholder)
        searchBar.delegate = self
        searchBar.applyDefaultStyle()
        
        tabView.selectedIndex = 0
        tabView.searchView = self
        
        collectionView.backgroundColor = UIColor(named: .White)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.pagingEnabled = true
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.scrollDirection = .Horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        dimView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SearchView.didTapDimView)))
        dimView.backgroundColor = UIColor(named: .Dim).colorWithAlphaComponent(0.7)
        dimView.hidden = true
        
        headerView.addSubview(searchBar)
        headerView.addSubview(tabView)
        addSubview(headerView)
        addSubview(collectionView)
        addSubview(dimView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapDimView() {
        searchBar.resignFirstResponder()
    }
    
    func didChangeTab(with index: Int) {
        dataSource.scrollToPage(atIndex: index, animated: true)
    }
    
    func updateData(with tabs: [String]) {
        dataSource.pageCount = tabs.count
        tabView.updateTabs(tabs)
    }
    
    private func configureCustomConstraints() {
        headerView.snp_makeConstraints { make in
            topOffsetConstraint = make.top.equalToSuperview().constraint
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        searchBar.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        tabView.snp_makeConstraints { make in
            make.top.equalTo(searchBar.snp_bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        collectionView.snp_makeConstraints { make in
            make.top.equalTo(tabView.snp_bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        dimView.snp_makeConstraints { make in
            make.top.equalTo(searchBar.snp_bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        guard let selectedIndex = tabView.selectedIndex else { return }
        let scrollPage = Int(floor(scrollView.contentOffset.x / scrollView.bounds.width))
        let scrollPageOffset = (scrollView.contentOffset.x - (CGFloat(scrollPage) * scrollView.bounds.width)) / scrollView.bounds.width
        if scrollPageOffset == 0 {
            tabView.selectedIndex = scrollPage
        } else {
            tabView.indicatorOffsetPercentage = selectedIndex == scrollPage ? scrollPageOffset : (scrollPageOffset - CGFloat(selectedIndex - scrollPage))
        }
    }
}

extension SearchView: UISearchBarDelegate {
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
        delegate?.search(self, didTapSearchWithQuery: query)
    }
}

final class SearchTabView: UIView {
    private var tabButtons: [UIButton] = []
    private let tabIndicator = UIView()
    
    private var indicatorLeftOffsetConstraint: Constraint?
    private var indicatorWidthConstraint: Constraint?
    private var needToUpdateIndicatorOnLayoutPass = false
    private var needToUpdateIndicatorPositionOnLayoutPass = false
    var selectedIndex: Int? {
        didSet {
            self.updateIndicatorPosition()
        }
    }
    var indicatorOffsetPercentage: CGFloat = 0 {
        didSet {
            guard let selectedIndex = selectedIndex else { return }
            indicatorLeftOffsetConstraint?.updateOffset(indicatorOffset(forIndex: selectedIndex, offsetPercentage: indicatorOffsetPercentage))
        }
    }
    weak var searchView: SearchView?
    
    init() {
        super.init(frame: CGRectZero)
        
        tabIndicator.backgroundColor = UIColor(named: .Black)
        
        addSubview(tabIndicator)
        
        configureIndicatorConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if needToUpdateIndicatorOnLayoutPass && bounds.width > 0 && bounds.height > 0 {
            updateIndicator()
            needToUpdateIndicatorOnLayoutPass = false
        }
        if needToUpdateIndicatorPositionOnLayoutPass && bounds.width > 0 && bounds.height > 0 {
            updateIndicatorPosition()
            needToUpdateIndicatorPositionOnLayoutPass = false
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(UIViewNoIntrinsicMetric, 42)
    }
    
    func updateTabs(tabs: [String]) {
        tabButtons.forEach { $0.removeFromSuperview() }
        tabButtons.removeAll()
        
        tabButtons.appendContentsOf(tabs.map(createTabButton))
        tabButtons.forEach { addSubview($0) }
        
        configureTabButtonsConstraints()
        updateIndicator()
    }
    
    func didTapButton(button: UIButton) {
        guard let index = tabButtons.indexOf(button) else { return }
        if index != selectedIndex {
            searchView?.didChangeTab(with: index)
        }
    }
    
    private func updateIndicator() {
        guard !tabButtons.isEmpty else { return }
        
        if bounds.width > 0 && bounds.height > 0 {
            indicatorWidthConstraint?.updateOffset(bounds.width / CGFloat(tabButtons.count))
        } else {
            needToUpdateIndicatorOnLayoutPass = true
        }
    }
    
    private func updateIndicatorPosition() {
        guard !tabButtons.isEmpty else { return }
        guard let selectedIndex = selectedIndex else { return }
        
        if bounds.width > 0 && bounds.height > 0 {
            indicatorLeftOffsetConstraint?.updateOffset(indicatorOffset(forIndex: selectedIndex))
        } else {
            needToUpdateIndicatorPositionOnLayoutPass = true
        }
    }
    
    private func createTabButton(text: String) -> UIButton {
        let button = UIButton()
        button.title = text
        button.titleLabel?.font = UIFont(fontType: .Bold)
        button.setTitleColor(UIColor(named: .Black), forState: .Normal)
        button.addTarget(self, action: #selector(SearchTabView.didTapButton(_:)), forControlEvents: .TouchUpInside)
        return button
    }
    
    private func configureIndicatorConstraints() {
        tabIndicator.snp_makeConstraints { make in
            indicatorLeftOffsetConstraint = make.leading.equalToSuperview().constraint
            make.bottom.equalToSuperview()
            make.height.equalTo(5)
            indicatorWidthConstraint = make.width.equalTo(0).constraint
        }
    }
    
    private func configureTabButtonsConstraints() {
        var lastButton: UIButton?
        for button in tabButtons {
            button.snp_makeConstraints { make in
                make.top.equalToSuperview()
                if let last = lastButton {
                    make.leading.equalTo(last.snp_trailing)
                } else {
                    make.leading.equalToSuperview()
                }
                make.width.equalToSuperview().dividedBy(tabButtons.count)
                make.bottom.equalToSuperview()
            }
            lastButton = button
        }
    }
    
    private func indicatorOffset(forIndex index: Int, offsetPercentage: CGFloat = 0) -> CGFloat {
        let buttonWidth = bounds.width / CGFloat(tabButtons.count)
        let offset = offsetPercentage * buttonWidth
        return buttonWidth * CGFloat(index) + offset
    }
}