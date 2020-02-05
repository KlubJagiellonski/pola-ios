import Foundation

func BPLog(message: String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
    print("\(message) [\(file)] [\(function)] [\(line)]")
}
