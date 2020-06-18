import AVFoundation
import Foundation
import PromiseKit

final class CameraCaptureVideoManager: NSObject, CaptureVideoManager {
    private let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "CameraCaptureVideoManager")
    fileprivate var promiseImageResolver: Resolver<UIImage>?

    private(set) lazy var previewLayer: CALayer = {
        let layer = AVCaptureVideoPreviewLayer(session: captureSession)
        layer.videoGravity = .resizeAspectFill
        return layer
    }()

    override init() {
        super.init()
        guard let captureDevice = AVCaptureDevice.default(for: .video),
            let input = try? AVCaptureDeviceInput(device: captureDevice) else {
            return
        }

        captureSession.addInput(input)

        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        output.alwaysDiscardsLateVideoFrames = true
        output.setSampleBufferDelegate(self, queue: sessionQueue)

        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }

        if let connection = output.connection(with: .video) {
            connection.videoOrientation = .portrait
            connection.isEnabled = true
        }

        captureSession.sessionPreset = .photo
    }

    func startPreview() {
        captureSession.startRunning()
    }

    func stopPreview() {
        captureSession.stopRunning()
    }

    func captureImage() -> Promise<UIImage> {
        Promise<UIImage> { resolver in
            self.promiseImageResolver = resolver
        }
    }
}

extension CameraCaptureVideoManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from _: AVCaptureConnection) {
        guard let promiseImageResolver = promiseImageResolver else {
            return
        }

        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            promiseImageResolver.reject(CreateCaptureImageError())
            return
        }

        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let ciContext = CIContext(options: nil)
        let imageSize = CGSize(width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))

        guard let cgImage = ciContext.createCGImage(ciImage, from: CGRect(origin: .zero, size: imageSize)) else {
            promiseImageResolver.reject(CreateCaptureImageError())
            return
        }

        let uiImage = UIImage(cgImage: cgImage)

        DispatchQueue.main.async { [weak self, promiseImageResolver] in
            promiseImageResolver.fulfill(uiImage)
            self?.promiseImageResolver = nil
        }
    }
}
