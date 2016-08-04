import Foundation
import UIKit
import TTRangeSlider

protocol ProductFilterRangeCellDelegate: class {
    func filterRange(cell: ProductFilterRangeCell, didChangeRange range: ValueRange)
}

final class ProductFilterRangeCell: UITableViewCell, TTRangeSliderDelegate {
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let rangeSlider = TTRangeSlider()
    weak var delegate: ProductFilterRangeCellDelegate?
    
    var title: String? {
        set { titleLabel.text = newValue }
        get { return titleLabel.text }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        
        removeSeparatorInset()
        
        titleLabel.font = UIFont(fontType: .Normal)
        titleLabel.textColor = UIColor(named: .Black)
        
        valueLabel.font = UIFont(fontType: .Normal)
        valueLabel.textColor = UIColor(named: .Manatee)
        
        rangeSlider.tintColor = UIColor(named: .Manatee)
        rangeSlider.hideLabels = true
        rangeSlider.lineHeight = 8
        rangeSlider.tintColorBetweenHandles = UIColor(named: .Blue)
        rangeSlider.selectedHandleDiameterMultiplier = 1.4
        rangeSlider.handleImage = UIImage(asset: .Slider)
        rangeSlider.handleDiameter = 14
        rangeSlider.delegate = self
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
        contentView.addSubview(rangeSlider)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updataData(valueRange valueRange: ValueRange, selectedValueRange: ValueRange?, step: Int) {
        rangeSlider.step = Float(step)
        rangeSlider.minValue = Float(valueRange.min)
        rangeSlider.maxValue = Float(valueRange.max)
        if let selectedValueRange = selectedValueRange {
            rangeSlider.selectedMinimum = Float(selectedValueRange.min)
            rangeSlider.selectedMaximum = Float(selectedValueRange.max)
        } else {
            rangeSlider.selectedMinimum = rangeSlider.minValue
            rangeSlider.selectedMaximum = rangeSlider.maxValue
        }
        updateValue(minValue: Int(rangeSlider.selectedMinimum), maxValue: Int(rangeSlider.selectedMaximum))
    }
    
    private func configureCustomConstraints() {
        let topOffset: CGFloat = 13
        titleLabel.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(topOffset)
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
        }
        
        valueLabel.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(topOffset)
            make.trailing.equalToSuperview().offset(-Dimensions.defaultMargin)
        }
        
        let priceRangeHorizontalOffset: CGFloat = 6
        rangeSlider.snp_makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.leading.equalToSuperview().offset(priceRangeHorizontalOffset)
            make.trailing.equalToSuperview().offset(-priceRangeHorizontalOffset)
            make.height.equalTo(20)
        }
    }
    
    private func updateValue(minValue minValue: Int, maxValue: Int) {
        let minValueString = minValue == Int(rangeSlider.minValue) ? tr(.ProductListFilterMin) : String(minValue) + " zł"
        let maxValueString = maxValue == Int(rangeSlider.maxValue) ? tr(.ProductListFilterMax) : String(maxValue) + " zł"
        valueLabel.text = tr(.ProductListFilterPriceRange(minValueString, maxValueString))
    }
    
    // MARK:- TTRangeSliderDelegate
    
    func rangeSlider(sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        updateValue(minValue: Int(selectedMinimum), maxValue: Int(selectedMaximum))
    }
    
    func didEndTouchesInRangeSlider(sender: TTRangeSlider!) {
        let valueRange = ValueRange(min: Int(rangeSlider.selectedMinimum), max: Int(rangeSlider.selectedMaximum))
        delegate?.filterRange(self, didChangeRange: valueRange)
    }
}
