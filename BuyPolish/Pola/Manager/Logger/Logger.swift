import Foundation

protocol LoggerProvider {
    func log(_ message: String, file: StaticString, function: StaticString, line: UInt)
}

func BPLog(_ message: String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
    guard let logger = DI.container.resolve(LoggerProvider.self) else {
        return
    }
    logger.log(message, file: file, function: function, line: line)
}
