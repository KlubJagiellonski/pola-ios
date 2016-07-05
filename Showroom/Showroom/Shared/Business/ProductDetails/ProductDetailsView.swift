import Foundation
import UIKit
import SnapKit

protocol ProductDetailsViewDelegate: class {
    func productDetailsDidTapClose(view: ProductDetailsView)
}

enum ProductDetailsViewState {
    case Close
    case Dismiss
    case FullScreen
}

enum CloseButtonState {
    case Close
    case Dismiss
}

class ProductDetailsView: UIView, UICollectionViewDelegateFlowLayout {
    private let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    private let closeButton = UIButton(type: .Custom)
    
    private let dataSource: ProductDetailsDataSource
    
    var closeButtonState: CloseButtonState = .Close {
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
        let pageWidth = collectionView.frame.width
        return Int(collectionView.contentOffset.x / pageWidth)
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
    weak var pageHandler: ProductDetailsPageHandler? {
        set { dataSource.pageHandler = newValue }
        get { return dataSource.pageHandler }
    }
    
    init() {
        dataSource = ProductDetailsDataSource(collectionView: collectionView)
        
        super.init(frame: CGRectZero)
        
        collectionView.backgroundColor = UIColor(named: .ProductPageBackground)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.pagingEnabled = true
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.scrollDirection = .Horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
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
            make.top.equalToSuperview().offset(Dimensions.productDetailsTopMargin)
            make.width.equalTo(Dimensions.circleButtonDiameter)
            make.height.equalTo(closeButton.snp_width)
        }
    }
    
    func updatePageCount(withNewProductsAmount newProductsAmount: Int) {
        dataSource.pageCount += newProductsAmount
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
}
