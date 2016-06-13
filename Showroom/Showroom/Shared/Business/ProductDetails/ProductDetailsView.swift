import Foundation
import UIKit

protocol ProductDetailsViewDelegate: class {
    func productDetailsDidTapClose(view: ProductDetailsView)
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
    
    func updatePageCount(pageCount: Int) {
        dataSource.pageCount = pageCount
    }
    
    func scrollToPage(atIndex index: Int, animated: Bool) {
        let indexPath = NSIndexPath(forItem: index, inSection: 0)
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: animated)
    }
    
    func onCloseButtonTapped(button: UIButton) {
        delegate?.productDetailsDidTapClose(self)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return self.bounds.size
    }
}
