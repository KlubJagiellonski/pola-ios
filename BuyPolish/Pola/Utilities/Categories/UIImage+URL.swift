import Alamofire
import PromiseKit
import UIKit

extension UIImage {
    static func load(url: URL) -> Promise<UIImage?> {
        Alamofire
            .request(url)
            .responseData()
            .map { dataResponse in
                guard let image = UIImage(data: dataResponse.data) else {
                    return nil
                }
                return image
            }
    }
}
