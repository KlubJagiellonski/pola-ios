import UIKit

enum OnboardingPage: Int {
    case Infinite = 0, Notification
}

final class OnboardingDataSource: NSObject, UICollectionViewDataSource {
    private weak var collectionView: UICollectionView?
    weak var onboardingView: OnboardingView?
    
    let pagesCount = 2
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        collectionView.registerClass(OnboardingInfiniteScrollingCell.self, forCellWithReuseIdentifier: String(OnboardingInfiniteScrollingCell))
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
            cell.delegate = self
            return cell
            
        case .Notification:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(OnboardingNotificationsCell), forIndexPath: indexPath) as! OnboardingNotificationsCell
            cell.delegate = self
            return cell
        }
    }
}

extension OnboardingDataSource: OnboardingNotificationsCellDelegate {
    func onboardingNotificationDidTapAskMe(cell: OnboardingNotificationsCell) {
        onboardingView?.didTapAskForNotification()
    }
    
    func onboardingNotificationDidTapSkip(cell: OnboardingNotificationsCell) {
        onboardingView?.didTapSkip()
    }
}

extension OnboardingDataSource: OnboardingInfiniteScrollingCellDelegate {
    func onboardingInfiniteScrollingDidTapNext(cell: OnboardingInfiniteScrollingCell) {
        onboardingView?.didTapNext()
    }
}