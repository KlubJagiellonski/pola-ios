import Foundation
import UIKit
import RxSwift

class FilterDetailsViewController: UIViewController, FilterDetailsViewDelegate {
    private let disposeBag = DisposeBag()
    private let toastManager: ToastManager
    private let model: ProductFilterModel
    private let filterInfo: FilterInfo
    private var tempFilterInfo: FilterInfo?
    private var currentSelectedIds: [FilterObjectId] {
        didSet {
            updateAcceptButtonState()
        }
    }
    private var castView: FilterDetailsView { return view as! FilterDetailsView }
    
    init(with model: ProductFilterModel, filterInfo: FilterInfo, and toastManager: ToastManager) {
        self.model = model
        self.toastManager = toastManager
        self.filterInfo = filterInfo
        
        var selectedIds: [FilterObjectId] = filterInfo.selectedFilterItemIds
        if let defaultFilterId = filterInfo.defaultFilterId where selectedIds.isEmpty {
            selectedIds.append(defaultFilterId)
        }
        self.currentSelectedIds = selectedIds
        super.init(nibName: nil, bundle: nil)
        
        if filterInfo.mode != .Tree {
            navigationItem.rightBarButtonItem = createBlueTextBarButtonItem(title: tr(.ProductListFilterClear), target: self, action: #selector(FilterDetailsViewController.didTapClear))
        }
        title = filterInfo.title
        
        model.resetTempFilter()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = FilterDetailsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.acceptButtonEnabled = false
        castView.delegate = self
        castView.updateData(with: filterInfo.filterItems, selectedIds: currentSelectedIds, loadingItemIndex: nil)
        
        model.state.tempFilter.asObservable().subscribeNext { [weak self] _ in self?.updateData() }.addDisposableTo(disposeBag)
        model.state.tempViewState.asObservable().subscribeNext { [weak self] viewState in
            logInfo("Changed temp view state to \(viewState)")
            if viewState == .Error {
                self?.toastManager.showMessage(tr(.CommonError))
            }
        }.addDisposableTo(disposeBag)
    }
    
    func didTapClear() {
        logInfo("Did tap clear with default filter id \(filterInfo.defaultFilterId)")
        if let defaultId = filterInfo.defaultFilterId {
            currentSelectedIds = [defaultId]
        } else {
            currentSelectedIds = []
        }
        castView.updateData(withSelectedIds: currentSelectedIds)
    }
    
    private func updateData() {
        tempFilterInfo = model.createTempFilterInfo(forFilterId: filterInfo.id)
        logInfo("Updating data for id \(filterInfo.id) tempFilterInfo \(tempFilterInfo)")
        if let filterInfo = tempFilterInfo {
            currentSelectedIds = filterInfo.selectedFilterItemIds
            castView.updateData(with: filterInfo.filterItems, selectedIds: currentSelectedIds, loadingItemIndex: nil)
        }
    }
    
    private func updateTree(forSelectedItem item: FilterItem) {
        let filterInfo = self.tempFilterInfo ?? self.filterInfo
        let newSelectedIndex = filterInfo.filterItems.indexOf { $0.id == item.id }!
        castView.updateData(withLoadingItemIndex: newSelectedIndex)
        
        var newSelectedAdded = false
        var newSelectedIds: [FilterObjectId] = []
        for selectedId in currentSelectedIds {
            let selectedIdIndex = filterInfo.filterItems.indexOf { $0.id == selectedId }!
            if selectedIdIndex > newSelectedIndex && !newSelectedAdded {
                newSelectedIds.append(item.id)
                newSelectedAdded = true
            }
            newSelectedIds.append(selectedId)
            if selectedId == item.id {
                newSelectedAdded = true
                break
            }
        }
        if !newSelectedAdded {
            newSelectedIds.append(item.id)
        }
        logInfo("Updating tree with newSelectedIds \(newSelectedIds) filterId \(filterInfo.id)")
        model.updateTemp(withData: newSelectedIds, forFilterId: filterInfo.id)
    }
    
    //MARK:- FilterDetailsViewDelegate
    
    func filterDetailsDidTapAccept(view: FilterDetailsView) {
        logInfo("Dida tap accept in filter details for filterId \(filterInfo.id)")
        logAnalyticsEvent(AnalyticsEventId.ListFilterChanged(filterInfo.id))
        model.update(withData: currentSelectedIds, forFilterId: filterInfo.id)
        sendNavigationEvent(SimpleNavigationEvent(type: .Back))
    }
    
    func filterDetails(view: FilterDetailsView, didSelectFilterItemAtIndex index: Int) {
        logInfo("Did select filter item at index \(index)")
        
        guard model.state.tempViewState.value != .Refreshing else {
            logInfo("Selected while refreshing. Ignoring...")
            return
        }
        
        let filterInfo = self.tempFilterInfo ?? self.filterInfo
        let filterItem = filterInfo.filterItems[index]
        if filterInfo.mode == .Tree {
            logInfo("Updating tree for item \(filterItem)")
            updateTree(forSelectedItem: filterItem)
            return
        }
        
        if filterInfo.mode == .SingleChoice {
            logInfo("Updating single choice \(filterItem)")
            currentSelectedIds = [filterItem.id]
            castView.updateData(withSelectedIds: currentSelectedIds)
            return
        }
        
        logInfo("Updating for other modes \(filterItem)")
        
        if let removeIndex = currentSelectedIds.indexOf(filterItem.id) {
            currentSelectedIds.removeAtIndex(removeIndex)
        } else {
            currentSelectedIds.append(filterItem.id)
        }
        castView.updateData(withSelectedIds: currentSelectedIds)
    }
    
    //MARK:- Utils
    
    func updateAcceptButtonState() {
        castView.acceptButtonEnabled = currentSelectedIds != filterInfo.selectedFilterItemIds
        logInfo("Updating accept button state \(castView.acceptButtonEnabled)")
    }
}
