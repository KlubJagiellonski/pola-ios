import UIKit

protocol ImageStepViewDelegate: class {
    func imageStepViewDidDownloadImage(view: ImageStepView)
    func imageStepViewDidTapImageView(view: ImageStepView)
}

final class ImageStepView: ViewSwitcher {
    private let imageView = UIImageView()
    private let link: String
    
    weak var delegate: ImageStepViewDelegate?
    
    init(link: String) {
        self.link = link
        super.init(successView: imageView, initialState: .Success)
        switcherDelegate = self
        switcherDataSource = self
        imageView.contentMode = .ScaleAspectFit
        
        imageView.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(ImageStepView.didTap))
        imageView.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTap() {
        delegate?.imageStepViewDidTapImageView(self)
    }

    func loadImage() {
        let screenWidth = UIScreen.mainScreen().bounds.width
        
        imageView.loadImageFromUrl(link, width: screenWidth,
            onRetrievedFromCache: { [weak self] image in
                guard let `self` = self else { return }
                if let image = image {
                    self.imageView.image = image
                    self.changeSwitcherState(.Success, animated: false)
                    self.delegate?.imageStepViewDidDownloadImage(self)
                } else {
                    logInfo("Failed to retrieve image from cache")
                    self.changeSwitcherState(.Loading, animated: false)
                }
            }, failure: { [weak self] error in
                guard let `self` = self else { return }
                logInfo("Failed to load image with error: \(error)")
                self.changeSwitcherState(.Error)
            }, success: { [weak self] image in
                guard let `self` = self else { return }
                self.imageView.image = image
                self.changeSwitcherState(.Success)
                self.delegate?.imageStepViewDidDownloadImage(self)
        })
    }
}

extension ImageStepView: ViewSwitcherDelegate, ViewSwitcherDataSource {
    func viewSwitcherDidTapRetry(view: ViewSwitcher) {
        changeSwitcherState(.Loading, animated: true)
        loadImage()
    }
    
    func viewSwitcherWantsErrorView(view: ViewSwitcher) -> UIView? {
        return ErrorView(errorText: tr(.CommonError), errorImage: UIImage(asset: .Error))
    }
    
    func viewSwitcherWantsEmptyView(view: ViewSwitcher) -> UIView? {
        return nil
    }
}
