import UIKit

class OwnBrandContentView: UIView {
    let primaryCompanyTitleView = OwnBrandCompanyTitleView(frame: .zero)
    let secondaryCompanyTitleView = OwnBrandCompanyTitleView(frame: .zero)

    let descriptionView = UILabel(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false
        primaryCompanyTitleView.translatesAutoresizingMaskIntoConstraints = false
        primaryCompanyTitleView.sizeToFit()
        primaryCompanyTitleView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        addSubview(primaryCompanyTitleView)

        secondaryCompanyTitleView.translatesAutoresizingMaskIntoConstraints = false
        secondaryCompanyTitleView.sizeToFit()
        secondaryCompanyTitleView.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        addSubview(secondaryCompanyTitleView)

        descriptionView.font = Theme.normalFont
        descriptionView.textColor = Theme.defaultTextColor
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.numberOfLines = 0
        descriptionView.sizeToFit()
        descriptionView.lineBreakMode = .byWordWrapping
        addSubview(descriptionView)

        let verticalPadding = CGFloat(20)
        let horizontalHeaderPadding = CGFloat(0)
        let horizontalTextPadding = CGFloat(0)

        addConstraints([
            primaryCompanyTitleView.topAnchor.constraint(equalTo: topAnchor),
            primaryCompanyTitleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalHeaderPadding),
            primaryCompanyTitleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalTextPadding),
            secondaryCompanyTitleView.topAnchor.constraint(equalTo: primaryCompanyTitleView.bottomAnchor, constant: verticalPadding),
            secondaryCompanyTitleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalHeaderPadding),
            secondaryCompanyTitleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalTextPadding),
            descriptionView.topAnchor.constraint(equalTo: secondaryCompanyTitleView.bottomAnchor, constant: verticalPadding),
            descriptionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalTextPadding),
            descriptionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalTextPadding),
            bottomAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: verticalPadding),
        ])

        setNeedsLayout()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
