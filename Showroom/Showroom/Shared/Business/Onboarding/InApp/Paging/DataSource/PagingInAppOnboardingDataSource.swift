import UIKit

enum PagingInAppOnboardingPage: Int {
    case PhotosPaging = 0, ProductPaging
}

class PagingInAppOnboardingDataSource: NSObject, UICollectionViewDataSource {
    
    private weak var collectionView: UICollectionView?
    weak var onboardingView: PagingInAppOnboardingView?
    
    let pagesCount = 2
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        collectionView.registerClass(InAppOnboardingPhotosPagingCell.self, forCellWithReuseIdentifier: String(InAppOnboardingPhotosPagingCell))
        collectionView.registerClass(InAppOnboardingProductPagingCell.self, forCellWithReuseIdentifier: String(InAppOnboardingProductPagingCell))
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pagesCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let page = PagingInAppOnboardingPage(rawValue: indexPath.row)!
        
        switch page {
        case .PhotosPaging:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(InAppOnboardingPhotosPagingCell), forIndexPath: indexPath) as! InAppOnboardingPhotosPagingCell
            cell.delegate = self
            return cell
            
        case .ProductPaging:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(InAppOnboardingProductPagingCell), forIndexPath: indexPath) as! InAppOnboardingProductPagingCell
            cell.delegate = self
            return cell
        }
    }
}

extension PagingInAppOnboardingDataSource: InAppOnboardingPhotosPagingCellDelegate {
    func onboardingPhotoPagingCellDidTapNext(cell: InAppOnboardingPhotosPagingCell) {
        onboardingView?.didTapNext()
    }
}

extension PagingInAppOnboardingDataSource: InAppOnboardingProductPagingCellDelegate {
    func onboardingProductPagingCellDidTapDismiss(cell: InAppOnboardingProductPagingCell) {
        onboardingView?.didTapDismiss()
    }
}