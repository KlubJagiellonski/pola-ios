import Foundation
import UIKit

class VerticalPageControl: UIView {
    private let dotDiameter: CGFloat = 9
    private let dotMargin: CGFloat = 9
    private let dotSelectedColor = UIColor(named: .Black)
    private let dotColor = UIColor(named: .OldLavender)
    
    var numberOfPages: Int {
        get { return circleShapeLayers.count }
        set {
            for shapeLayer in circleShapeLayers {
                shapeLayer.removeFromSuperlayer()
            }
            for _ in 0...(newValue - 1) {
                let shapeLayer = CAShapeLayer()
                shapeLayer.shouldRasterize = false
                circleShapeLayers.append(shapeLayer)
                layer.addSublayer(shapeLayer)
            }
            
            updateShapeLayers()
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }
    var currentPage: Int = 0 {
        didSet {
            updateShapeLayers()
        }
    }
    
    private var percent: CGFloat = 1
    private var circleShapeLayers: [CAShapeLayer] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var dotFrame = CGRectMake(0, 0, dotDiameter, dotDiameter)
        let dotBounds = CGRectMake(0, 0, dotFrame.width, dotFrame.height)
        
        for shapeLayer in circleShapeLayers {
            shapeLayer.path = UIBezierPath(ovalInRect: dotBounds).CGPath
            shapeLayer.frame = dotFrame
            
            dotFrame = CGRectOffset(dotFrame, 0, dotDiameter + dotMargin)
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        let height = dotDiameter * CGFloat(numberOfPages) + dotMargin * CGFloat(numberOfPages - 1)
        return CGSizeMake(dotDiameter, height)
    }
    
    private func updateShapeLayers() {
        for (index, shapeLayer) in circleShapeLayers.enumerate() {
            shapeLayer.fillColor = currentPage == index ? dotSelectedColor.CGColor : dotColor.CGColor
        }
    }
}
