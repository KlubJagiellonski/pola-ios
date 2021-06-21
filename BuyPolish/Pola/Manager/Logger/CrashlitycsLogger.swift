import FirebaseCrashlytics

final class CrashlitycsLogger: LoggerProvider {
    func log(_ message: String, file _: StaticString, function _: StaticString, line _: UInt) {
        Crashlytics.crashlytics().log(message)
    }
}
