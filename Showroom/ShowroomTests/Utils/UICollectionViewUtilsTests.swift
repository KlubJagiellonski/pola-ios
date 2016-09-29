import Quick
import Nimble
@testable import SHOWROOM

class UICollectionViewUtilsTests: QuickSpec {
    override func spec() {
        describe("currentPageIndex") {
            let collectionView = UICollectionView(frame: CGRectMake(0, 0, 100, 0), collectionViewLayout: UICollectionViewFlowLayout())
            
            beforeEach {
                collectionView.contentOffset = CGPoint(x: 0, y: 0)
            }
            
            it("should correctly calculate current page index") {
                collectionView.contentOffset = CGPoint(x: 0, y: 0)
                expect(collectionView.currentPageIndex) == 0
                
                collectionView.contentOffset = CGPoint(x: 99.3, y: 0)
                expect(collectionView.currentPageIndex) == 0
                
                collectionView.contentOffset = CGPoint(x: 99, y: 0)
                expect(collectionView.currentPageIndex) == 0
                
                collectionView.contentOffset = CGPoint(x: 99.9999997, y: 0)
                expect(collectionView.currentPageIndex) == 1
                
                collectionView.contentOffset = CGPoint(x: 100.00001, y: 0)
                expect(collectionView.currentPageIndex) == 1
                
                collectionView.contentOffset = CGPoint(x: 199.9999997, y: 0)
                expect(collectionView.currentPageIndex) == 2
                
                collectionView.contentOffset = CGPoint(x: 200.0, y: 0)
                expect(collectionView.currentPageIndex) == 2
            }
        }
    }
}
