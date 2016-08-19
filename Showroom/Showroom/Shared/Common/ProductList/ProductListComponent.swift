import Foundation
import UIKit

enum NextPageState {
    case Fetching
    case LastPage
    case Error
}

enum ProductListSection: Int {
    case HeaderSection = 0, Products, NextPage
    
    static func fromSectionIndex(section: Int, headerSectionExist: Bool) -> ProductListSection {
        if headerSectionExist {
            return ProductListSection(rawValue: section)!
        } else {
            return ProductListSection(rawValue: section + 1)!
        }
    }
    
    static func isNextPageSection(section: Int, headerSectionExist: Bool) -> Bool {
        return fromSectionIndex(section, headerSectionExist: headerSectionExist) == .NextPage
    }
    
    static func isHeaderSection(section: Int, headerSectionExist: Bool) -> Bool {
        return fromSectionIndex(section, headerSectionExist: headerSectionExist) == .HeaderSection
    }
    
    static func sectionCount(forNextPageState state: NextPageState, headerSectionExist: Bool) -> Int {
        switch state {
        case .Fetching, .Error:
            return ProductListSection.NextPage.rawValue + (headerSectionExist ? 1 : 0)
        default:
            return ProductListSection.Products.rawValue + (headerSectionExist ? 1 : 0)
        }
    }
    func toSectionIndex(headerSectionExist: Bool) -> Int {
        return self.rawValue + (headerSectionExist ? 0 : -1)
    }
}

struct HeaderSectionInfo {
    let view: UIView
    let wantsToReceiveScrollEvents: Bool
    let calculateHeight: () -> CGFloat
}

protocol ProductListComponentDelegate: class {
    func productListComponentWillDisplayNextPage(component: ProductListComponent)
    func productListComponentDidTapRetryPage(component: ProductListComponent)
    func productListComponent(component: ProductListComponent, didTapProductAtIndex index: Int)
    func productListComponent(component: ProductListComponent, didDoubleTapProductAtIndex index: Int)
    func productListComponent(component: ProductListComponent, didReceiveScrollEventWithContentOffset contentOffset: CGPoint, contentSize: CGSize)
}

final class ProductListComponent: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ProductItemCellDelegate {
    private static let minItemWidth: CGFloat = 120
    private static let interItemSpacing: CGFloat = 10
    private static let itemTitleHeight: CGFloat = 62
    
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
        
