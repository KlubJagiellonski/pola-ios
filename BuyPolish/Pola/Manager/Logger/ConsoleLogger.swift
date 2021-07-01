import Foundation

final class ConsoleLogger: LoggerProvider {
    func log(_ message: String, file _: StaticString, function _: StaticString, line _: UInt) {
        print(message)
    }
}
