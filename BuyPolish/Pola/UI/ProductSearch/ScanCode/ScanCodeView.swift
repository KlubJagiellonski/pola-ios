import UIKit

final class ScanCodeView: UIView {
    let logoButton = UIButton(type: .custom)
    let menuButton = UIButton(type: .custom)
    let flashButton = UIButton(type: .custom)
    let keyboardButton = UIButton(type: .custom)
    let galleryButton = UIButton(type: .custom)

    private let leftButtonsStackView = UIStackView()
    private let buttonMargin = CGFloat(15.0)
    private let buttonSize = CGFloat(31.0)

    func setButtonsVisible(_ buttonsVisible: Bool, animated: Bool) {
        let alpha = CGFloat(buttonsVisible ? 1.0 : 0.0)
        let animationBlock = { [] in
            self.logoButton.alpha = alpha
            self.menuButton.alpha = alpha
            self.flashButton.alpha = alpha
            self.keyboardButton.alpha = alpha
            self.galleryButton.alpha = alpha
        }

        if animated {
            UIView.animate(withDuration: 0.3,
                           delay: 0.0,
                           options: [.beginFromCurrentState],
                           animations: animationBlock,
                           completion: nil)
        } else {
            animationBlock()
        }
    }

    private let dimView = UIImageView(image: R.image.gradientImage())

    override init(frame: CGRect) {
        super.init(frame: frame)

        dimView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dimView)

        logoButton.accessibilityLabel = R.string.localizable.accessibilityLogo()
        logoButton.setImage(R.image.logoIcon(), for: .normal)
        logoButton.translatesAutoresizingMaskIntoConstraints = false
        logoButton.sizeToFit()
        addSubview(logoButton)

        leftButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        leftButtonsStackView.distribution = .fillEqually
        leftButtonsStackView.axis = .vertical
        leftButtonsStackView.spacing = buttonMargin
        addSubview(leftButtonsStackView)

        menuButton.accessibilityLabel = R.string.localizable.accessibilityInfo()
        menuButton.setImage(R.image.burgerIcon(), for: .normal)
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.sizeToFit()
        addSubview(menuButton)

        keyboardButton.accessibilityLabel = R.string.localizable.accessibilityWriteCode()
        keyboardButton.setImage(R.image.keyboardIcon(), for: .normal)
        keyboardButton.setImage(R.image.keyboardSelectedIcon(), for: .selected)
        keyboardButton.translatesAutoresizingMaskIntoConstraints = false
        leftButtonsStackView.addArrangedSubview(keyboardButton)

        galleryButton.accessibilityLabel = R.string.localizable.accessibilityGallery()
        galleryButton.setImage(R.image.galleryIconNormal(), for: .normal)
        galleryButton.setImage(R.image.galleryIconSelected(), for: .selected)
        galleryButton.translatesAutoresizingMaskIntoConstraints = false
        leftButtonsStackView.addArrangedSubview(galleryButton)

        flashButton.accessibilityLabel = R.string.localizable.accessibilityFlash()
        flashButton.setImage(R.image.flashIcon(), for: .normal)
        flashButton.setImage(R.image.flashSelectedIcon(), for: .selected)
        flashButton.translatesAutoresizingMaskIntoConstraints = false
        leftButtonsStackView.addArrangedSubview(flashButton)

        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let scanCodeMargin = buttonMargin

        NSLayoutConstraint.activate([
            dimView.topAnchor.constraint(equalTo: topAnchor),
            dimView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dimView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dimView.trailingAnchor.constraint(equalTo: trailingAnchor),

            menuButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: scanCodeMargin),
            menuButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -scanCodeMargin),

            logoButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: scanCodeMargin),
            logoButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            leftButtonsStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: scanCodeMargin),
            leftButtonsStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: scanCodeMargin),

            galleryButton.heightAnchor.constraint(equalToConstant: buttonSize),
            galleryButton.widthAnchor.constraint(equalToConstant: buttonSize),
        ])
    }
}
