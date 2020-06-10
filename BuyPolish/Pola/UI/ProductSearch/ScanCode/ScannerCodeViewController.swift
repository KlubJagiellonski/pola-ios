import UIKit

final class ScannerCodeViewController: UIViewController {
    private let codeScannerManager: CodeScannerManager

    var hudView: UIView {
        castView.rectangleView
    }

    var scannerDelegate: CodeScannerManagerDelegate? {
        get {
            codeScannerManager.delegate
        }
        set {
            codeScannerManager.delegate = newValue
        }
    }

    init(codeScannerManager: CodeScannerManager) {
        self.codeScannerManager = codeScannerManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = ScannerCodeView()
    }

    private var castView: ScannerCodeView {
        view as! ScannerCodeView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        castView.videoLayer = codeScannerManager.previewLayer
        codeScannerManager.start()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        codeScannerManager.stop()
    }
}
