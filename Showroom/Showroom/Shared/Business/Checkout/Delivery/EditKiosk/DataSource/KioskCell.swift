import UIKit
import MapKit

class KioskCell: UITableViewCell {
    static let checkBoxLeftOffset: CGFloat = 27.0
    static let titleLeftOffset: CGFloat = 70.0
    static let interLabelVerticalOffset: CGFloat = 5.0
    static let descriptionBottomInset: CGFloat = 25.0
    static let descriptionLines = 4
    
    static let titleAndDistanceFont = UIFont(fontType: .FormNormal)
    static let descriptionFont = UIFont(fontType: .Description)
    
    private let checkBoxImageView = UIImageView()
    var titleLabel = UILabel()
    let distanceLabel = UILabel()
    var descriptionLabel = UILabel()
    
    override var selected: Bool { didSet { checkBoxImageView.image = selected ? UIImage(asset: .Ic_checkbox_on) : UIImage(asset: .Ic_checkbox_off) } }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        selected = false
        
        checkBoxImageView.tintColor = UIColor(named: .Black)
        
        titleLabel.font = KioskCell.titleAndDistanceFont
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .ByWordWrapping
        
        distanceLabel.font = KioskCell.titleAndDistanceFont
        
        descriptionLabel.font = KioskCell.descriptionFont
        descriptionLabel.numberOfLines = KioskCell.descriptionLines
        descriptionLabel.lineBreakMode = .ByWordWrapping
        
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(checkBoxImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(distanceLabel)
        contentView.addSubview(descriptionLabel)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(kiosk: Kiosk) {
        let strings = kiosk.kioskCellStrings
        titleLabel.text = strings.title
        distanceLabel.text = strings.distance
        descriptionLabel.text = strings.description
    }
    
    static func height(forKiosk kiosk: Kiosk, cellWidth: CGFloat) -> CGFloat {
        let labelWidth = cellWidth - KioskCell.titleLeftOffset - Dimensions.defaultMargin
        let strings = kiosk.kioskCellStrings
        
        let titleHeight = strings.title.heightWithConstrainedWidth(labelWidth, font: KioskCell.titleAndDistanceFont)
        let distanceHeight = strings.distance.heightWithConstrainedWidth(labelWidth, font: KioskCell.titleAndDistanceFont)
        let descriptionHeight = strings.description.heightWithConstrainedWidth(labelWidth, font: KioskCell.descriptionFont, numberOfLines: KioskCell.descriptionLines)

        let rowHeight = titleHeight + KioskCell.interLabelVerticalOffset + distanceHeight + KioskCell.interLabelVerticalOffset + descriptionHeight + KioskCell.descriptionBottomInset

        return rowHeight
    }
    
    private func configureCustomConstraints() {
        checkBoxImageView.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
        checkBoxImageView.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
        checkBoxImageView.snp_makeConstraints { make in
            make.leading.equalToSuperview().offset(KioskCell.checkBoxLeftOffset)
            make.top.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        titleLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        titleLabel.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        titleLabel.snp_makeConstraints { make in
            make.leading.equalToSuperview().offset(KioskCell.titleLeftOffset)
            make.trailing.equalToSuperview().inset(Dimensions.defaultMargin)
            make.top.equalToSuperview()
        }
        
        distanceLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        distanceLabel.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        distanceLabel.snp_makeConstraints { make in
            make.leading.equalToSuperview().offset(KioskCell.titleLeftOffset)
            make.trailing.equalToSuperview().inset(Dimensions.defaultMargin)
            make.top.equalTo(titleLabel.snp_bottom).offset(KioskCell.interLabelVerticalOffset)
        }
        
        descriptionLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        descriptionLabel.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        descriptionLabel.snp_makeConstraints { make in
            make.leading.equalToSuperview().offset(KioskCell.titleLeftOffset)
            make.trailing.equalToSuperview().inset(Dimensions.defaultMargin)
            make.top.equalTo(distanceLabel.snp_bottom).offset(KioskCell.interLabelVerticalOffset)
        }
    }
}

private extension Kiosk {
    
    var kioskCellStrings: (title: String, distance: String, description: String) {
        let title = self.city + " " + self.street
        let distanceFormatter = MKDistanceFormatter()
        distanceFormatter.units = .Metric
        let distance = distanceFormatter.stringFromDistance(self.distance*1000)
        let description = self.displayName + "\n" + self.workingHours.joinWithSeparator("\n")
        return (title: title, distance: distance, description: description)

    }
}
