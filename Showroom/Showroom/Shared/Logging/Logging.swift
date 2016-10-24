import Foundation
import XCGLogger
import Crashlytics
import Fabric

func logInfo(text: String, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
    Logging.info(text, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
}

func logDebug(text: String, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
    Logging.debug(text, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
}

func logError(text: String, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
    Logging.error(text, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
}

final class Logging {
    static let xcgLogger = XCGLogger.defaultInstance()

    static func configure() {
        let isDebug = Constants.isDebug

        xcgLogger.setup(isDebug ? .Debug : .Info,
            showLogIdentifier: isDebug,
            showFunctionName: isDebug,
            showThreadName: isDebug,
            showLogLevel: isDebug,
            showFileNames: true,
            showLineNumbers: true,
            showDate: isDebug,
            writeToFile: nil,
            fileLogLevel: nil)

        if !isDebug {
            Fabric.with([Crashlytics.self])
            xcgLogger.addLogDestination(CrashlyticsLogDestination(owner: xcgLogger))
        }
    }

    static func info(text: String, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
        xcgLogger.info(text, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }

    static func debug(text: String, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
        xcgLogger.debug(text, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }

    static func error(text: String, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
        xcgLogger.error(text, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
}

class CrashlyticsLogDestination: XCGLogDestinationProtocol {
    var owner: XCGLogger
    var identifier: String = "CrashlyticsErrorLog"
    var outputLogLevel: XCGLogger.LogLevel = .Info

    init(owner: XCGLogger) {
        self.owner = owner
    }

    func commonProcessLogDetails(logDetails: XCGLogDetails) {
        if logDetails.logLevel >= .Error {
            Crashlytics.sharedInstance().recordError(NSError.fromXCGLogDetails(logDetails))
        } else {
            CLSLogv("%@", getVaList([logDetails.toMessage()]))
        }
    }

    // MARK: - XCGLogDestinationProtocol
    func processLogDetails(logDetails: XCGLogDetails) {
        self.commonProcessLogDetails(logDetails)
    }

    func processInternalLogDetails(logDetails: XCGLogDetails) {
        self.processInternalLogDetails(logDetails)
    }

    func isEnabledForLogLevel(logLevel: XCGLogger.LogLevel) -> Bool {
        return logLevel >= self.outputLogLevel
    }

    // MARK: - CustomDebugStringConvertible
    var debugDescription: String {
        get {
            return "CrashlyticsErrorLogDestination"
        }
    }
}

extension NSError {
    static func fromXCGLogDetails(xcgLogDetails: XCGLogDetails) -> NSError {
        return NSError(domain: xcgLogDetails.logMessage, code: 500, userInfo: [
            NSLocalizedDescriptionKey: xcgLogDetails.toMessage()
        ])
    }
}

extension XCGLogDetails {
    func toMessage() -> String {
        return "[\(date)][\(fileName):\(functionName):\(lineNumber)] \(logMessage)"
    }
}
