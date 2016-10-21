import Foundation

extension UICollectionView {
    var currentPageIndex: Int {
        let pageWidth = frame.width
        guard pageWidth > 0 else { return 0 } //we don't want to divide by 0
        
        let contentOffsetX = contentOffset.x
        if fmodf(Float(contentOffsetX), 1.0) > 0.9999 {
            return Int(ceil(contentOffsetX) / pageWidth)
        } else {
            return Int(contentOffsetX / pageWidth)
        }
    }
    
    func hasRow(at indexPath: NSIndexPath) -> Bool {
        return indexPath.section < numberOfSections() && indexPath.row < numberOfItemsInSection(indexPath.section)
    }
    
    func configureForPaging(withDirection direction: UICollectionViewScrollDirection) {
        pagingEnabled = true
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            fatalError("If you want to configure for horizontal paging the collectionViewLayout must be of type UICollectionViewFlowLayout")
        }
        flowLayout.scrollDirection = direction
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
    }
}