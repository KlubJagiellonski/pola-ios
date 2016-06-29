import UIKit

protocol EditKioskViewDelegate: ViewSwitcherDelegate {
    func editKioskViewDidReturnSearchString(view: EditKioskView, searchString: String)
    func editKioskViewDidChooseKioskAtIndex(view: EditKioskView, kioskIndex: Int)
}

class EditKioskView: UIView, KioskSearchInputFieldDelegate, KioskOptionViewDelegate {
    
    private let topSeparator = UIView()
    private let searchInputView = KioskSearchInputField()
    private let viewSwitcher: ViewSwitcher
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    var kiosksViews = [KioskOptionView]()
    private let saveButton = UIButton()
    
    var switcherState: ViewSwitcherState {
        get { return viewSwitcher.switcherState }
        set { viewSwitcher.switcherState = newValue }
    }
    
    var searchString: String {
        get { return searchInputView.searchString }
        set { searchInputView.searchString = newValue }
    }
    
    var selectedKioskIndex: Int? {
        didSet {
            guard let _ = selectedKioskIndex else { return }
            updateKiosksSelection()
        }
    }
    
    var geocodingErrorVisible: Bool {
        didSet {
            searchInputView.errorString = geocodingErrorVisible ? tr(.CheckoutDeliveryEditKioskGeocodingError) : nil
        }
    }
    
    var saveButtonEnabled: Bool {
        set { saveButton.enabled = newValue }
        get { return saveButton.enabled }
    }
  
    weak var delegate: EditKioskViewDelegate? {
        didSet {
            viewSwitcher.switcherDelegate = delegate
        }
    }
    
    init(kioskSearchString: String) {
        viewSwitcher = ViewSwitcher(successView: scrollView, initialState: .Success)
        geocodingErrorVisible = false
        super.init(frame: CGRectZero)
        
        viewSwitcher.switcherDataSource = self
        
        backgroundColor = UIColor(named: .White)
        
        topSeparator.backgroundColor = UIColor(named: .Manatee)
        
        searchString = kioskSearchString
        searchInputView.delegate = self

        scrollView.bounces = true
        scrollView.showsVerticalScrollIndicator = false

        stackView.axis = .Vertical
        scrollView.addSubview(stackView)

        saveButton.setTitle(tr(.CheckoutDeliveryEditKioskSave), forState: .Normal)
        saveButton.addTarget(self, action: #selector(EditKioskView.didTapSaveButton), forControlEvents: .TouchUpInside)
        saveButton.applyBlueStyle()
        
        addSubview(topSeparator)
        addSubview(searchInputView)
        addSubview(viewSwitcher)
        addSubview(saveButton)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditKioskView.dismissKeyboard))
        addGestureRecognizer(tap)
        
        configureCustomCostraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateKiosks(kiosks: [Kiosk]) {
        kiosksViews.removeAll()
        for view in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        for kiosk in kiosks {
            let kioskView = KioskOptionView(kiosk: kiosk, selected: false)
            kioskView.delegate = self
            stackView.addArrangedSubview(kioskView)
            kiosksViews.append(kioskView)
        }
        
        selectedKioskIndex = 0
    }
    
    func updateKiosksSelection() {
        for (index, kioskView) in kiosksViews.enumerate() {
            kioskView.selected = (index == selectedKioskIndex)
        }
    }
    
    func kioskOptionViewDidTap(view: KioskOptionView) {
        selectedKioskIndex = kiosksViews.indexOf(view)
    }
    
    func configureCustomCostraints() {
        topSeparator.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(Dimensions.defaultSeparatorThickness)
        }
        
        searchInputView.snp_makeConstraints { make in
            make.top.equalTo(topSeparator.snp_bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        viewSwitcher.snp_makeConstraints { make in
            make.top.equalTo(searchInputView.snp_bottom)
            make.bottom.equalTo(saveButton.snp_top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        stackView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        saveButton.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(CheckoutDeliveryView.buttonHeight)
        }
    }
    
    func dismissKeyboard() {
        endEditing(true)
    }

    func didTapSaveButton() {
        guard let selectedKioskIndex = selectedKioskIndex else { return }
        delegate?.editKioskViewDidChooseKioskAtIndex(self, kioskIndex: selectedKioskIndex)
    }
    
    func kioskSearchInputDidReturn(view: KioskSearchInputField, searchString: String) {
        delegate?.editKioskViewDidReturnSearchString(self, searchString: searchString)
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
