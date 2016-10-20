import Foundation

extension NSLocale {
    var appLanguageCode: String? {
        guard let code = self.objectForKey(NSLocaleLanguageCode) as? String else {
            logError("Could not find NSLocaleLanguageCode for locale: \(self) with locale identifier: \(self.localeIdentifier)")
            return nil
        }
        return code
    }
}
