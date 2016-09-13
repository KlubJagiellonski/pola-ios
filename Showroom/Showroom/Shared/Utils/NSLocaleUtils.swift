import Foundation

extension NSLocale {
    var languageCode: String? {
        guard let code = self.objectForKey(NSLocaleLanguageCode) as? String else {
            logError("Could not find NSLocaleLanguageCode for locale: \(self) with locale identifier: \(self.localeIdentifier)")
            return nil
        }
        return code
    }
    
    func hasEqualLanguageCode(to platform: Platform) -> Bool {
        guard let selfLanguageCode = self.languageCode else {
            return false
        }
        return selfLanguageCode.caseInsensitiveCompare(platform.languageCode) == NSComparisonResult.OrderedSame
    }
}

extension Platform {
    func hasEqualLanguageCode(to locale: NSLocale) -> Bool {
        return locale.hasEqualLanguageCode(to: self)
    }
}