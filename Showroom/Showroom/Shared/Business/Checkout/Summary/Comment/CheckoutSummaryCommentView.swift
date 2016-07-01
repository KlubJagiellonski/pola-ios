import Foundation
import UIKit
import SnapKit

protocol CheckoutSummaryCommentViewDelegate: class {
    func checkoutSummaryCommentViewDidTapClose(view: CheckoutSummaryCommentView)
    func checkoutSummaryCommentViewDidTapSave(view: CheckoutSummaryCommentView)
}

class CheckoutSummaryCommentView: UIView {
    private let titleLable = UILabel()
    private let commentView = ExtendedTextView()
    private let saveButton = UIButton()
    private let closeButton = UIButton()
    let keyboardHelper = KeyboardHelper()
    
    var comment: String {
        get {
            return commentView.text
        }
    }
    
    weak var delegate: CheckoutSummaryCommentViewDelegate?
    
    init(comment: String?) {
        super.init(frame: CGRectZero)
        
        keyboardHelper.delegate = self
        
        closeButton.setImage(UIImage(asset: .Ic_close), forState: .Normal)
        closeButton.addTarget(self, action: #selector(CheckoutSummaryCommentView.didTapClose), forControlEvents: .TouchUpInside)
        
        titleLable.text = tr(.CheckoutSummaryCommentTitle).uppercaseString
        titleLable.font = UIFont(fontType: .Bold)
        titleLable.textColor = UIColor(named: .Black)
        titleLable.numberOfLines = 2
        titleLable.textAlignment = .Center
        
        commentView.applyPlainStyle()
        commentView.placeholder = tr(.CheckoutSummaryCommentPlaceholder)
        commentView.text = comment
        
        saveButton.applyBlueStyle()
        saveButton.setTitle(tr(.CheckoutSummarySaveComment), forState: .Normal)
        saveButton.addTarget(self, action: #selector(CheckoutSummaryCommentView.didTapSave), forControlEvents: .TouchUpInside)
        
        backgroundColor = UIColor(named: .White)
        
        addSubview(titleLable)
        addSubview(commentView)
        addSubview(saveButton)
        addSubview(closeButton)
        
        configureCustomConstraints()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CheckoutSummaryCommentView.dismissKeyboard))
        addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        closeButton.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo((closeButton.currentImage?.size.width ?? 0) + Dimensions.defaultMargin * 2)
            make.height.equalTo(closeButton.snp_width)
        }
        
        titleLable.snp_makeConstraints { make in
            make.firstBaseline.equalTo(self.snp_top).offset(titleLable.font.capHeight + Dimensions.defaultMargin)
            make.left.equalTo(closeButton.snp_right)
            make.centerX.equalToSuperview()
        }
        
        commentView.snp_makeConstraints { make in
            make.top.equalTo(titleLable.snp_bottom).offset(Dimensions.defaultMargin)
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
            make.bottom.equalTo(saveButton.snp_top).offset(-Dimensions.defaultMargin)
        }
        
        saveButton.snp_makeConstraints { make in
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
            make.bottom.equalToSuperview().inset(Dimensions.defaultMargin)
            make.height.equalTo(Dimensions.bigButtonHeight)
        }
    }
    
    func dismissKeyboard() {
        endEditing(true)
    }
    
    func didTapClose() {
        logInfo("Close comment modal")
        delegate?.checkoutSummaryCommentViewDidTapClose(self)
    }
    
    func didTapSave() {
        logInfo("Save comment: " + commentView.text! + " and close modal")
        delegate?.checkoutSummaryCommentViewDidTapSave(self)
    }
}

extension CheckoutSummaryCommentView: KeyboardHandler, KeyboardHelperDelegate {
    func keyboardHelperChangedKeyboardState(fromFrame: CGRect, toFrame: CGRect, duration: Double, animationOptions: UIViewAnimationOptions) {
        frame.origin.y = (toFrame.minY - frame.height) * 0.5
        
        self.setNeedsLayout()
        let animations = {
            self.layoutIfNeeded()
        }
        UIView.animateWithDuration(duration, delay: 0, options: animationOptions, animations: animations, completion: nil)
    }
}
