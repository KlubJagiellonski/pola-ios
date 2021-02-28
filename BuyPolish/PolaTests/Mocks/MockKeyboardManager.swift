@testable import Pola

class MockKeyboardManager: KeyboardManager {
    weak var delegate: KeyboardManagerDelegate?

    func turnOn() {}

    func turnOff() {}
}
