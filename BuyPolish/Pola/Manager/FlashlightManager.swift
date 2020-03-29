import Foundation
import Observable
import AVFoundation

class FlashlightManager: NSObject {
    @objc private dynamic let flashlightDevice = AVCaptureDevice.default(for: .video)
    private var flashlightObservation: NSKeyValueObservation?
    private let isOnSubject = MutableObservable(false)
    private func updateIsOn() {
        isOnSubject.wrappedValue = (flashlightDevice?.torchMode ?? .off) == .on
    }

    override init() {
        super.init()
        flashlightObservation = observe(\.flashlightDevice?.torchMode, changeHandler: {(manager, _) in
            manager.updateIsOn()
        })
    }

    var isOn: Observable<Bool> {
        isOnSubject
    }
        
    var isAvailable: Bool {
        guard let flashlightDevice = flashlightDevice else {
            return false
        }
        return flashlightDevice.isTorchAvailable && flashlightDevice.isTorchModeSupported(.on)
    }
    
    func toggle(completionBlock: ((Bool) -> Void)?) {
        guard let flashlightDevice = flashlightDevice else {
            completionBlock?(false)
            return
        }
        
        do {
            try flashlightDevice.lockForConfiguration()
            if flashlightDevice.isTorchActive {
                flashlightDevice.torchMode = .off
            } else {
                try flashlightDevice.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
            }
            flashlightDevice.unlockForConfiguration()
            completionBlock?(true)
        } catch {
            completionBlock?(false)
        }
        
    }
    
}
