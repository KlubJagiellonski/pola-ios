import UIKit

final class OwnBrandCompanyTitleView: UIView {
    private let titleLabel = UILabel()
    private let progressView = MainProggressView(frame: .zero)

    var title: String = "" {
        didSet {
            titleLabel.text = title
            titleLabel.sizeToFit()
            setNeedsLayout()
        }
    }

    var progress = CGFloat(0) {
        didSet {
            progressView.progress = progress
            progressView.sizeToFit()
            setNeedsLayout()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        titleLabel.font = Theme.titleFont
        titleLabel.textColor = Theme.defaultTextColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

        progressView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(progressView)

        let labelMargin = CGFloat(10)

        addConstraints([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: labelMargin),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -labelMargin),
            progressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: labelMargin),
            progressView.leftAnchor.constraint(equalTo: leftAnchor),
            progressView.rightAnchor.constraint(equalTo: rightAnchor),
            progressView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
