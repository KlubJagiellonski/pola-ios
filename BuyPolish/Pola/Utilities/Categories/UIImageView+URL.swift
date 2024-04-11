import Alamofire
import UIKit

extension UIImageView {
    func load(from url: URL, resizeToHeight height: CGFloat) {
        Alamofire.request(url).responseData { [weak self] dataResponse in
            guard let data = dataResponse.data,
                  let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                self?.image = image.scaled(toHeight: height)
                self?.isHidden = false
            }
        }
    }
}
