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
        view = ProductFilterView(with: self.model.state)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.delegate = self
        model.state.viewState.asObservable().subscribeNext { [weak self] viewState in
            guard let `self` = self else { return }
            
            switch viewState {
            case .Default:
                self.castView.switcherState = .Success
            case .Refreshing:
                self.castView.switcherState = .ModalLoading
            case .Error:
                self.toastManager.showMessage(tr(.CommonError))
            }
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
        sendNavigationEvent(SimpleNavigationEvent(type: .ShowFilteredProducts))
    }
    
    func productFilter(view: ProductFilterView, didSelectItemAtIndex index: Int) {
        let filter = model.state.currentFilters.value[index]
        sendNavigationEvent(ShowFilterEvent(filter: filter))
    }
    
    func productFilter(view: ProductFilterView, didChangeValueRange valueRange: ValueRange, forIndex index: Int) {
        model.update(with: valueRange, forFilterId: model.state.currentFilters.value[index].id)
    }
    
    func productFilter(view: ProductFilterView, didChangeSelect selected: Bool, forIndex index: Int) {
        model.update(withSelected: selected, forFilterId: model.state.currentFilters.value[index].id)
    }
}