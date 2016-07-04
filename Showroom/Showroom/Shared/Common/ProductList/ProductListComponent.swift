import Foundation
import UIKit

enum NextPageState {
    case Fetching
    case LastPage
    case Error
}

enum ProductListSection: Int {
    case Products = 0, NextPage
    
    static func isNextPageSection(section: Int) -> Bool {
        return section == ProductListSection.NextPage.rawValue
    }
    static func sectionCount(forNextPageState state: NextPageState) -> Int {
        switch state {
        case .Fetching, .Error:
            return ProductListSection.NextPage.rawValue + 1
        default:
            return ProductListSection.Products.rawValue + 1
        }
    }
}

protocol ProductListComponentDelegate: class {
    func productListComponentWillDisplayNextPage(component: ProductListComponent)
    func productListComponentDidTapRetryPage(component: ProductListComponent)
    func productListComponent(component: ProductListComponent, didTapProduct product: ListProduct)
    func productListComponent(component: ProductListComponent, didDoubleTapProduct product: ListProduct)
}

class ProductListComponent: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ProductItemCellDelegate {
    private let minItemWidth: CGFloat = 120
    private let interItemSpacing: CGFloat = 10
    private let itemTitleHeight: CGFloat = 62
    
    private var informedAboutNextPage = false
    private var products: [ListProduct] = []
    private weak var collectionView: UICollectionView?
    weak var delegate: ProductListComponentDelegate?
    
    private lazy var itemSize: CGSize = { [unowned self] in
        guard let collectionView = self.collectionView else {
            logError("Cannot calculate itemSize when collectionView is nil")
            return CGSizeMake(0, 0)
        }
        guard collectionView.bounds.width > 0 else {
            logError("Cannot calculate itemSize when collectionView bounds == 0")
            return CGSizeMake(0, 0)
        }
        
        let columnWidthFor3Columns = floor((collectionView.bounds.width - Dimensions.defaultMargin * 2 - self.interItemSpacing * 2) / 3)
        let columnWidthFor2Columns = floor((collectionView.bounds.width - Dimensions.defaultMargin * 2 - self.interItemSpacing) / 2)
        let itemWidth = columnWidthFor3Columns > self.minItemWidth ? columnWidthFor3Columns : columnWidthFor2Columns
        let imageHeight = itemWidth / CGFloat(Dimensions.defaultImageRatio)
        let itemHeight = ceil(imageHeight + self.itemTitleHeight)
        return CGSizeMake(itemWidth, itemHeight)
    }()
    
    var nextPageState: NextPageState = .LastPage
    
    init(withCollectionView collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        
        collectionView.registerClass(ProductItemCell.self, forCellWithReuseIdentifier: String(ProductItemCell))
        collectionView.registerClass(ProductLoadingPageCell.self, forCellWithReuseIdentifier: String(ProductLoadingPageCell))
        collectionView.registerClass(ProductErrorPageCell.self, forCellWithReuseIdentifier: String(ProductErrorPageCell))
    }
    
    func appendData(products: [ListProduct], nextPageState: NextPageState) {
        guard let collectionView = collectionView else { return }
        
        informedAboutNextPage = false
        
        var addedProductIndexPaths: [NSIndexPath] = []
        
        let currentCount = self.products.count
        for (index, _) in products.enumerate() {
            addedProductIndexPaths.append(NSIndexPath(forItem: index + currentCount, inSection: 0))
        }
        
        self.products.appendContentsOf(products)
        
        collectionView.performBatchUpdates({
            collectionView.insertItemsAtIndexPaths(addedProductIndexPaths)
            self.mergeNextPageStateUpdate(nextPageState)
            }, completion: nil)
    }
    
    func updateData(products: [ListProduct], nextPageState: NextPageState) {
        informedAboutNextPage = false
        self.products = products
        self.nextPageState = nextPageState
        collectionView?.reloadData()
    }
    
    func updateNextPageState(nextPageState: NextPageState) {
        collectionView?.performBatchUpdates({
            self.mergeNextPageStateUpdate(nextPageState)
            }, completion: nil)
    }
    
