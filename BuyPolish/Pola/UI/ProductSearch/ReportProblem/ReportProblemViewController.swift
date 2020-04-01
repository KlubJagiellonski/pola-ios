import UIKit
import KVNProgress
import PromiseKit

final class ReportProblemViewController: UIViewController {
    
    private let productImageManager: ProductImageManager
    private let reportManager: ReportManager
    private let keyboardManager: KeyboardManager
    private let reason: ReportProblemReason
    private var imageCount: Int = 0
    
    private var castedView: ReportProblemView {
        view as! ReportProblemView
    }
    
    init(reason: ReportProblemReason,
         productImageManager: ProductImageManager,
         reportManager: ReportManager,
         keyboardManager: KeyboardManager) {
        
        self.reason = reason
        self.productImageManager = productImageManager
        self.reportManager = reportManager
        self.keyboardManager = keyboardManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = ReportProblemView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardManager.delegate = castedView
        castedView.sendButtom.addTarget(self, action: #selector(sendRaport), for: .touchUpInside)
        castedView.closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        castedView.imagesContainer.delegate = self
        
        initializeImages()
        updateReportButtonState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardManager.turnOn()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardManager.turnOff()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    private func initializeImages() {
        let images = productImageManager.retrieveThumbnails(for: reason)
        castedView.imagesContainer.images = images
        imageCount = images.count
    }
    
    private func updateReportButtonState() {
        castedView.sendButtom.isEnabled = imageCount > 0
    }
    
    @objc
    private func sendRaport() {
        view.endEditing(true)
        let imagePathArray = productImageManager.pathsForImages(for: reason)
        let report = Report(reason: reason,
                            description: castedView.descriptionTextView.text,
                            imagePaths: imagePathArray)
        KVNProgress.show(withStatus: R.string.localizable.sending())
        
        reportManager
            .send(report: report)
            .done { [weak self, reason, productImageManager] _ in
                KVNProgress.showSuccess(withStatus: R.string.localizable.reportSent())
                AnalyticsHelper.reportSent(barcode: reason.barcode)
                _ = productImageManager.removeImages(for: reason)
                self?.close()
        }.catch { error in
            BPLog("Error occured during sendind report: \(error.localizedDescription)")
            KVNProgress.showError(withStatus: R.string.localizable.errorOccured())
        }
    }
    
    @objc
    private func close() {
        dismiss(animated: true, completion: nil)
    }
}

extension ReportProblemViewController : ReportImagesContainerViewDelegate {
    func imagesContainerTapDeleteButton(at index: Int) {
        guard productImageManager.removeImage(for: reason, index: index) else {
            BPLog("Error occured during removing image from report")
            KVNProgress.showError(withStatus: R.string.localizable.errorOccured())
            return
        }
        castedView.imagesContainer.removeImage(at: index)
        imageCount -= 1
        updateReportButtonState()
    }
    
    func imagesContainerTapAddButton() {
        let cancelTitle = R.string.localizable.cancel()
        let chooseTitle = R.string.localizable.chooseFromLibrary()
        let sheet: UIActionSheet
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            sheet = UIActionSheet(title: nil,
                                  delegate: self,
                                  cancelButtonTitle: cancelTitle,
                                  destructiveButtonTitle: nil,
                                  otherButtonTitles: R.string.localizable.takeAPhoto(), chooseTitle)
        } else {
            sheet = UIActionSheet(title: nil,
                                  delegate: self,
                                  cancelButtonTitle: cancelTitle,
                                  destructiveButtonTitle: nil,
                                  otherButtonTitles: chooseTitle)
        }
        sheet.show(in: view)
    }
    
}

extension ReportProblemViewController : UIActionSheetDelegate {
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        
        guard actionSheet.cancelButtonIndex != buttonIndex else {
            return
        }
        
        let isCamera = UIImagePickerController.isSourceTypeAvailable(.camera) && buttonIndex == 1
        
        let imagePicker = UIImagePickerController()
        imagePicker.modalPresentationStyle = .currentContext
        imagePicker.sourceType = isCamera ? .camera : .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
}

extension ReportProblemViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage,
            productImageManager.saveImage(image, for: reason, index: imageCount),
            let smallImage = productImageManager.retrieveThumbnail(for: reason, index: imageCount) else {
                BPLog("Error occured during obtaining image from image picker")
                KVNProgress.showError(withStatus: R.string.localizable.errorOccured())
                dismiss(animated: true, completion: nil)
                return
        }
        
        castedView.imagesContainer.addImage(smallImage)
        imageCount += 1
        updateReportButtonState()
        dismiss(animated: true, completion: nil)
    }
    
}

extension ReportProblemViewController: UINavigationControllerDelegate {
    
}
