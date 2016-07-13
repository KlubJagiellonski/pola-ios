import Foundation
import UIKit

class FilterDetailsViewController: UIViewController, FilterDetailsViewDelegate {
    private let model: ProductFilterModel
    private let filterOption: FilterOption
    private let filterInfo: FilterInfo
    private var currentSelectedIds: [ObjectId] {
        didSet {
            updateAcceptButtonState()
            castView.currentSelectedIds = currentSelectedIds
        }
    }
    private var castView: FilterDetailsView { return view as! FilterDetailsView }
    
    init(with model: ProductFilterModel, and filterOption: FilterOption) {
        self.model = model
        self.filterOption = filterOption
        self.filterInfo = model.createFilterInfo(forOption: filterOption)
        self.currentSelectedIds = self.filterInfo.selectedFilterItemIds
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.rightBarButtonItem = createBlueTextBarButtonItem(title: tr(.ProductListFilterClear), target: self, action: #selector(FilterDetailsViewController.didTapClear))
        title = filterInfo.title
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
        castView.filterItems = filterInfo.filterItems
        castView.currentSelectedIds = currentSelectedIds
    }
    
    func didTapClear() {
        currentSelectedIds = filterInfo.selectedFilterItemIds
    }
    
    //MARK:- FilterDetailsViewDelegate
    
    func filterDetailsDidTapAccept(view: FilterDetailsView) {
        model.updateSelectedFilters(currentSelectedIds, forOption: filterOption)
        sendNavigationEvent(SimpleNavigationEvent(type: .Back))
    }
    
    func filterDetails(view: FilterDetailsView, didSelectFilterItemAtIndex index: Int) {
        let filterItem = filterInfo.filterItems[index]
        if filterItem.goToEnabled {
            //todo go to next page
            return
        }
        
        if filterInfo.mode == .SingleChoice {
            self.currentSelectedIds = [filterItem.id]
            return
        }
        
        if let removeIndex = currentSelectedIds.indexOf(filterItem.id) {
            currentSelectedIds.removeAtIndex(removeIndex)
        } else {
            currentSelectedIds.append(filterItem.id)
        }
    }
    
    //MARK:- Utils
    
    func updateAcceptButtonState() {
        castView.acceptButtonEnabled = currentSelectedIds != filterInfo.selectedFilterItemIds
    }
}
