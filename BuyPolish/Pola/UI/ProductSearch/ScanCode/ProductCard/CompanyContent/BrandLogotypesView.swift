import UIKit

final class BrandLogotypesView: UIView {
    private let stackView = UIStackView()
    private let scrollView = UIScrollView()

    private let logoHeight = CGFloat(100.0)

    var brands: [Brand]? {
        didSet {
            stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            brands?.forEach { brand in
                guard let logotypeUrl = brand.logotypeUrl else {
                    return
                }
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFit
                imageView.load(from: logotypeUrl, resizeToHeight: logoHeight)
                imageView.isHidden = true
                stackView.addArrangedSubview(imageView)
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .horizontal
        stackView.spacing = .zero
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        createConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createConstraints() {
        addConstraints([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            heightAnchor.constraint(equalToConstant: logoHeight)
        ])
    }
}
