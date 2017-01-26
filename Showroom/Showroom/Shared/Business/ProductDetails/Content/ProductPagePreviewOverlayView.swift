import Foundation
import UIKit
import SnapKit

protocol ProductPagePreviewOverlayViewDelegate: class {
    func previewOverlayDidTapOverlay(previewOverlay: ProductPagePreviewOverlayView)
    func previewOverlayDidTapWishlistButton(previewOverlay: ProductPagePreviewOverlayView)
    func previewOverlayDidTapInfoButton(previewOverlay: ProductPagePreviewOverlayView)
}

final class ProductPagePreviewOverlayView: UIView {
    private let bottomBarHeight: CGFloat
    
    private let bottomBarView = ProductPagePreviewBottomBarView()
    
    weak var delegate: ProductPagePreviewOverlayViewDelegate?
    
    private(set) var enabled: Bool = true
    
    init(bottomBarHeight: CGFloat) {
        self.bottomBarHeight = bottomBarHeight
        
        super.init(frame: CGRectZero)
        
        userInteractionEnabled = true
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ProductPagePreviewOverlayView.didTapOverlay)))
        
        bottomBarView.infoButton.addTarget(self, action: #selector(ProductPagePreviewOverlayView.didTapInfoButton), forControlEvents: .TouchUpInside)
        bottomBarView.wishlistButton.addTarget(self, action: #selector(ProductPagePreviewOverlayView.didTapWishlistButton), forControlEvents: .TouchUpInside)
        
        addSubview(bottomBarView)
        
        configureCustonConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(withEnabled enabled: Bool, animationDuration: Double?) {
        guard enabled != self.enabled else { return }
        
        userInteractionEnabled = true
        gestureRecognizers?.forEach { $0.enabled = false }
        hidden = false
        bottomBarView.buttonHidden = enabled
        bottomBarView.alpha = enabled ? 0 : 1
        
        let firstPartAnimation = { [unowned self] in
            self.bottomBarView.buttonHidden = !enabled
        }
        
        let secondPartAnimation = { [unowned self] in
            self.bottomBarView.alpha = enabled ? 1 : 0
        }
        
        let completion = { [weak self](_: Bool) in
            guard let `self` = self else { return }
            self.enabled = enabled
            self.hidden = !enabled
            self.userInteractionEnabled = enabled
            self.gestureRecognizers?.forEach { $0.enabled = enabled }
        }
        
        if enabled {
            UIView.animateKeyframesWithDuration(animationDuration ?? 0, delay: 0, options: [], animations: {
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.5, animations: secondPartAnimation)
                UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.5, animations: firstPartAnimation)
            }, completion: completion)
        } else {
            UIView.animateKeyframesWithDuration(animationDuration ?? 0, delay: 0, options: [], animations: {
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.5, animations: firstPartAnimation)
                UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.5, animations: secondPartAnimation)
                }, completion: completion)
        }
    }
    
    func update(withWishlistButtonSelected selected: Bool) {
        bottomBarView.wishlistButton.selected = selected
    }
    
    @objc private func didTapOverlay() {
        delegate?.previewOverlayDidTapOverlay(self)
    }
    
    @objc private func didTapInfoButton() {
        delegate?.previewOverlayDidTapInfoButton(self)
    }
    
    @objc private func didTapWishlistButton() {
        delegate?.previewOverlayDidTapWishlistButton(self)
    }
    
    private func configureCustonConstraints() {
        bottomBarView.snp_makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(bottomBarHeight)
        }
    }
}

final class ProductPagePreviewBottomBarView: UIView {
    private let verticalSeparatorView = UIView()
    private let wishlistButtonContentView = UIView()
    private let wishlistButton = UIButton()
    private let infoButtonContentView = UIView()
    private let infoButton = UIButton()
    
    private var wishlistButtonCenterYConstraint: Constraint?
    private var infoButtonCenterYConstraint: Constraint?
    
    private var buttonHidden: Bool = false {
        didSet {
            let offset = buttonHidden ? bounds.height : 0
            wishlistButtonCenterYConstraint?.updateOffset(offset)
            infoButtonCenterYConstraint?.updateOffset(offset)
            wishlistButtonContentView.layoutIfNeeded()
            infoButtonContentView.layoutIfNeeded()
        }
    }
    
    init() {
        super.init(frame: CGRectZero)
        
        userInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ProductPagePreviewBottomBarView.didTapBottomBarView)))
        
        verticalSeparatorView.backgroundColor = UIColor(named: .Separator)
        
        backgroundColor = UIColor(hex: "f9f9f9")
        
        wishlistButton.setImage(UIImage(asset: .Ic_heart_big), forState: .Normal)
        wishlistButton.setImage(UIImage(asset: .Ic_heart_filled_big), forState: .Selected)
        
        infoButton.setImage(UIImage(asset: .Ic_info_big), forState: .Normal)
        
        wishlistButtonContentView.addSubview(wishlistButton)
        infoButtonContentView.addSubview(infoButton)
        
        addSubview(verticalSeparatorView)
        addSubview(wishlistButtonContentView)
        addSubview(infoButtonContentView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapBottomBarView() {}
    
    private func configureCustomConstraints() {
        verticalSeparatorView.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(Dimensions.boldSeparatorThickness)
            make.height.equalTo(28)
        }
        
        wishlistButtonContentView.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.trailing.equalTo(verticalSeparatorView.snp_leading)
            make.bottom.equalToSuperview()
        }
        
        infoButtonContentView.snp_makeConstraints { make in
            make.top.equalTo(wishlistButton)
            make.leading.equalTo(verticalSeparatorView.snp_trailing)
            make.trailing.equalToSuperview().offset(-Dimensions.defaultMargin)
            make.bottom.equalTo(wishlistButton)
        }
        
        wishlistButton.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            wishlistButtonCenterYConstraint = make.centerY.equalToSuperview().constraint
            make.height.equalToSuperview()
            make.width.equalTo(wishlistButton.snp_height)
        }
        
        infoButton.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            infoButtonCenterYConstraint = make.centerY.equalToSuperview().constraint
            make.height.equalToSuperview()
            make.width.equalTo(infoButton.snp_height)
        }
    }
}
