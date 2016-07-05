import UIKit

protocol TrendProductListViewDelegate: ProductListViewDelegate, ViewSwitcherDelegate {
    
}

class TrendProductListView: ViewSwitcher, ProductListViewInterface, ProductListComponentDelegate {
    let productListComponent: ProductListComponent
    let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    weak var delegate: ProductListViewDelegate? {
        didSet {
            switcherDelegate = trendListDelegate
        }
    }
    weak var trendListDelegate: TrendProductListViewDelegate? {
        return delegate as? TrendProductListViewDelegate
    }
    private let headerCell = TrendHeaderCell()
    
    init() {
        productListComponent = ProductListComponent(withCollectionView: collectionView)
        super.init(successView: collectionView)
        
        backgroundColor = UIColor(named: .White)
        
        switcherDataSource = self
        
        headerCell.updateData(withImageUrl: "", description: headerDescription)
        
        productListComponent.delegate = self
        productListComponent.headerSectionInfo = HeaderSectionInfo(view: headerCell, wantsToReceiveScrollEvents: true) { [unowned self] in
            return TrendHeaderCell.height(forWidth: self.collectionView.bounds.width, andDescription: self.headerDescription)
        }
        
        collectionView.applyProductListConfiguration()
        collectionView.delegate = productListComponent
        collectionView.dataSource = productListComponent
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.scrollDirection = .Vertical
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TrendProductListView {
    func productListComponent(component: ProductListComponent, didReceiveScrollEventWithContentOffset contentOffset: CGPoint, contentSize: CGSize) {
        guard contentOffset.y < headerCell.bounds.height else { return }
        let contentInset = collectionView.contentInset
        headerCell.updateImagePosition(forYOffset: contentOffset.y + contentInset.top, contentHeight: collectionView.bounds.height - (contentInset.top + contentInset.bottom))
    }
}

extension TrendProductListView: ViewSwitcherDataSource {
    func viewSwitcherWantsErrorInfo(view: ViewSwitcher) -> (ErrorText, ErrorImage?) {
        return (tr(.CommonError), UIImage(asset: .Error))
    }
    
    func viewSwitcherWantsEmptyView(view: ViewSwitcher) -> UIView? {
        let emptyView = ProductListEmptyView()
        emptyView.descriptionText = tr(.ProductListEmptyDescription)
        return emptyView
    }
}

// MARK:- Mockup methods

extension TrendProductListView {
    var headerDescription: String {
        return "Latem 2016 najmodniejsze kolory pochodzą ze świata natury. New Neutrals to piaskowy, ochra, kość słoniowa, khaki, orzechowy i zgniła zieleń. Naśladują barwy suchych traw, kolory pustyni, skał, gliny, a nawet skóry. Kolory natury pasują każdemu - blondynki poczują się naturalnie w odcieniach khaki, natomiast ciemne włosy brunetek będą świetnie kontrastować z jasnymi beżami. Jak nosić barwy ziemi? Zielenie nawiązują do wciąż modnego stylu militarnego, wyblakłe brązy wpisują się w trendy eko, a beżowy total look to nowa, zmysłowa tendencja, którą zapoczątkowała Kim Kardashian. Jesteś uwodzicielska, wojownicza czy ekologiczna? Latem 2016 postaw na naturalne kolory i znajdź wśród nich ten, który podkreśla Twoją osobowość!"
    }
}

