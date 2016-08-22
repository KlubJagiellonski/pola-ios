import Foundation
import UIKit
import RxSwift

class ProductFilterViewController: UIViewController, ProductFilterViewDelegate {
    private let disposeBag = DisposeBag()
    private let toastManager: ToastManager
    private let model: ProductFilterModel
    private var castView: ProductFilterView { return view as! ProductFilterView }
    
    init(with model: ProductFilterModel, and toastManager: ToastManager) {
        self.model = model
        self.toastManager = toastManager
        super.init(nibName: nil, bundle: nil)
        
        title = tr(.ProductListFilterTitle)
        navigationItem.rightBarButtonItem = createBlueTextBarButtonItem(title: tr(.ProductListFilterClear), target: self, action: #selector(ProductFilterViewController.didTapClear))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = ProductFilterView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.delegate = self
        model.state.viewState.asObservable().subscribeNext { [weak self] viewState in
            guard let `self` = self else { return }
            
            logInfo("Updating state to \(viewState)")
            
            switch viewState {
            case .Default:
                self.castView.switcherState = .Success
            case .Refreshing:
                self.castView.switcherState = .ModalLoading
            case .Error:
                self.toastManager.showMessage(tr(.CommonError))
            }
        }.addDisposableTo(disposeBag)
        
        model.state.totalProductsAmount.asObservable().subscribeNext { [weak self] totalProductsAmount in
            self?.castView.totalProductsAmount = totalProductsAmount
        }.addDisposableTo(disposeBag)
        
        model.state.currentFilters.asObservable().subscribeNext { [weak self] filters in
            guard let `self` = self else { return }
            
            logInfo("Updating filters \(filters)")
            self.castView.updateData(with: filters)
        }.addDisposableTo(disposeBag)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        logAnalyticsShowScreen(.Filter)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        castView.deselectRowsIfNeeded()
    }
    
    func didTapClear() {
        model.clearChanges()
    }
    
    // MARK:- ProductFilterViewDelegate
    
    func productFilterDidTapAccept(view: ProductFilterView) {
        logInfo("Did tap accept in product filter view")
        logAnalyticsEvent(AnalyticsEventId.ListFilterSubmit)
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowFilteredProducts))
    }
    
    func productFilter(view: ProductFilterView, didSelectItemAtIndex index: Int) {
        logInfo("Did select product filter item at index \(index)")
        let filter = model.state.currentFilters.value[index]
        guard filter.type.isSelectable else {
            logInfo("Product filter is not selectable")
            return
        }
        sendNavigationEvent(ShowFilterEvent(filter: filter))
    }
    
    func productFilter(view: ProductFilterView, didChangeValueRange valueRange: ValueRange, forIndex index: Int) {
        logInfo("Updated product filter range \(valueRange) for index \(index)")
        model.update(with: valueRange, forFilterId: model.state.currentFilters.value[index].id)
    }
    
    func productFilter(view: ProductFilterView, didChangeSelect selected: Bool, forIndex index: Int) {
        logInfo("Updated product filter select \(selected) for index \(index)")
        model.update(withSelected: selected, forFilterId: model.state.currentFilters.value[index].id)
    }
}

extension FilterType {
    private var isSelectable: Bool {
        switch self {
        case .Choice, .Tree:
            return true
        default:
            return false
        }
    }
}