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

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)

        stackView.axis = .horizontal
        stackView.spacing = .zero
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)

        createConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createConstraints() {
        addConstraints([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),

            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            stackView.widthAnchor.constraint(greaterThanOrEqualTo: scrollView.widthAnchor),

            heightAnchor.constraint(equalToConstant: logoHeight)
        ])
    }
}
