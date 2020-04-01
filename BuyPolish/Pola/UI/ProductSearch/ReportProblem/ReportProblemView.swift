import UIKit
import UITextView_Placeholder

final class ReportProblemView: UIView {
    
    private let titleLabel = UILabel()
    let closeButton = UIButton(type: .custom)
    private let helpLabel = UILabel()
    private let photoTitleLable = UILabel()
    let imagesContainer = ReportImagesContainerView()
    private let descriptionTitleLabel = UILabel()
    let descriptionTextView = UITextView()
    private let descriptionBottomShadowView = UIView()
    let sendButtom = UIButton(type: .custom)
    fileprivate var bottomMargin = CGFloat.zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Theme.mediumBackgroundColor
        
        titleLabel.font = Theme.titleFont
        titleLabel.textColor = Theme.defaultTextColor
        titleLabel.text = R.string.localizable.report()
        titleLabel.sizeToFit()
        addSubview(titleLabel)
        
        closeButton.accessibilityLabel = R.string.localizable.accessibilityClose()
        closeButton.setImage(R.image.closeIcon(), for: .normal)
        closeButton.tintColor = Theme.defaultTextColor
        closeButton.sizeToFit()
        addSubview(closeButton)
        
        helpLabel.font = Theme.normalFont
        helpLabel.textColor = Theme.defaultTextColor
        helpLabel.text = R.string.localizable.reportHelp()
        helpLabel.numberOfLines = 0
        helpLabel.sizeToFit()
        addSubview(helpLabel)
        
        photoTitleLable.font = Theme.normalFont
        photoTitleLable.textColor = Theme.defaultTextColor
        photoTitleLable.text = R.string.localizable.photos()
        photoTitleLable.sizeToFit()
        addSubview(photoTitleLable)
        
        addSubview(imagesContainer)
        
        descriptionTitleLabel.font = Theme.normalFont
        descriptionTitleLabel.textColor = Theme.defaultTextColor
        descriptionTitleLabel.text = R.string.localizable.descriptionOptional()
        descriptionTitleLabel.sizeToFit()
        addSubview(descriptionTitleLabel)
        
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        descriptionTextView.backgroundColor = Theme.clearColor
        descriptionTextView.font = Theme.normalFont
        descriptionTextView.textColor = Theme.defaultTextColor
        descriptionTextView.placeholder = R.string.localizable.additionalInfo()
        descriptionTextView.placeholderTextView.font = Theme.normalFont
        descriptionTextView.placeholderColor = Theme.placeholderTextColor
        addSubview(descriptionTextView)
        
        descriptionBottomShadowView.backgroundColor = Theme.placeholderTextColor
        addSubview(descriptionBottomShadowView)
        
        sendButtom.setTitle(R.string.localizable.send(), for: .normal)
        sendButtom.titleLabel?.font = Theme.buttonFont
        sendButtom.setBackgroundImage(UIImage.image(color: Theme.actionColor), for: .normal)
        sendButtom.setTitleColor(Theme.clearColor, for: .normal)
        addSubview(sendButtom)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding = CGFloat(16.0)
        let titleMargin = CGFloat(10.0)
        let verticalMargin = CGFloat(25.0)
        let sendButtomHeight = CGFloat(30.0)
        let descriptionShadowHeight = CGFloat(1.0)
        let widthWithoutPadding = bounds.width - (2.0 * padding)
        
        closeButton.frameOrigin = CGPoint(
            x: bounds.width - padding - closeButton.frame.width,
            y: topSafeAreaInset + padding - bottomMargin
        )
        
        titleLabel.frameOrigin = CGPoint(
            x: padding,
            y: closeButton.frame.minY
                + (closeButton.frame.height / 2.0)
                - (titleLabel.frame.height / 2.0)
        )
        
        helpLabel.frame = CGRect(
            x: padding,
            y: closeButton.frame.maxY + verticalMargin,
            width: widthWithoutPadding,
            height: helpLabel.height(forWidth: widthWithoutPadding)
        )
        
        photoTitleLable.frameOrigin = CGPoint(
            x: padding,
            y: helpLabel.frame.maxY + verticalMargin
        )
        
        imagesContainer.frameOrigin = CGPoint(
            x: padding,
            y: photoTitleLable.frame.maxY + titleMargin
        )
        imagesContainer.frameSize = imagesContainer.sizeThatFits(CGSize(width: widthWithoutPadding, height: .zero))
        
        descriptionTitleLabel.frameOrigin = CGPoint(
            x: padding,
            y: max(imagesContainer.frame.maxY + verticalMargin - bottomMargin, padding + topSafeAreaInset)
        )
        
        sendButtom.frame = CGRect(
            x: padding,
            y: bounds.height - padding - sendButtomHeight - bottomMargin,
            width: widthWithoutPadding,
            height: sendButtomHeight
        )
        
        descriptionTextView.frame = CGRect(
            x: padding,
            y: descriptionTitleLabel.frame.maxY + titleMargin,
            width: widthWithoutPadding,
            height: sendButtom.frame.minY - verticalMargin - descriptionTitleLabel.frame.maxY
        )
        
        descriptionBottomShadowView.frame = CGRect(
            x: descriptionTextView.frame.minX,
            y: descriptionTextView.frame.maxY,
            width: descriptionTextView.frame.width,
            height: descriptionShadowHeight
        )
        
    }
    
}

extension ReportProblemView : KeyboardManagerDelegate {
    func keyboardWillShow(height: CGFloat, animationDuration: TimeInterval, animationOptions: UIView.AnimationOptions) {
        bottomMargin = height
        animateForKeyboard(duration: animationDuration, curve: animationOptions, imageAlpha: 0.0)
    }
    
    func keyboardWillHide(animationDuration: TimeInterval, animationOptions: UIView.AnimationOptions) {
        bottomMargin = .zero
        animateForKeyboard(duration: animationDuration, curve: animationOptions, imageAlpha: 1.0)
    }
    
    private func animateForKeyboard(duration: TimeInterval, curve: UIView.AnimationOptions, imageAlpha: CGFloat) {
        UIView.animate(withDuration: duration,
                       delay: .zero,
                       options: curve,
                       animations: {
                        self.imagesContainer.alpha = imageAlpha
                        self.setNeedsLayout()
                        self.layoutIfNeeded()
        }, completion: nil)
    }
}
