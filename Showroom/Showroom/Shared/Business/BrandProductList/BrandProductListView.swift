import UIKit

protocol BrandProductListViewDelegate: ProductListViewDelegate, ViewSwitcherDelegate {
    func brandProductListDidTapBrandInfo(view: BrandProductListView)
    func brandProductList(view: BrandProductListView, didTapVideoAtIndex index: Int)
}

class BrandProductListView: ViewSwitcher, ProductListViewInterface, ProductListComponentDelegate {
    let productListComponent: ProductListComponent
    let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    weak var delegate: ProductListViewDelegate? {
        didSet {
            switcherDelegate = brandListDelegate
        }
    }
    weak var brandListDelegate: BrandProductListViewDelegate? {
        return delegate as? BrandProductListViewDelegate
    }
    var headerImageWidth: Int {
        return headerCell?.imageWidth ?? 0
    }
    private weak var headerCell: BrandHeaderCell?
    
    init() {
        productListComponent = ProductListComponent(withCollectionView: collectionView)
        super.init(successView: collectionView)
        
        backgroundColor = UIColor(named: .White)
        
        switcherDataSource = self
        
        let headerCell = BrandHeaderCell()
        headerCell.productListView = self
        productListComponent.delegate = self
        productListComponent.headerSectionInfo = HeaderSectionInfo(view: headerCell, wantsToReceiveScrollEvents: false) { [weak self] in
            return self?.headerCell?.intrinsicContentSize().height ?? 0
        }
        self.headerCell = headerCell
        
        collectionView.applyProductListConfiguration()
        collectionView.delegate = productListComponent
        collectionView.dataSource = productListComponent
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateBrandInfo(with brand: BrandDetails, description: NSAttributedString) {
        headerCell?.updateData(with: brand, description: description)
    }
    
    func videoImageTag(forIndex index: Int) -> Int? {
        return headerCell?.videoImageTag(forIndex: index)
    }

    func didTapBrandInfo() {
        brandListDelegate?.brandProductListDidTapBrandInfo(self)
    }

    func didTapVideo(atIndex index: Int) {
        brandListDelegate?.brandProductList(self, didTapVideoAtIndex: index)
    }
}

extension BrandProductListView {
    func productListComponent(component: ProductListComponent, didReceiveScrollEventWithContentOffset contentOffset: CGPoint, contentSize: CGSize) {}
}

extension BrandProductListView: ViewSwitcherDataSource {
    func viewSwitcherWantsErrorView(view: ViewSwitcher) -> UIView? {
        return ErrorView(errorText: tr(.CommonError), errorImage: UIImage(asset: .Error))
    }
    
    func viewSwitcherWantsEmptyView(view: ViewSwitcher) -> UIView? {
        let emptyView = ProductListEmptyView()
        emptyView.descriptionText = tr(.ProductListEmptyDescription)
        return emptyView
    }
}
