import Foundation
import UIKit
import SnapKit

protocol ProductDetailsViewDelegate: class {
    func productDetailsDidTapClose(view: ProductDetailsView)
    func productDetails(view: ProductDetailsView, didMoveToProductAtIndex index: Int)
}

enum ProductDetailsViewState {
    case Close
    case Dismiss
    case FullScreen
}

enum ProductDetailsCloseButtonState {
    case Close
    case Dismiss
}

class ProductDetailsView: UIView, UICollectionViewDelegateFlowLayout {
    private let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    private let closeButton = UIButton(type: .Custom)
    
    private let dataSource: ProductDetailsDataSource
    
    var closeButtonState: ProductDetailsCloseButtonState = .Close {
        didSet {
            switch closeButtonState {
            case .Close:
                closeButton.setImage(UIImage(asset: .Ic_close), forState: .Normal)
            case .Dismiss:
                closeButton.setImage(UIImage(asset: .Ic_chevron_down), forState: .Normal)
            }
        }
    }
    var currentPageIndex: Int {
        return collectionView.currentPageIndex
    }
    var scrollingEnabled = true {
        didSet {
            collectionView.scrollEnabled = scrollingEnabled
        }
    }
    var viewState: ProductDetailsViewState = .Close {
        didSet {
            if viewState == .Close || viewState == .Dismiss {
                closeButtonState = viewState == .Close ? .Close : .Dismiss
            }
            
            closeButton.alpha = viewState == .FullScreen ? 0 : 1
            scrollingEnabled = viewState == .Close
        }
    }
    weak var delegate: ProductDetailsViewDelegate?
    var pageHandler: ProductDetailsPageHandler? {
        set { dataSource.pageHandler = newValue }
        get { return dataSource.pageHandler }
    }
    
    init() {
        dataSource = ProductDetailsDataSource(collectionView: collectionView)
        
        super.init(frame: CGRectZero)
        
        collectionView.backgroundColor = UIColor(named: .ProductPageBackground)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.configureForPaging(withDirection: .Horizontal)
        
        closeButton.setImage(UIImage(asset: .Ic_close), forState: .Normal)
        closeButton.applyCircleStyle()
        closeButton.addTarget(self, action: #selector(ProductDetailsView.onCloseButtonTapped), forControlEvents: .TouchUpInside)
        
        addSubview(collectionView)
        addSubview(closeButton)
        
        createCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createCustomConstraints() {
        collectionView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        closeButton.snp_makeConstraints { make in
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.top.equalToSuperview().offset(Dimensions.modalTopMargin)
            make.width.equalTo(Dimensions.circleButtonDiameter)
            make.height.equalTo(closeButton.snp_width)
        }
    }
    
    func updatePageCount(with pageCount: Int) {
        dataSource.updatePageCount(with: pageCount)
    }
    
    func reloadPageCount(withNewProductCount newProductsCount: Int) {
        dataSource.reloadPageCount(withNewPageCount: newProductsCount)
    }
    
    func scrollToPage(atIndex index: Int, animated: Bool) {
        let indexPath = NSIndexPath(forItem: index, inSection: 0)
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: animated)
    }
    
    func onCloseButtonTapped(button: UIButton) {
        delegate?.productDetailsDidTapClose(self)
    }
    
    func changeState(newState: ProductDetailsViewState, animationDuration: Double?, completion: ((Bool) -> ())? = nil) {
        guard viewState != newState else { return }
        
        layoutIfNeeded()
        UIView.animateWithDuration(animationDuration ?? 0, delay: 0, options: [.CurveEaseInOut], animations: {
            self.viewState = newState
            self.layoutIfNeeded()
            }, completion: completion)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return self.bounds.size
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.delegate?.productDetails(self, didMoveToProductAtIndex: currentPageIndex)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.delegate?.productDetails(self, didMoveToProductAtIndex: currentPageIndex)
    }
}

extension ProductDetailsView: ImageAnimationTargetViewInterface {
    var viewsAboveImageVisibility: Bool {
        set {
            closeButton.alpha = newValue ? 1 : 0
            dataSource.viewsAboveImageVisibility = newValue
        }
        get {
            return dataSource.viewsAboveImageVisibility ?? true
        }
    }
    
    var highResImage: UIImage? {
        return dataSource.highResImage(forIndex: currentPageIndex)
    }
    
    var highResImageVisible: Bool {
        set { dataSource.highResImageVisible = newValue }
        get { return dataSource.highResImageVisible ?? true }
    }
}
