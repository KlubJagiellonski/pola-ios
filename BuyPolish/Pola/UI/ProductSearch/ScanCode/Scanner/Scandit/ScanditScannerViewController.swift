import ScanditBarcodeCapture
import UIKit

final class ScanditScannerViewController: UIViewController, ScanningViewController, BarcodeCaptureListener {
    var scannerDelegate: ScanningDelegate?

    let context: DataCaptureContext
    let barcodeCapture: BarcodeCapture

    init() {
        context = DataCaptureContext(licenseKey: "-- ENTER YOUR SCANDIT LICENSE KEY HERE --")

        let settings = BarcodeCaptureSettings()
        settings.set(symbology: .ean8, enabled: true)
        settings.set(symbology: .ean13UPCA, enabled: true)
        barcodeCapture = BarcodeCapture(context: context, settings: settings)

        super.init(nibName: nil, bundle: nil)
        barcodeCapture.isEnabled = true
        barcodeCapture.addListener(self)

        let cameraSettings = BarcodeCapture.recommendedCameraSettings

        let camera = Camera.default
        camera?.apply(cameraSettings)
        context.setFrameSource(camera)
        camera?.switch(toDesiredState: .on)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let captureView = DataCaptureView(context: context, frame: .zero)
        captureView.context = context
        captureView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        view = captureView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        barcodeCapture.isEnabled = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        barcodeCapture.isEnabled = false
    }

    func barcodeCapture(_: BarcodeCapture, didScanIn session: BarcodeCaptureSession, frameData _: FrameData) {
        for barcode in session.newlyRecognizedBarcodes {
            if let data = barcode.data {
                DispatchQueue.main.async { [scannerDelegate] in
                    scannerDelegate?.didScan(barcode: data, sourceType: .camera)
                }
            }
        }
    }
}
