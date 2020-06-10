import AVFoundation
import KVNProgress
import PromiseKit
import UIKit

protocol CaptureVideoViewControllerDelegate: AnyObject {
    func captureVideoViewControllerSentImages()
}

final class CaptureVideoViewController: UIViewController {
    private let scanResult: ScanResult
    private let videoManager: CaptureVideoManager
    private let imageManager: CapturedImageManager
    private let uploadManager: CapturedImagesUploadManager
    private let device: UIDevice
    private var timer: TimerBlock?
    private let numberOfImagesToCapture = 6
    private var timerSeconds: Int
    weak var delegate: CaptureVideoViewControllerDelegate?

    init(scanResult: ScanResult,
         videoManager: CaptureVideoManager,
         imageManager: CapturedImageManager,
         uploadManager: CapturedImagesUploadManager,
         device: UIDevice) {
        self.scanResult = scanResult
        self.videoManager = videoManager
        self.imageManager = imageManager
        self.uploadManager = uploadManager
        timerSeconds = numberOfImagesToCapture
        self.device = device
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = CaptureVideoView()
    }

    private var castedView: CaptureVideoView {
        view as! CaptureVideoView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        castedView.productLabel.text = scanResult.ai?.askForPicsProduct
        castedView.timeLabel.isHidden = true
        setTimeOnTimeLabel(timerSeconds)
        castedView.closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        castedView.startButton.addTarget(self, action: #selector(startCapture), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        videoManager.startPreview()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        castedView.videoLayer = videoManager.previewLayer
        if AVCaptureDevice.authorizationStatus(for: .video) == .denied {
            let strings = R.string.localizable.self
            let alertView = UIAlertView(title: strings.cameraPrivacyTitle(),
                                        message: strings.cameraPrivacyCaptureVideoDescription(),
                                        delegate: self,
                                        cancelButtonTitle: strings.cancel(),
                                        otherButtonTitles: strings.settings())
            alertView.show()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        videoManager.stopPreview()
        reset()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    private func setTimeOnTimeLabel(_ seconds: Int) {
        castedView.timeLabel.text = "\(seconds) \(R.string.localizable.captureVideoTimerSeconds())"
    }

    @objc
    private func close() {
        navigationController?.dismiss(animated: true, completion: nil)
    }

    @objc
    private func startCapture() {
        castedView.startButton.isHidden = true
        castedView.productLabel.isHidden = true
        castedView.timeLabel.isHidden = false
        captureImage()
        timer = TimerBlock(timeInterval: TimeInterval(2),
                           repeats: true,
                           block: { [weak self] _ in
                               guard let self = self else {
                                   return
                               }
                               self.timerSeconds -= 1
                               self.setTimeOnTimeLabel(self.timerSeconds)
                               if self.timerSeconds == 0 {
                                   self.invalidateTimer()
                               } else {
                                   self.captureImage()
                               }
        })
        RunLoop.main.add(timer!, forMode: .common)
    }

    private func invalidateTimer() {
        guard let timer = timer else {
            return
        }
        timer.invalidate()
        self.timer = nil
    }

    private func reset() {
        invalidateTimer()
        imageManager.removeImages()
        timerSeconds = numberOfImagesToCapture
        setTimeOnTimeLabel(timerSeconds)
        castedView.productLabel.isHidden = false
        castedView.timeLabel.isHidden = true
        castedView.startButton.isHidden = false
    }

    private func captureImage() {
        guard let maxSide = scanResult.ai?.maxPicSize else {
            return
        }

        videoManager.captureImage().get { [imageManager, numberOfImagesToCapture, weak self] image in
            let scaledImage = image.scaled(toMaxSide: CGFloat(maxSide))
            guard let self = self else {
                return
            }
            imageManager.addImage(scaledImage)
            if imageManager.imagesCount == numberOfImagesToCapture {
                self.sendImagesWithLastImage(scaledImage: scaledImage, originalImage: image)
            }
        }.catch { error in
            BPLog("Error occured during image capture: \(error.localizedDescription)")
            KVNProgress.showError(withStatus: R.string.localizable.errorOccured())
        }
    }

    private func sendImagesWithLastImage(scaledImage: UIImage, originalImage: UIImage) {
        KVNProgress.show(withStatus: R.string.localizable.captureVideoSending())
        let capturedImages = CapturedImages(productId: scanResult.productId,
                                            dataImages: imageManager.retrieveImagesData(),
                                            originalSize: originalImage.sizeInPixels,
                                            size: scaledImage.sizeInPixels,
                                            deviceName: device.deviceName)

        uploadManager
            .send(images: capturedImages)
            .done { [weak self, scanResult, imageManager] _ in
                KVNProgress.showSuccess(withStatus: R.string.localizable.captureVideoThanks())
                AnalyticsHelper.teachReportSent(barcode: scanResult.code)
                imageManager.removeImages()
                self?.delegate?.captureVideoViewControllerSentImages()
                self?.close()
            }.catch { error in
                BPLog("Error occured during sending images for ai: \(error.localizedDescription)")
                KVNProgress.showError(withStatus: R.string.localizable.captureVideoFailed())
            }
    }
}

private extension UILabel {
    func setTimeOnTimeLabel(_ seconds: Int) {
        text = "\(seconds) \(R.string.localizable.captureVideoTimerSeconds())"
    }
}

extension CaptureVideoViewController: UIAlertViewDelegate {
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        guard alertView.cancelButtonIndex != buttonIndex,
            let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.openURL(settingsUrl)
    }
}
