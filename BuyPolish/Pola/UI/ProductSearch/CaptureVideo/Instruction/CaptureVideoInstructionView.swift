import UIKit

final class CaptureVideoInstructionView: UIView {
    let titleLabel = UILabel()
    let closeButton = UIButton(type: .custom)
    let instructionLabel = UILabel()
    let videoView = VideoPlayerView()
    let captureButton = UIButton(type: .custom)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Theme.mediumBackgroundColor

        titleLabel.font = Theme.titleFont
        titleLabel.textColor = Theme.defaultTextColor
        addSubview(titleLabel)

        closeButton.accessibilityLabel = R.string.localizable.accessibilityClose()
        closeButton.setImage(R.image.closeIcon(), for: .normal)
        closeButton.tintColor = Theme.defaultTextColor
        addSubview(closeButton)

        instructionLabel.font = Theme.normalFont
        instructionLabel.textColor = Theme.defaultTextColor
        instructionLabel.numberOfLines = 0
        instructionLabel.lineBreakMode = .byWordWrapping
        addSubview(instructionLabel)

        videoView.layer.borderColor = UIColor.black.cgColor
        addSubview(videoView)

        captureButton.titleLabel?.font = Theme.buttonFont
        captureButton.setBackgroundImage(UIImage.image(color: Theme.actionColor), for: .normal)
        captureButton.setTitleColor(.white, for: .normal)
        addSubview(captureButton)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let horizontalPadding = CGFloat(16)
        let verticalMargin = CGFloat(25)
        let captureButtonHeight = CGFloat(30)
        let widthWithoutPaddings = bounds.width - (CGFloat(2) * horizontalPadding)

        closeButton.sizeToFit()
        closeButton.frameOrigin = CGPoint(
            x: bounds.width - horizontalPadding - closeButton.frame.width,
            y: topSafeAreaInset + horizontalPadding
        )

        titleLabel.sizeToFit()
        titleLabel.frameOrigin = CGPoint(
            x: horizontalPadding,
            y: closeButton.frame.minY + (closeButton.frame.height / CGFloat(2)) - (titleLabel.frame.height / CGFloat(2))
        )

        instructionLabel.frame = CGRect(
            x: horizontalPadding,
            y: closeButton.frame.maxY + verticalMargin,
            width: widthWithoutPaddings,
            height: instructionLabel.height(forWidth: widthWithoutPaddings)
        )

        captureButton.frame = CGRect(
            x: horizontalPadding,
            y: bounds.height - horizontalPadding - captureButtonHeight,
            width: widthWithoutPaddings,
            height: captureButtonHeight
        )

        videoView.frame = CGRect(
            x: horizontalPadding,
            y: instructionLabel.frame.maxY + verticalMargin,
            width: widthWithoutPaddings,
            height: captureButton.frame.minY - instructionLabel.frame.maxY - (CGFloat(2) * verticalMargin)
        )
    }
}