    private func mergeNextPageStateUpdate(nextPageState: NextPageState) {
        guard self.nextPageState != nextPageState else { return }
        let oldValue = self.nextPageState
        self.nextPageState = nextPageState
        
        let nextPageIndexPath = [NSIndexPath(forItem: 0, inSection: 1)]
        let nextPageSection = NSIndexSet(index: 1)
        
        switch nextPageState {
        case .Error:
            collectionView?.reloadItemsAtIndexPaths(nextPageIndexPath)
        case .Fetching:
            if oldValue == .Error {
                collectionView?.reloadItemsAtIndexPaths(nextPageIndexPath)
            } else {
                collectionView?.insertSections(nextPageSection)
            }
        case .LastPage:
            collectionView?.deleteSections(nextPageSection)
        }
    }
    
    // MARK:- ProductItemCellDelegate
    
    func productItemCellDidTap(cell: ProductItemCell) {
        guard let product = product(forCell: cell) else { return }
        delegate?.productListComponent(self, didTapProduct: product)
    }
    
    func productItemCellDidDoubleTap(cell: ProductItemCell) {
        guard let product = product(forCell: cell) else { return }
        delegate?.productListComponent(self, didDoubleTapProduct: product)
    }
    
    // MARK:- UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return ProductListSection.sectionCount(forNextPageState: nextPageState)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let listSection = ProductListSection(rawValue: section)!
        switch listSection {
        case .Products:
            return products.count
        case .NextPage:
            return 1
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let listSection = ProductListSection(rawValue: indexPath.section)!
        switch listSection {
        case .Products:
            let product = products[indexPath.row]
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(ProductItemCell), forIndexPath: indexPath) as! ProductItemCell
            cell.delegate = self
            cell.updateData(with: product)
            return cell
        case .NextPage:
            switch nextPageState {
            case .Error:
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(ProductErrorPageCell), forIndexPath: indexPath) as! ProductErrorPageCell
                cell.delegate = self
                return cell
            case .Fetching:
                return collectionView.dequeueReusableCellWithReuseIdentifier(String(ProductLoadingPageCell), forIndexPath: indexPath)
            default: fatalError("Invalid state. It should be .Error or .Fetching state")
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if ProductListSection.isNextPageSection(indexPath.section) {
            changeLoadingIndicatorAnimationStateIfPossible(forCell: cell, animationEnabled: true)
            if !informedAboutNextPage {
                informedAboutNextPage = true
                delegate?.productListComponentWillDisplayNextPage(self)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if ProductListSection.isNextPageSection(indexPath.section) {
            changeLoadingIndicatorAnimationStateIfPossible(forCell: cell, animationEnabled: false)
        }
    }
    
    // MARK:- UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let listSection = ProductListSection(rawValue: indexPath.section)!
        switch listSection {
        case .Products:
            return itemSize
        case .NextPage:
            return CGSizeMake(collectionView.bounds.width, 60 + Dimensions.defaultMargin)
            
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 24
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return interItemSpacing
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if ProductListSection.isNextPageSection(section) {
            return UIEdgeInsetsMake(Dimensions.defaultMargin, 0, 0, 0)
        }
        return UIEdgeInsetsMake(Dimensions.defaultMargin, Dimensions.defaultMargin, Dimensions.defaultMargin, Dimensions.defaultMargin)
    }
    
// MARK:- Utilities
    
    private func changeLoadingIndicatorAnimationStateIfPossible(forCell cell: UICollectionViewCell, animationEnabled: Bool) {
        guard let cell = cell as? ProductLoadingPageCell else { return }
        if animationEnabled {
            cell.loadingIndicator.startAnimation()
        } else {
            cell.loadingIndicator.stopAnimation()
        }
    }
    
    func product(forCell cell: ProductItemCell) -> ListProduct? {
        guard let collectionView = collectionView else { return nil }
        guard let indexPath = collectionView.indexPathForCell(cell) else { return nil }
        return products[indexPath.item]
    }
}

extension ProductListComponent: ProductErrorPageCellDelegate {
    func productErrorCellDidTapRetry(cell: ProductErrorPageCell) {
        delegate?.productListComponentDidTapRetryPage(self)
    }
}
