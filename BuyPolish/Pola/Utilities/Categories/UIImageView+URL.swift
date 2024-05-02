import PromiseKit
import UIKit

extension UIImageView {
    func load(from url: URL, resizeToHeight height: CGFloat) {
        UIImage
            .load(url: url)
            .map { $0?.scaled(toHeight: height) }
            .done(on: .main) { image in
                guard let image else {
                    return
                }
                self.image = image
                self.isHidden = false
            }
            .catch { error in
                BPLog("Error loading image from \(url): \(error)")
            }
    }
}
