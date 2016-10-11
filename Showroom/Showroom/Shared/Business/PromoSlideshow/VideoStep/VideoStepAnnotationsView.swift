import Foundation
import UIKit

private struct VideoStepAnnotationInfo {
    let view: VideoStepAnnotationView
    let annotation: PromoSlideshowVideoAnnotation
}

final class VideoStepAnnotationsView: UIView {
    private var annotations: [PromoSlideshowVideoAnnotation]
    private var currentlyShownAnnotationInfos: [VideoStepAnnotationInfo] = []
    
    init(annotations: [PromoSlideshowVideoAnnotation]) {
        self.annotations = annotations
        super.init(frame: CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func playbackTimeChanged(playbackTime: Int) {
        let annotationsForCurrentPlaybackTime = annotations.filter { playbackTime >= $0.startTime && playbackTime < $0.endTime }
        let filterAnnotationsToShowHandler: PromoSlideshowVideoAnnotation -> Bool = { [unowned self] annotation in
            return !self.currentlyShownAnnotationInfos.contains { $0.annotation == annotation }
        }
        let annotationsToShow = annotationsForCurrentPlaybackTime.filter(filterAnnotationsToShowHandler)
        if !annotationsToShow.isEmpty {
            annotationsToShow.forEach { showAnnotation($0) }
        }
        
        let annotationsToHide = currentlyShownAnnotationInfos.filter { annotationInfo in
            return !annotationsForCurrentPlaybackTime.contains { annotationInfo.annotation == $0 }
        }
        if !annotationsToHide.isEmpty {
            annotationsToHide.forEach { hideAnnotation($0) }
        }
    }
    
    private func showAnnotation(annotation: PromoSlideshowVideoAnnotation) {
        logInfo("show annotation: \(annotation)")
        let annotationView = VideoStepAnnotationView(type: annotation.style, text: annotation.text)
        let annotationInfo = VideoStepAnnotationInfo(view: annotationView, annotation: annotation)
        currentlyShownAnnotationInfos.append(annotationInfo)
        addSubview(annotationView)
        annotationView.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            
            // this if is necessary, because after calling
            // make.centerY.equalTo(self.snp_bottom).multipliedBy(0.0)
            // SnapKit cause crash
            if annotation.verticalPosition == 0.0 {
                make.centerY.equalTo(self.snp_top)
            } else {
                make.centerY.equalTo(self.snp_bottom).multipliedBy(annotation.verticalPosition)
            }
        }
    }
    
    private func hideAnnotation(annotationInfo: VideoStepAnnotationInfo) {
        logInfo("hide annotation info: \(annotationInfo)")
        annotationInfo.view.removeFromSuperview()
        currentlyShownAnnotationInfos.remove { $0.annotation == annotationInfo.annotation }
    }
}

final private class VideoStepAnnotationView: UIView {
    private let insets = UIEdgeInsets(top: 7, left: Dimensions.defaultMargin, bottom: 7, right: Dimensions.defaultMargin)
    
    private let textLabel = UILabel()
    
    init(type: PromoSlideshowVideoAnnotationStyle, text: String) {
        super.init(frame: CGRectZero)
        
        backgroundColor = type.backgroundCollor
        
        textLabel.textColor = type.textColor
        textLabel.text = text
        textLabel.font = UIFont.latoRegular(ofSize: 16)
        textLabel.textAlignment = .Center
        textLabel.lineBreakMode = .ByWordWrapping
        textLabel.numberOfLines = 0
        
        addSubview(textLabel)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        textLabel.snp_makeConstraints { make in
            make.edges.equalToSuperview().inset(insets)
        }
    }
    
    private override func intrinsicContentSize() -> CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: textLabel.intrinsicContentSize().height + insets.top + insets.bottom)
    }
}

extension PromoSlideshowVideoAnnotationStyle {
    private var textColor: UIColor {
        switch self {
        case .White:
            return UIColor(named: .Black)
        case .Black:
            return UIColor(named: .White)
        }
    }
    
    private var backgroundCollor: UIColor {
        switch self {
        case .White:
            return UIColor(named: .White).colorWithAlphaComponent(0.85)
        case .Black:
            return UIColor(named: .Black).colorWithAlphaComponent(0.7)
        }
    }
}

extension PromoSlideshowVideoAnnotation {
    private var endTime: Int {
        return startTime + duration
    }
}