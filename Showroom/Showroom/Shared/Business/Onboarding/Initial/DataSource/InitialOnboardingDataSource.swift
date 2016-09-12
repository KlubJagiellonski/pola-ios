import UIKit

enum InitialOnboardingPage: Int {
    case Infinite = 0, Notification
}

final class InitialOnboardingDataSource: NSObject, UICollectionViewDataSource {
    private weak var collectionView: UICollectionView?
    weak var onboardingView: InitialOnboardingView?
    
    let pagesCount = 2
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        collectionView.registerClass(InitialOnboardingInfiniteScrollingCell.self, forCellWithReuseIdentifier: String(InitialOnboardingInfiniteScrollingCell))
        collectionView.registerClass(InitialOnboardingNotificationsCell.self, forCellWithReuseIdentifier: String(InitialOnboardingNotificationsCell))
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pagesCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let page = InitialOnboardingPage(rawValue: indexPath.row)!
        
        switch page {
        case .Infinite:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(InitialOnboardingInfiniteScrollingCell), forIndexPath: indexPath) as! InitialOnboardingInfiniteScrollingCell
            cell.delegate = self
            return cell
            
        case .Notification:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(InitialOnboardingNotificationsCell), forIndexPath: indexPath) as! InitialOnboardingNotificationsCell
            cell.delegate = self
            return cell
        }
    }
}

extension InitialOnboardingDataSource: InitialOnboardingNotificationsCellDelegate {
    func onboardingNotificationDidTapAskMe(cell: InitialOnboardingNotificationsCell) {
        onboardingView?.didTapAskForNotification()
    }
    
    func onboardingNotificationDidTapSkip(cell: InitialOnboardingNotificationsCell) {
        onboardingView?.didTapSkip()
    }
}

extension InitialOnboardingDataSource: InitialOnboardingInfiniteScrollingCellDelegate {
    func onboardingInfiniteScrollingDidTapNext(cell: InitialOnboardingInfiniteScrollingCell) {
        logInfo("Onboarding infinte scrolling cell did tap next")
        onboardingView?.didTapNext()
    }
}