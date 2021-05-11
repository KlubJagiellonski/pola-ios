import UIKit

final class ScanCodeView: UIView {
    let logoButton = UIButton(type: .custom)
    let menuButton = UIButton(type: .custom)
    let flashButton = UIButton(type: .custom)
    let keyboardButton = UIButton(type: .custom)
    lazy var galleryButton: UIButton = {
        let button = UIButton(type: .custom)
        button.accessibilityLabel = "todo"
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "photo.on.rectangle.angled"), for: .normal)
        } else {
            //TODO
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

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

        addSubview(dimView)

        logoButton.accessibilityLabel = R.string.localizable.accessibilityLogo()
        logoButton.setImage(R.image.logoIcon(), for: .normal)
        logoButton.sizeToFit()
        addSubview(logoButton)

        flashButton.accessibilityLabel = R.string.localizable.accessibilityFlash()
        flashButton.setImage(R.image.flashIcon(), for: .normal)
        flashButton.setImage(R.image.flashSelectedIcon(), for: .selected)
        flashButton.sizeToFit()
        addSubview(flashButton)

        menuButton.accessibilityLabel = R.string.localizable.accessibilityInfo()
        menuButton.setImage(R.image.burgerIcon(), for: .normal)
        menuButton.sizeToFit()
        addSubview(menuButton)

        keyboardButton.accessibilityLabel = R.string.localizable.accessibilityWriteCode()
        keyboardButton.setImage(R.image.keyboardIcon(), for: .normal)
        keyboardButton.setImage(R.image.keyboardSelectedIcon(), for: .selected)
        keyboardButton.sizeToFit()
        addSubview(keyboardButton)

        galleryButton.accessibilityLabel = R.string.localizable.accessibilityGallery()
        addSubview(galleryButton)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let scanCodeMargin = CGFloat(15.0)

        dimView.frame = bounds

        let topY = topSafeAreaInset + scanCodeMargin
        keyboardButton.frameOrigin = CGPoint(x: scanCodeMargin, y: topY)

        flashButton.frameOrigin = CGPoint(
            x: scanCodeMargin,
            y: scanCodeMargin + keyboardButton.frame.maxY
        )

        menuButton.frameOrigin = CGPoint(
            x: bounds.width - scanCodeMargin - menuButton.bounds.width,
            y: topY
        )

        logoButton.frameOrigin = CGPoint(
            x: (bounds.width / 2) - (logoButton.bounds.width / 2),
            y: menuButton.frame.minY
                + (menuButton.bounds.height / 2)
                - (logoButton.bounds.height / 2)
        )

        NSLayoutConstraint.activate([
            galleryButton.centerYAnchor.constraint(equalTo: keyboardButton.centerYAnchor, constant: 50),
            galleryButton.centerXAnchor.constraint(equalTo: keyboardButton.centerXAnchor)
        ])
    }
}
