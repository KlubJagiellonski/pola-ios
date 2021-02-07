import UIKit

final class CompanyContentView: UIView {
    let capitalTitleLabel = UILabel()
    let capitalProgressView = SecondaryProgressView()
    let notGlobalCheckRow = CheckRow()
    let registeredCheckRow = CheckRow()
    let rndCheckRow = CheckRow()
    let workersCheckRow = CheckRow()
    let friendButton = UIButton()
    let descriptionLabel = UILabel()
    private let stackView = UIStackView()
    private let padding = CGFloat(14)

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .vertical
        stackView.spacing = padding
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        let localizable = R.string.localizable.self
        capitalTitleLabel.font = Theme.normalFont
        capitalTitleLabel.textColor = Theme.defaultTextColor
        capitalTitleLabel.text = localizable.percentOfPolishHolders()
        capitalTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(capitalTitleLabel)

        capitalProgressView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(capitalProgressView)

        notGlobalCheckRow.text = localizable.notPartOfGlobalCompany()
        notGlobalCheckRow.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(notGlobalCheckRow)

        registeredCheckRow.text = localizable.isRegisteredInPoland()
        registeredCheckRow.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(registeredCheckRow)

        rndCheckRow.text = localizable.createdRichSalaryWorkPlaces()
        rndCheckRow.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(rndCheckRow)

        workersCheckRow.text = localizable.producingInPL()
        workersCheckRow.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(workersCheckRow)

        friendButton.setImage(R.image.heartFilled(), for: .normal)
        friendButton.tintColor = Theme.actionColor
        friendButton.setTitle(localizable.thisIsPolaSFriend(),
                              for: .normal)
        friendButton.setTitleColor(Theme.actionColor, for: .normal)
        friendButton.titleLabel?.font = Theme.normalFont
        let buttontitleHorizontalMargin = CGFloat(7)
        friendButton.titleEdgeInsets =
            UIEdgeInsets(top: 0, left: buttontitleHorizontalMargin, bottom: 0, right: 0)
        friendButton.contentHorizontalAlignment = .left
        friendButton.adjustsImageWhenHighlighted = false
        friendButton.isHidden = true
        friendButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(friendButton)

        descriptionLabel.font = Theme.normalFont
        descriptionLabel.textColor = Theme.defaultTextColor
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(descriptionLabel)

        createConstraints()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createConstraints() {
        addConstraints([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor),
        ])
    }
}
