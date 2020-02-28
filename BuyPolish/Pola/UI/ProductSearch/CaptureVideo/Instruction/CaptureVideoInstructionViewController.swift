import UIKit

class CaptureVideoInstructionViewController: UIViewController {
    let scanResult: ScanResult
    weak var delegate: CaptureVideoViewControllerDelegate?

    init(scanResult: ScanResult) {
        self.scanResult = scanResult
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = CaptureVideoInstructionView()
    }
    
    private var castedView: CaptureVideoInstructionView {
        view as! CaptureVideoInstructionView
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        castedView.titleLabel.text = scanResult.ai?.askForPicsTitle
        castedView.instructionLabel.text = scanResult.ai?.askForPicsText
        castedView.captureButton.setTitle(scanResult.ai?.askForPicsButtonStart, for: .normal)
        
        castedView.closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        castedView.captureButton.addTarget(self, action: #selector(captureVideo), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let videoPath = R.file.capture_video_instructionMov()  else {
            BPLog("Failed to play instruction video, no file at bundle: capture_video_instruction.mov")
            return
        }
        castedView.videoView.playInLoop(url: videoPath)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        castedView.videoView.stop()
    }
    
    @objc
    func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func captureVideo() {
        let vc = DI.container.resolve(CaptureVideoViewController.self, argument: scanResult)!
        vc.delegate = delegate
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
