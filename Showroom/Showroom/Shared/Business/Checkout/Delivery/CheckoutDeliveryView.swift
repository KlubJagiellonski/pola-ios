import UIKit

protocol CheckoutDeliveryViewDelegate: class {
    func checkoutDeliveryViewDidSelectAddress(view: CheckoutDeliveryView, atIndex addressIndex: Int)
    func checkoutDeliveryViewDidTapAddAddressButton(view: CheckoutDeliveryView)
    func checkoutDeliveryViewDidTapEditAddressButton(view: CheckoutDeliveryView)
    func checkoutDeliveryViewDidTapChooseKioskButton(view: CheckoutDeliveryView)
    func checkoutDeliveryViewDidTapChangeKioskButton(view: CheckoutDeliveryView)
    func checkoutDeliveryViewDidTapNextButton(view: CheckoutDeliveryView)
}

class CheckoutDeliveryView: UIView {
    static let buttonHeight: CGFloat = 52.0
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let nextButton = UIButton()
    private let topSeparator = UIView()
    
    private let keyboardHelper = KeyboardHelper()
    
    private(set) var addressInput: AddressInput
    private var didAddAddress: Bool
    var addressOptionViews: [CheckoutDeliveryAddressOptionView]? // TODO: weak?
    var selectedAddressIndex: Int! {
        didSet {
            guard case .Options = addressInput else { return }
            updateAddressOptions(selectedIndex: selectedAddressIndex)
        }
    }
    
    weak var delegate: CheckoutDeliveryViewDelegate?
    
    init(addressInput: AddressInput, delivery: Delivery) {
        self.addressInput = addressInput
        self.didAddAddress = false
        super.init(frame: CGRectZero)
        
        keyboardHelper.delegate = self
        
        backgroundColor = UIColor(named: .White)
        
        topSeparator.backgroundColor = UIColor(named: .Manatee)
        addSubview(topSeparator)
        
        if case .Options = addressInput {
            addressOptionViews = [CheckoutDeliveryAddressOptionView]()
        }
        
        scrollView.bounces = true
        scrollView.showsVerticalScrollIndicator = false
        addSubview(scrollView)
        
        stackView.axis = .Vertical
        updateStackView(addressInput, delivery: delivery)
        scrollView.addSubview(stackView)

        if case .Options = addressInput {
            updateAddressOptions(selectedIndex: 0)
        }
        
        nextButton.setTitle(tr(.CheckoutDeliveryNext), forState: .Normal)
        nextButton.addTarget(self, action: #selector(CheckoutDeliveryView.didTapNextButton), forControlEvents: .TouchUpInside)
        nextButton.applyBlueStyle()
        addSubview(nextButton)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CheckoutDeliveryView.dismissKeyboard))
        scrollView.addGestureRecognizer(tap)
        
        configureCustomCostraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCustomCostraints() {
        topSeparator.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(Dimensions.defaultSeparatorThickness)
        }
        
        scrollView.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(topSeparator.snp_bottom)
        }
        
        stackView.snp_makeConstraints { make in
            make.edges.equalTo(scrollView.snp_edges)
            make.width.equalTo(self)
        }
        
        nextButton.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(scrollView.snp_bottom)
            make.bottom.equalToSuperview()
            make.height.equalTo(CheckoutDeliveryView.buttonHeight)
        }
        
        
    }
    
    func registerOnKeyboardEvent() {
        keyboardHelper.register()
    }
    
    func unregisterOnKeyboardEvent() {
        keyboardHelper.unregister()
    }
    
    func updateStackView(addressInput: AddressInput, delivery: Delivery) {
        stackView.addArrangedSubview(CheckoutDeliveryInfoHeaderView(delivery: .Courier))
        
        switch addressInput {
        case .Form(let fields):
            for field in fields {
                stackView.addArrangedSubview(CheckoutDeliveryInputView(inputType: field))
            }
            
        case .Options(let addresses):
            stackView.addArrangedSubview(CheckoutDeliveryLabelView(text: tr(.CheckoutDeliveryAdressHeader)))
            
            for address in addresses {
                let addressOptionView = CheckoutDeliveryAddressOptionView(address: address, selected: false)
                addressOptionView.deliveryView = self
                stackView.addArrangedSubview(addressOptionView)
                addressOptionViews?.append(addressOptionView)
            }
            
            let editButtonView = CheckoutDeliveryEditButtonView(editingType: (didAddAddress ? .Edit : .Add))
            editButtonView.deliveryView = self
            stackView.addArrangedSubview(editButtonView)
        }
        
        stackView.addArrangedSubview(CheckoutDeliveryLabelView(text: tr(.CheckoutDeliveryDeliveryHeader)))
        
        let deliveryDetailsView = CheckoutDeliveryDetailsView(delivery: delivery)
        deliveryDetailsView.deliveryView = self
        stackView.addArrangedSubview(deliveryDetailsView)
    }
    
    func updateAddressOptions(selectedIndex selectedIndex: Int) {
        guard case .Options = addressInput else { return }
        for (index, addressOptionView) in addressOptionViews!.enumerate() {
            addressOptionView.selected = (index == selectedIndex)
        }
    }
    
    func didTapAddressOptionView(addressOptionView: CheckoutDeliveryAddressOptionView) {
        selectedAddressIndex = addressOptionViews?.indexOf(addressOptionView)
        delegate?.checkoutDeliveryViewDidSelectAddress(self, atIndex: selectedAddressIndex)
    }
    
    func dataSourceDidTapAddAddressButton() {
        delegate?.checkoutDeliveryViewDidTapAddAddressButton(self)
    }
    
    func dataSourceDidTapEditAddressButton() {
        delegate?.checkoutDeliveryViewDidTapEditAddressButton(self)
    }
    
    func dataSourceDidTapChooseKioskButton() {
        delegate?.checkoutDeliveryViewDidTapChooseKioskButton(self)
    }
    
    func dataSourceDidTapChangeKioskButton() {
        delegate?.checkoutDeliveryViewDidTapChangeKioskButton(self)
    }
    
    func didTapNextButton() {
        delegate?.checkoutDeliveryViewDidTapNextButton(self)
    }
    
    func dismissKeyboard() {
        endEditing(true)
    }
}

extension CheckoutDeliveryView: KeyboardHelperDelegate {
    func keyboardHelperChangedKeyboardState(fromFrame: CGRect, toFrame: CGRect, duration: Double, animationOptions: UIViewAnimationOptions) {
        let bottomOffset = (UIScreen.mainScreen().bounds.height - toFrame.minY) - nextButton.bounds.height
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, max(bottomOffset, 0), 0)
    }
}