import Foundation
import UIKit
import RxSwift

class FilterDetailsViewController: UIViewController, FilterDetailsViewDelegate {
    private let disposeBag = DisposeBag()
    private let model: ProductFilterModel
    private let filterOption: FilterOption
    private let filterInfo: FilterInfo
    private var tempFilterInfo: FilterInfo?
    private var currentSelectedIds: [ObjectId] {
        didSet {
            updateAcceptButtonState()
        }
    }
    private var castView: FilterDetailsView { return view as! FilterDetailsView }
    
    init(with model: ProductFilterModel, and filterOption: FilterOption) {
        self.model = model
        self.filterOption = filterOption
        self.filterInfo = model.createFilterInfo(forOption: filterOption)
        self.currentSelectedIds = filterInfo.selectedFilterItemIds
        super.init(nibName: nil, bundle: nil)
        
        if filterOption != .Category {
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
        tempFilterInfo = model.createTempFilterInfo(forOption: filterOption)
        if let filterInfo = tempFilterInfo {
            currentSelectedIds = filterInfo.selectedFilterItemIds
            castView.updateData(with: filterInfo.filterItems, selectedIds: currentSelectedIds, loadingItemIndex: nil)
        }
    }
    
    private func updateTree(forSelectedItem item: FilterItem) {
        castView.updateData(withLoadingItemIndex: filterInfo.filterItems.indexOf { $0.id == item.id })
        var newSelectedIds: [ObjectId] = []
        for selectedId in currentSelectedIds {
            newSelectedIds.append(selectedId)
            if selectedId == item.id {
                break
            }
        }
        model.updateTempSelectedFilters(newSelectedIds, forOption: filterOption)
    }
    
    //MARK:- FilterDetailsViewDelegate
    
    func filterDetailsDidTapAccept(view: FilterDetailsView) {
        model.updateSelectedFilters(currentSelectedIds, forOption: filterOption)
        sendNavigationEvent(SimpleNavigationEvent(type: .Back))
    }
    
    func filterDetails(view: FilterDetailsView, didSelectFilterItemAtIndex index: Int) {
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
