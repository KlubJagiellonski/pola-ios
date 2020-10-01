import Foundation

class KeyboardBarcode {
    private(set) var code: String

    init(code: String) {
        self.code = code
    }

    var isAppendable: Bool {
        code.count < 13
    }

    func append(number: Int) {
        guard isAppendable else {
            return
        }

        code = code.appending("\(number)")
    }

    func append(string: String) {
        string.forEach { ch in
            guard let number = ch.wholeNumberValue else {
                return
            }
            append(number: number)
        }
    }

    func removeLast() {
        guard code.isNotEmpty else {
            return
        }
        code.removeLast()
    }

    func removeAll() {
        code = ""
    }
}
