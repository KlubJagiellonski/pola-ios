import PromiseKit
import UIKit

protocol CaptureVideoManager {
    var previewLayer: CALayer { get }

    func startPreview()
    func stopPreview()
    func captureImage() -> Promise<UIImage>
}

struct CreateCaptureImageError: Error, LocalizedError {
    var errorDescription: String? {
        "Failed create capture image"
    }
}
