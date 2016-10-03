import Foundation

extension UICollectionView {
    func hasRow(at indexPath: NSIndexPath) -> Bool {
        return indexPath.section < numberOfSections() && indexPath.row < numberOfItemsInSection(indexPath.section)
    }
}