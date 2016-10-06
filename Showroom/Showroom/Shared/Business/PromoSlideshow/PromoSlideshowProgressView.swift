import Foundation
import UIKit

struct ProgressInfoState {
    let currentStep: Int
    let currentStepProgress: Double
}

final class PromoSlideshowProgressView: UIView {
    private let progressViewsInsets = UIEdgeInsetsMake(9, Dimensions.defaultMargin, 13, Dimensions.defaultMargin)
    private let interProgressViewHorizontalMargin: CGFloat = 6
    
    private let gradientLayer = CAGradientLayer()
    private var progressViews: [PromoSlideshowStepProgressView] = []
    private var stepsRelativeDurations: [Double] = []
    
    init() {
        super.init(frame: CGRectZero)
        gradientLayer.colors = [UIColor(named: .Black).colorWithAlphaComponent(0.25).CGColor, UIColor.clearColor().CGColor]
        self.layer.insertSublayer(gradientLayer, atIndex: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = self.bounds
        
        let horizontalOffset = (progressViewsInsets.left + progressViewsInsets.right)
        let interOffset = CGFloat(progressViews.count - 1) * interProgressViewHorizontalMargin
        let offset = horizontalOffset + interOffset
        
        var point = CGPointMake(progressViewsInsets.left, progressViewsInsets.top)
        for (index, progressView) in progressViews.enumerate() {
            let width = (bounds.width - offset) * CGFloat(stepsRelativeDurations[index])
            progressView.frame = CGRectMake(point.x, point.y, width, PromoSlideshowStepProgressView.height)
            
            point.x += progressView.bounds.width + interProgressViewHorizontalMargin
        }
    }
    
    func update(with video: PromoSlideshowVideo) {
        let stepsCount = video.steps.count
        guard stepsCount > 0 else {
            logError("Failed to update progressViews for steps count: \(stepsCount)")
            return
        }
        progressViews.forEach { $0.removeFromSuperview() }
        progressViews.removeAll()
        
        for _ in 0..<stepsCount { progressViews.append(PromoSlideshowStepProgressView()) }
        progressViews.forEach { addSubview($0) }
        
        stepsRelativeDurations = video.steps.map { Double($0.duration) / Double(video.duration) }
        logInfo("steps relative durations: \(stepsRelativeDurations)")
        
        setNeedsLayout()
        layoutSubviews()
    }
    
    func update(with progress: ProgressInfoState) {
        let currentStep = progress.currentStep
        for (index, progressView) in progressViews.enumerate() {
            switch index {
            case 0..<currentStep:
                progressView.progress = 1
                
            case currentStep:
                progressView.progress = progress.currentStepProgress
                
            default:
                progressView.progress = 0
            }
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: progressViewsInsets.top + PromoSlideshowStepProgressView.height + progressViewsInsets.bottom)
    }
}

final class PromoSlideshowStepProgressView: UIView {
    static let height: CGFloat = 2
    
    private let trackView = UIView()
    private let progressView = UIView()
    
    var progress: Double = 0 {
        didSet {
            guard oldValue != progress else { return }
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    init() {
        super.init(frame: CGRectZero)
        trackView.backgroundColor = UIColor(named: .White).colorWithAlphaComponent(0.4)
        progressView.backgroundColor = UIColor(named: .White)
        
        addSubview(trackView)
        addSubview(progressView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        trackView.frame = self.bounds
        let trackWidth = trackView.frame.width
        let progressSize = CGSize(width: (CGFloat(progress) * trackWidth), height: PromoSlideshowStepProgressView.height)
        progressView.frame = CGRect(origin: CGPointZero, size: progressSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: PromoSlideshowStepProgressView.height)
    }
}