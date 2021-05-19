import AVFoundation

final class CameraSessionCodeScannerManager: NSObject, CodeScannerManager {
    weak var delegate: CodeScannerManagerDelegate?
    private let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "CameraSessionCodeScannerManager")
    private var isSessionRunning = false
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
        let output = AVCaptureMetadataOutput()
        captureSession.addOutput(output)
        output.metadataObjectTypes = [.ean13, .ean8]
        output.setMetadataObjectsDelegate(self, queue: sessionQueue)
    }

    func start() {
        guard !isSessionRunning else {
            return
        }
        isSessionRunning = true
        sessionQueue.async { [captureSession] in
            captureSession.startRunning()
        }
    }

    func stop() {
        guard isSessionRunning else {
            return
        }
        isSessionRunning = false
        sessionQueue.async { [captureSession] in
            captureSession.stopRunning()
        }
    }
}

extension CameraSessionCodeScannerManager: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from _: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
            let barcode = metadataObject.stringValue else {
            return
        }

        DispatchQueue.main.async { [delegate] in
            BPLog("Found barcode \(barcode)")
            delegate?.didScan(barcode: barcode, sourceType: .camera)
        }
    }
}
