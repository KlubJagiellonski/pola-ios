import UIKit
import MapKit

protocol EditKioskViewDelegate: ViewSwitcherDelegate {
    func editKioskView(view: EditKioskView, didReturnSearchString searchString: String?)
    func editKioskView(view: EditKioskView, didChooseKioskAtIndex kioskIndex: Int)
    func editKioskViewDidChangeKioskSelection(view: EditKioskView)
}

class EditKioskView: ViewSwitcher, UITableViewDelegate {
    
    static let tableViewTopInset: CGFloat = 26.0
    
    private let contentView = UIView()
    private let searchInputView = FormInputView()
    private let internalViewSwitcher: ViewSwitcher
    private let tableView: UITableView
    private let dataSource: EditKioskDataSource
    private let saveButton = UIButton()
    
    let keyboardHelper = KeyboardHelper()
    
    var internalSwitcherState: ViewSwitcherState {
        get { return internalViewSwitcher.switcherState }
        set { internalViewSwitcher.switcherState = newValue }
    }
    
    var searchString: String? {
        get {
            let inputText = searchInputView.inputTextField.text
            if inputText == nil || inputText!.isEmpty {
                return nil
            }
            return inputText
        }
        set { searchInputView.inputTextField.text = newValue }
    }
    
    var selectedIndex: Int? {
        set {
            dataSource.selectedIndex = newValue
            saveButton.enabled = (newValue != nil)
        }
        get { return dataSource.selectedIndex }
    }
    
    var geocodingErrorVisible: Bool {
        didSet {
            searchInputView.validation = geocodingErrorVisible ? tr(.CheckoutDeliveryEditKioskGeocodingError) : nil
        }
    }
    
    var saveButtonEnabled: Bool {
        set { saveButton.enabled = newValue }
        get { return saveButton.enabled }
    }
  
    weak var delegate: EditKioskViewDelegate? { didSet { internalViewSwitcher.switcherDelegate = delegate } }
    
    init(kioskSearchString: String?) {
        tableView = UITableView(frame: CGRectZero, style: .Plain)
        internalViewSwitcher = ViewSwitcher(successView: tableView, initialState: .Success)
        dataSource = EditKioskDataSource(tableView: tableView)
        geocodingErrorVisible = false
        super.init(successView: contentView, initialState: .Success)
        
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .None
        tableView.contentInset = UIEdgeInsets(top: EditKioskView.tableViewTopInset, left: 0, bottom: 0, right: 0)
        
        internalViewSwitcher.switcherDataSource = self
        
        keyboardHelper.delegate = self
        
        backgroundColor = UIColor(named: .White)
        
        searchInputView.bottomOffsetEnabled = false
        searchInputView.title = tr(.CheckoutDeliveryEditKioskSearchInputLabel)
        searchInputView.inputTextField.placeholder = tr(.CheckoutDeliveryEditKioskSearchInputPlaceholder)
        searchInputView.inputTextField.returnKeyType = .Search
        searchString = kioskSearchString
        searchInputView.backgroundColor = nil
        searchInputView.inputTextField.delegate = self

        saveButton.title = tr(.CheckoutDeliveryEditKioskSave)
        saveButton.addTarget(self, action: #selector(EditKioskView.didTapSaveButton), forControlEvents: .TouchUpInside)
        saveButton.applyBlueStyle()
        
        contentView.addSubview(searchInputView)
        contentView.addSubview(internalViewSwitcher)
        contentView.addSubview(saveButton)
        
        configureCustomCostraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateKiosks(kiosks: [Kiosk]) {
        dataSource.updateData(kiosks)
        selectedIndex = nil
        tableView.contentOffset = CGPoint(x: 0.0, y: -FormInputView.validationLabelHeight)
    }
    
    func configureCustomCostraints() {
        searchInputView.snp_makeConstraints { make in
            make.top.equalToSuperview().inset(Dimensions.defaultMargin)
            make.leading.equalToSuperview().inset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().inset(Dimensions.defaultMargin)
        }
        
        internalViewSwitcher.snp_makeConstraints { make in
            make.top.equalTo(searchInputView.snp_bottom).offset(-FormInputView.validationLabelHeight)
            make.bottom.equalTo(saveButton.snp_top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        saveButton.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(Dimensions.bigButtonHeight)
        }
    }
    
    func dismissKeyboard() {
        endEditing(true)
    }

    func didTapSaveButton() {
        guard let selectedIndex = selectedIndex else { return }
        delegate?.editKioskView(self, didChooseKioskAtIndex: selectedIndex)
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndex = indexPath.row
        delegate?.editKioskViewDidChangeKioskSelection(self)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return dataSource.getHeightForRow(atIndexPath: indexPath, cellWidth: tableView.bounds.width)
    }
}

extension EditKioskView: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        delegate?.editKioskView(self, didReturnSearchString: searchString)
        textField.resignFirstResponder()
        return true
    }
}

extension EditKioskView: ViewSwitcherDataSource {
    func viewSwitcherWantsErrorInfo(view: ViewSwitcher) -> (ErrorText, ErrorImage?) {
        return (tr(.CommonError), nil)
    }
    
    func viewSwitcherWantsEmptyView(view: ViewSwitcher) -> UIView? {
        return UIView()
    }
}

extension EditKioskView: KeyboardHelperDelegate, KeyboardHandler {
    func keyboardHelperChangedKeyboardState(fromFrame: CGRect, toFrame: CGRect, duration: Double, animationOptions: UIViewAnimationOptions, visible: Bool) {
        let bottomOffset = (UIScreen.mainScreen().bounds.height - toFrame.minY) - saveButton.bounds.height
        tableView.contentInset = UIEdgeInsetsMake(EditKioskView.tableViewTopInset, 0, max(bottomOffset, 0), 0)
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, max(bottomOffset, 0), 0)
    }
}
