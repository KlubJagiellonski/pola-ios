import Foundation
import UIKit
import TTRangeSlider

protocol ProductFilterPriceCellDelegate: class {
    func filterPrice(cell: ProductFilterPriceCell, didChangeRange range: PriceRange)
}

class ProductFilterPriceCell: UITableViewCell, TTRangeSliderDelegate {
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let priceRangeSlider = TTRangeSlider()
    weak var delegate: ProductFilterPriceCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        
        removeSeparatorInset()
        
        titleLabel.text = tr(.ProductListFilterRowPrice)
        titleLabel.font = UIFont(fontType: .Normal)
        titleLabel.textColor = UIColor(named: .Black)
        
        valueLabel.font = UIFont(fontType: .Normal)
        valueLabel.textColor = UIColor(named: .Manatee)
        
        priceRangeSlider.tintColor = UIColor(named: .Manatee)
        priceRangeSlider.hideLabels = true
        priceRangeSlider.lineHeight = 8
        priceRangeSlider.tintColorBetweenHandles = UIColor(named: .Blue)
        priceRangeSlider.selectedHandleDiameterMultiplier = 1.4
        priceRangeSlider.handleImage = UIImage(asset: .Slider)
        priceRangeSlider.handleDiameter = 14
        priceRangeSlider.delegate = self
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
        contentView.addSubview(priceRangeSlider)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updataData(priceRange priceRange: PriceRange, selectedPriceRange: PriceRange?) {
        priceRangeSlider.minValue = Float(priceRange.min.amount)
        priceRangeSlider.maxValue = Float(priceRange.max.amount)
        if let selectedPriceRange = selectedPriceRange {
            priceRangeSlider.selectedMinimum = Float(selectedPriceRange.min.amount)
            priceRangeSlider.selectedMaximum = Float(selectedPriceRange.max.amount)
        } else {
            priceRangeSlider.selectedMinimum = priceRangeSlider.minValue
            priceRangeSlider.selectedMaximum = priceRangeSlider.maxValue
        }
        updateValue(minValue: Int(priceRangeSlider.selectedMinimum), maxValue: Int(priceRangeSlider.selectedMaximum))
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
        priceRangeSlider.snp_makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.leading.equalToSuperview().offset(priceRangeHorizontalOffset)
            make.trailing.equalToSuperview().offset(-priceRangeHorizontalOffset)
            make.height.equalTo(20)
        }
    }
    
    private func updateValue(minValue minValue: Int, maxValue: Int) {
        valueLabel.text = tr(.ProductListFilterPriceRange(String(minValue), String(maxValue)))
    }
    
    // MARK:- TTRangeSliderDelegate
    
    func rangeSlider(sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        updateValue(minValue: Int(selectedMinimum), maxValue: Int(selectedMaximum))
    }
    
    func didEndTouchesInRangeSlider(sender: TTRangeSlider!) {
        let priceRange = PriceRange(min: Money(amt: priceRangeSlider.selectedMinimum), max: Money(amt: priceRangeSlider.selectedMaximum))
        delegate?.filterPrice(self, didChangeRange: priceRange)
    }
}
