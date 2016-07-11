import UIKit

enum OnboardingPage: Int {
    case Infinite = 0, DoubleTap, ProductPaging, Notification
}

class OnboardingDataSource: NSObject, UICollectionViewDataSource {
    
    private weak var collectionView: UICollectionView?
    
    let pagesCount = 4
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        collectionView.registerClass(OnboardingInfiniteScrollingCell.self, forCellWithReuseIdentifier: String(OnboardingInfiniteScrollingCell))
        collectionView.registerClass(OnboardingDoubleTapAnimationCell.self, forCellWithReuseIdentifier: String(OnboardingDoubleTapAnimationCell))
        collectionView.registerClass(OnboardingProductPagingAnimationCell.self, forCellWithReuseIdentifier: String(OnboardingProductPagingAnimationCell))
        collectionView.registerClass(OnboardingNotificationsCell.self, forCellWithReuseIdentifier: String(OnboardingNotificationsCell))
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pagesCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let page = OnboardingPage(rawValue: indexPath.row)!
        
        switch page {
        case .Infinite:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(OnboardingInfiniteScrollingCell), forIndexPath: indexPath) as! OnboardingInfiniteScrollingCell
            return cell

        case .DoubleTap:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(OnboardingDoubleTapAnimationCell), forIndexPath: indexPath) as! OnboardingDoubleTapAnimationCell
            return cell
            
        case .ProductPaging:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(OnboardingProductPagingAnimationCell), forIndexPath: indexPath) as! OnboardingProductPagingAnimationCell
            return cell
            
        case .Notification:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(OnboardingNotificationsCell), forIndexPath: indexPath) as! OnboardingNotificationsCell
            return cell
        }
    }
}