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
    let sendButton = UIButton(type: .custom)
    fileprivate var bottomMargin = CGFloat.zero
    fileprivate let padding = CGFloat(16.0)
    var imagesContainerHiddenConstraint = [NSLayoutConstraint]()
    var imagesContainerVisibleConstraint = [NSLayoutConstraint]()
    var imagesContainerHeightConstraint: NSLayoutConstraint?

    init(isImageEnabled: Bool = false) {
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Theme.mediumBackgroundColor

        setupViews(isImageEnabled: isImageEnabled)
        setupAutoLayout(isImageEnabled: isImageEnabled)
    }

    private func setupViews(isImageEnabled: Bool) {
        titleLabel.font = Theme.titleFont
        titleLabel.textColor = Theme.defaultTextColor
        titleLabel.text = R.string.localizable.report()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.sizeToFit()
        addSubview(titleLabel)

        closeButton.accessibilityLabel = R.string.localizable.accessibilityClose()
        closeButton.setImage(R.image.closeIcon(), for: .normal)
        closeButton.tintColor = Theme.defaultTextColor
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.sizeToFit()
        addSubview(closeButton)

        helpLabel.font = Theme.normalFont
        helpLabel.textColor = Theme.defaultTextColor
        helpLabel.text = isImageEnabled ? R.string.localizable.writeADataErrorRaportOrSendImages() : R.string.localizable.writeADataErrorRaport()
        helpLabel.numberOfLines = 0
        helpLabel.translatesAutoresizingMaskIntoConstraints = false
        helpLabel.sizeToFit()
        addSubview(helpLabel)

        if isImageEnabled {
            photoTitleLable.font = Theme.normalFont
            photoTitleLable.textColor = Theme.defaultTextColor
            photoTitleLable.text = R.string.localizable.photos()
            photoTitleLable.translatesAutoresizingMaskIntoConstraints = false
            photoTitleLable.sizeToFit()
            addSubview(photoTitleLable)

            imagesContainer.translatesAutoresizingMaskIntoConstraints = false
            addSubview(imagesContainer)
        }

        descriptionTitleLabel.font = Theme.normalFont
        descriptionTitleLabel.textColor = Theme.defaultTextColor
        descriptionTitleLabel.text = R.string.localizable.description()
        descriptionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionTitleLabel.sizeToFit()
        addSubview(descriptionTitleLabel)

        descriptionTextView.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        descriptionTextView.backgroundColor = Theme.clearColor
        descriptionTextView.font = Theme.normalFont
        descriptionTextView.textColor = Theme.defaultTextColor
        descriptionTextView.placeholder = R.string.localizable.additionalInfo()
        descriptionTextView.placeholderTextView.font = Theme.normalFont
        descriptionTextView.placeholderColor = Theme.placeholderTextColor
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(descriptionTextView)

        descriptionBottomShadowView.backgroundColor = Theme.placeholderTextColor
        descriptionBottomShadowView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(descriptionBottomShadowView)

        sendButton.setTitle(R.string.localizable.send(), for: .normal)
        sendButton.titleLabel?.font = Theme.buttonFont
        sendButton.setBackgroundImage(UIImage.image(color: Theme.actionColor), for: .normal)
        sendButton.setTitleColor(Theme.clearColor, for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sendButton)
    }

    private func setupAutoLayout(isImageEnabled: Bool) {
        let titleMargin = CGFloat(10.0)
        let verticalMargin = CGFloat(25.0)
        let sendButtonHeight = CGFloat(30.0)
        let descriptionShadowHeight = CGFloat(1.0)

        imagesContainerHeightConstraint = imagesContainer.heightAnchor.constraint(equalToConstant: .zero)

        imagesContainerVisibleConstraint = [
            photoTitleLable.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
            photoTitleLable.topAnchor.constraint(equalTo: helpLabel.bottomAnchor, constant: verticalMargin),
            imagesContainer.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
            imagesContainer.topAnchor.constraint(equalTo: photoTitleLable.bottomAnchor, constant: titleMargin),
            imagesContainer.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            imagesContainerHeightConstraint!,
            descriptionTitleLabel.topAnchor.constraint(equalTo: imagesContainer.bottomAnchor, constant: verticalMargin),
        ]

        imagesContainerHiddenConstraint = [
            descriptionTitleLabel.topAnchor.constraint(equalTo: helpLabel.bottomAnchor, constant: verticalMargin),
        ]

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding - bottomMargin),
            closeButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding - bottomMargin),
            helpLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
            helpLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: verticalMargin),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
            descriptionTextView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
            descriptionTextView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            descriptionTextView.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: titleMargin),
            descriptionTextView.bottomAnchor.constraint(equalTo: sendButton.topAnchor, constant: -verticalMargin),
            descriptionBottomShadowView.widthAnchor.constraint(equalTo: descriptionTextView.widthAnchor),
            descriptionBottomShadowView.heightAnchor.constraint(equalToConstant: descriptionShadowHeight),
            descriptionBottomShadowView.bottomAnchor.constraint(equalTo: descriptionTextView.bottomAnchor),
            descriptionBottomShadowView.centerXAnchor.constraint(equalTo: descriptionTextView.centerXAnchor),
            sendButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
            sendButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            sendButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding - bottomMargin),
            sendButton.heightAnchor.constraint(equalToConstant: sendButtonHeight),
        ])

        NSLayoutConstraint.activate(isImageEnabled ? imagesContainerVisibleConstraint : imagesContainerHiddenConstraint)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if imagesContainerHeightConstraint != nil {
            let imagesContainerSize = imagesContainer.sizeThatFits(CGSize(width: safeAreaLayoutGuide.layoutFrame.width - (2.0 * padding), height: .zero))
            imagesContainerHeightConstraint?.constant = imagesContainerSize.height
            updateConstraintsIfNeeded()
        }
    }
}

extension ReportProblemView: KeyboardManagerDelegate {
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