        let columnWidthFor3Columns = floor((collectionView.bounds.width - Dimensions.defaultMargin * 2 - ProductListComponent.interItemSpacing * 2) / 3)
        let columnWidthFor2Columns = floor((collectionView.bounds.width - Dimensions.defaultMargin * 2 - ProductListComponent.interItemSpacing) / 2)
        let itemWidth = columnWidthFor3Columns > ProductListComponent.minItemWidth ? columnWidthFor3Columns : columnWidthFor2Columns
        let imageHeight = itemWidth / CGFloat(Dimensions.defaultImageRatio)
        let itemHeight = ceil(imageHeight + ProductListComponent.itemTitleHeight)
        return CGSizeMake(itemWidth, itemHeight)
    }()
    
    static var threeColumnsRequiredWidth: CGFloat {
        return minItemWidth * 3 + Dimensions.defaultMargin * 2 + ProductListComponent.interItemSpacing * 2
    }
    var imageWidth: Int {
        return UIImageView.scaledImageSize(itemSize.width)
    }
    var nextPageState: NextPageState = .LastPage
    var headerSectionInfo: HeaderSectionInfo?
    
    init(withCollectionView collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        
        collectionView.registerClass(ProductItemCell.self, forCellWithReuseIdentifier: String(ProductItemCell))
        collectionView.registerClass(ProductLoadingPageCell.self, forCellWithReuseIdentifier: String(ProductLoadingPageCell))
        collectionView.registerClass(ProductErrorPageCell.self, forCellWithReuseIdentifier: String(ProductErrorPageCell))
        collectionView.registerClass(ProductHeaderContainerCell.self, forCellWithReuseIdentifier: String(ProductHeaderContainerCell))
    }
    
    func appendData(products: [ListProduct], nextPageState: NextPageState) {
        guard let collectionView = collectionView else { return }
        
        informedAboutNextPage = false
        
        var addedProductIndexPaths: [NSIndexPath] = []
        
        let currentCount = self.products.count
        let productsSectionIndex = ProductListSection.Products.toSectionIndex(headerSectionInfo != nil)
        for (index, _) in products.enumerate() {
            addedProductIndexPaths.append(NSIndexPath(forItem: index + currentCount, inSection: productsSectionIndex))
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
    
    func moveToPosition(forProductIndex index: Int, animated: Bool) {
        guard let view = collectionView else { return }
        let indexPath = NSIndexPath(forItem: index, inSection: ProductListSection.Products.toSectionIndex(headerSectionInfo != nil))
        view.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredVertically, animated: animated)
    }
    
    func imageTag(forIndex index: Int) -> Int {
        return "\(products[index].id) \(index)".hashValue
    }
    
    private func mergeNextPageStateUpdate(nextPageState: NextPageState) {
        guard self.nextPageState != nextPageState else { return }
        let oldValue = self.nextPageState
        self.nextPageState = nextPageState
        
        let nextPageSectionIndex = ProductListSection.NextPage.toSectionIndex(headerSectionInfo != nil)
        let nextPageIndexPath = [NSIndexPath(forItem: 0, inSection: nextPageSectionIndex)]
        let nextPageSection = NSIndexSet(index: nextPageSectionIndex)
        
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
        guard let collectionView = collectionView, let indexPath = collectionView.indexPathForCell(cell) else { return }
        delegate?.productListComponent(self, didTapProductAtIndex: indexPath.item)
    }
    
    func productItemCellDidDoubleTap(cell: ProductItemCell) {
        guard let collectionView = collectionView, let indexPath = collectionView.indexPathForCell(cell) else { return }
        delegate?.productListComponent(self, didDoubleTapProductAtIndex: indexPath.item)
    }
    
    // MARK:- UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return ProductListSection.sectionCount(forNextPageState: nextPageState, headerSectionExist: headerSectionInfo != nil)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let listSection = ProductListSection.fromSectionIndex(section, headerSectionExist: headerSectionInfo != nil)
        switch listSection {
        case .Products:
            return products.count
        case .NextPage, .HeaderSection:
            return 1
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let listSection = ProductListSection.fromSectionIndex(indexPath.section, headerSectionExist: headerSectionInfo != nil)
        switch listSection {
        case .Products:
            let product = products[indexPath.row]
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(ProductItemCell), forIndexPath: indexPath) as! ProductItemCell
            cell.imageTag = imageTag(forIndex: indexPath.item)
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
        case .HeaderSection:
            guard let headerSectionInfo = headerSectionInfo else { fatalError("Something is wrong. It is not possible to have HeaderSection when headerSectionInfo is nil") }
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(ProductHeaderContainerCell), forIndexPath: indexPath) as! ProductHeaderContainerCell
            cell.headerContentView = headerSectionInfo.view
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if ProductListSection.isNextPageSection(indexPath.section, headerSectionExist: headerSectionInfo != nil) {
            changeLoadingIndicatorAnimationStateIfPossible(forCell: cell, animationEnabled: true)
            if !informedAboutNextPage {
                informedAboutNextPage = true
                delegate?.productListComponentWillDisplayNextPage(self)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if ProductListSection.isNextPageSection(indexPath.section, headerSectionExist: headerSectionInfo != nil) {
            changeLoadingIndicatorAnimationStateIfPossible(forCell: cell, animationEnabled: false)
        }
    }
    
    // MARK:- UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let listSection = ProductListSection.fromSectionIndex(indexPath.section, headerSectionExist: headerSectionInfo != nil)
        switch listSection {
        case .Products:
            return itemSize
        case .NextPage:
            return CGSizeMake(collectionView.bounds.width, 145)
        case .HeaderSection:
            guard let headerSectionInfo = headerSectionInfo else { fatalError("Something is wrong. It is not possible to have HeaderSection when headerSectionInfo is nil") }
            return CGSizeMake(collectionView.bounds.width, headerSectionInfo.calculateHeight())
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 24
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return ProductListComponent.interItemSpacing
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if ProductListSection.isNextPageSection(section, headerSectionExist: headerSectionInfo != nil) {
            return UIEdgeInsetsMake(Dimensions.defaultMargin, 0, 0, 0)
        } else if ProductListSection.isHeaderSection(section, headerSectionExist: headerSectionInfo != nil) {
            return UIEdgeInsetsZero
        }
        return UIEdgeInsetsMake(Dimensions.defaultMargin, Dimensions.defaultMargin, Dimensions.defaultMargin, Dimensions.defaultMargin)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if headerSectionInfo?.wantsToReceiveScrollEvents ?? false {
            delegate?.productListComponent(self, didReceiveScrollEventWithContentOffset: scrollView.contentOffset, contentSize: scrollView.contentSize)
        }
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
