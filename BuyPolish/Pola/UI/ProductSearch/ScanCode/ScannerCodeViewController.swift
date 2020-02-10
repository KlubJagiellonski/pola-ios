import UIKit

@objc
class ScannerCodeViewController: UIViewController {
    private let codeScannerManager: CodeScannerManager
    
    @objc
    static func fromDiContainer() -> ScannerCodeViewController {
        DI.container.resolve(ScannerCodeViewController.self)!
    }
    
    @objc
    var hudView: UIView {
        castView.rectangleView
    }
    
    @objc
    var scannerDelegate: CodeScannerManagerDelegate? {
        get {
            codeScannerManager.delegate
        }
        set {
            codeScannerManager.delegate = newValue
        }
    }
    
    @objc
    init(codeScannerManager: CodeScannerManager) {
        self.codeScannerManager = codeScannerManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
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
