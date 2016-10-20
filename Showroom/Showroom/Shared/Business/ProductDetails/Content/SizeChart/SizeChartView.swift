import Foundation
import UIKit
import SnapKit

class SizeChartView: UIView {
    private let headerHeight: CGFloat = Dimensions.navigationBarHeight
    
    private let headerBackgroundView = UIView()
    private let mainScrollView: SizeChartMainScrollView
    
    var contentInset: UIEdgeInsets? {
        didSet {
            let mainScrollViewInsets = mainScrollView.defaultInsets
            mainScrollView.contentInset = UIEdgeInsetsMake(mainScrollViewInsets.top, mainScrollViewInsets.left, mainScrollViewInsets.bottom + (contentInset?.bottom ?? 0), mainScrollViewInsets.right)
            mainScrollView.scrollIndicatorInsets = contentInset ?? UIEdgeInsetsZero
        }
    }
    var headerHidden: Bool {
        set { headerBackgroundView.hidden = newValue }
        get { return headerBackgroundView.hidden }
    }
    
    init(sizes: [ProductDetailsSize]) {
        mainScrollView = SizeChartMainScrollView(sizes: sizes)
        super.init(frame: CGRectZero)
        
        headerBackgroundView.backgroundColor = UIColor(named: .White)
        
        addSubview(headerBackgroundView)
        addSubview(mainScrollView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainScrollView.invalidateShadows()
    }
    
    func updateHeaderBackground(visible: Bool, animationDuration: NSTimeInterval = 0) {
        headerBackgroundView.alpha = visible ? 0 : 1
        headerBackgroundView.hidden = false
        UIView.animateWithDuration(animationDuration, animations: {
            self.headerBackgroundView.alpha = visible ? 1 : 0
        }) { _ in
            self.headerBackgroundView.hidden = visible ? false : true
            self.headerBackgroundView.alpha = 1
        }
    }

    private func configureCustomConstraints() {
        headerBackgroundView.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(headerHeight)
        }
        
        mainScrollView.snp_makeConstraints { make in
            make.top.equalTo(headerBackgroundView.snp_bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

class SizeChartMainScrollView: UIScrollView, UIScrollViewDelegate {
    let defaultInsets = UIEdgeInsetsMake(30, 12, 30, 0)
    private let firstColumnWidth: CGFloat = 133
    private let columnWidth: CGFloat = 46
    private let separatorSize: CGFloat = 1
    private let gradientWidth: CGFloat = 30
    private let shadowVisibilityOffset: CGFloat = 5
    
    let internalScrollView = UIScrollView()
    let mainStackView = UIStackView()
    let internalStackView = UIStackView()
    let leftGradient = CAGradientLayer()
    let rightGradient = CAGradientLayer()
    
    init(sizes: [ProductDetailsSize]) {
        super.init(frame: CGRectZero)
        
        showsHorizontalScrollIndicator = true
        contentInset = defaultInsets
        backgroundColor = UIColor(named: .White)
        
        let gradientColors = [UIColor(named: .White).CGColor, UIColor(named: .White).colorWithAlphaComponent(0).CGColor]
        leftGradient.colors = gradientColors
        leftGradient.startPoint = CGPointMake(0.0, 0.5)
        leftGradient.endPoint = CGPointMake(1.0, 0.5)
        rightGradient.colors = gradientColors
        rightGradient.startPoint = CGPointMake(1.0, 0.5)
        rightGradient.endPoint = CGPointMake(0.0, 0.5)
        
        mainStackView.axis = .Horizontal
        mainStackView.distribution = .Fill
        
        internalStackView.axis = .Horizontal
        internalStackView.distribution = .Fill
        internalScrollView.delegate = self
        
        if let firstSize = sizes.first {
            let names: [MeasurementName] = Array(firstSize.measurements.keys)
            
            let firstColumn = SizeChartRowView(names: names, productDetailsSize: nil)
            firstColumn.snp_makeConstraints { make in
                make.width.equalTo(firstColumnWidth)
            }
            mainStackView.addArrangedSubview(firstColumn)
            mainStackView.addArrangedSubview(createHorizontalSeparator())
            
            for (index, size) in sizes.enumerate() {
                let column = SizeChartRowView(names: names, productDetailsSize: size)
                column.snp_makeConstraints { make in
                    make.width.equalTo(columnWidth)
                }
                internalStackView.addArrangedSubview(column)
                if index != sizes.count - 1 {
                    internalStackView.addArrangedSubview(createHorizontalSeparator())
                }
            }
        }
        
        internalScrollView.addSubview(internalStackView)
        mainStackView.addArrangedSubview(internalScrollView)
        mainStackView.layer.addSublayer(leftGradient)
        mainStackView.layer.addSublayer(rightGradient)
        
        addSubview(mainStackView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func invalidateShadows() {
        leftGradient.frame = CGRectMake(internalScrollView.frame.minX, 0, gradientWidth, leftGradient.superlayer!.bounds.height)
        rightGradient.frame = CGRectMake(rightGradient.superlayer!.bounds.width - gradientWidth, 0, gradientWidth, rightGradient.superlayer!.bounds.height)
        updateShadowsVisibility()
    }
    
    private func configureCustomConstraints() {
        mainStackView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        internalScrollView.snp_makeConstraints { make in
            make.width.equalTo(mainStackView.superview!).offset(-(firstColumnWidth + defaultInsets.left + separatorSize))
        }
        
        internalStackView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func createHorizontalSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = UIColor(named: .Separator)
        
        separator.snp_makeConstraints { make in
            make.width.equalTo(separatorSize)
        }
        
        return separator
    }
    
    func updateShadowsVisibility() {
        let leftGradientVisible = internalScrollView.contentOffset.x > shadowVisibilityOffset
        leftGradient.opacity = leftGradientVisible ? 1 : 0
        let rightGradientVisible = (internalScrollView.contentOffset.x + internalScrollView.bounds.width) < (internalScrollView.contentSize.width - shadowVisibilityOffset)
        rightGradient.opacity = rightGradientVisible ? 1 : 0
    }
    
    // MARK:- UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        updateShadowsVisibility()
    }
}

class SizeChartRowView: UIStackView {
    private let firstColumn: Bool
    private let rowHeight: CGFloat = 47
    private let titleHeight: CGFloat = 27

    init(names: [MeasurementName], productDetailsSize: ProductDetailsSize?) {
        firstColumn = productDetailsSize == nil
        super.init(frame: CGRectZero)
        axis = .Vertical
        
        if let size = productDetailsSize where !firstColumn {
            addTitleLabel(size.name)
            addSeparator()
            for name in names {
                let measurement = size.measurements[name]
                addRowLabel(measurement)
                addSeparator()
            }
        } else {
            addTitleLabel(tr(.ProductDetailsSizeChartSize))
            addSeparator()
            for name in names {
                addRowLabel(name)
                addSeparator()
            }
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTitleLabel(title: String) {
        let label = UILabel()
        label.font = UIFont(fontType: .FormNormal)
        label.text = title
        label.numberOfLines = 1
        label.textColor = UIColor(named: .Black)
        label.textAlignment = firstColumn ? .Left : .Center
        
        addArrangedSubview(createCellContainer(label, height: titleHeight))
    }
    
    func addRowLabel(title: String?) {
        let label = UILabel()
        label.font = UIFont(fontType: .FormNormal)
        label.text = title
        label.numberOfLines = 2
        label.textColor = firstColumn ? UIColor(named: .Black) : UIColor(named: .DarkGray)
        label.textAlignment = firstColumn ? .Left : .Center
        
        let rightMargin: CGFloat = firstColumn ? 10 : 0
        addArrangedSubview(createCellContainer(label, height: rowHeight, rightMargin: rightMargin))
    }
    
    func createCellContainer(content: UIView, height: CGFloat, rightMargin: CGFloat = 0) -> UIView {
        let cellView = UIView()
        cellView.addSubview(content)
        
        cellView.snp_makeConstraints { make in
            make.height.equalTo(height)
        }
        content.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().inset(rightMargin)
            make.bottom.equalToSuperview().inset(6)
        }
        return cellView
    }
    
    func addSeparator() {
        let separator = UIView()
        separator.backgroundColor = UIColor(named: .Separator)
        
        separator.snp_makeConstraints { make in
            make.height.equalTo(1)
        }
        
        addArrangedSubview(separator)
    }
}
