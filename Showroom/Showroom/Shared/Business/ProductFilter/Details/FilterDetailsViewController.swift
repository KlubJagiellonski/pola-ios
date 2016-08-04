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
            if viewState == .Error {
                self?.toastManager.showMessage(tr(.CommonError))
            }
        }.addDisposableTo(disposeBag)
    }
    
    func didTapClear() {
        if let defaultId = filterInfo.defaultFilterId {
            currentSelectedIds = [defaultId]
        } else {
            currentSelectedIds = []
        }
        castView.updateData(withSelectedIds: currentSelectedIds)
    }
    
    private func updateData() {
        tempFilterInfo = model.createTempFilterInfo(forFilterId: filterInfo.id)
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
        model.updateTemp(withData: newSelectedIds, forFilterId: filterInfo.id)
    }
    
    //MARK:- FilterDetailsViewDelegate
    
    func filterDetailsDidTapAccept(view: FilterDetailsView) {
        model.update(withData: currentSelectedIds, forFilterId: filterInfo.id)
        sendNavigationEvent(SimpleNavigationEvent(type: .Back))
    }
    
    func filterDetails(view: FilterDetailsView, didSelectFilterItemAtIndex index: Int) {
        guard model.state.tempViewState.value != .Refreshing else { return }
        
        let filterInfo = self.tempFilterInfo ?? self.filterInfo
        let filterItem = filterInfo.filterItems[index]
        if filterInfo.mode == .Tree {
            updateTree(forSelectedItem: filterItem)
            return
        }
        
        if filterInfo.mode == .SingleChoice {
            currentSelectedIds = [filterItem.id]
            castView.updateData(withSelectedIds: currentSelectedIds)
            return
        }
        
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
    }
}
