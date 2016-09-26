import Foundation

extension NSBundle {
    static var appScheme: String {
        let urlTypes = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleURLTypes") as! Array<[NSObject: NSObject]>
        let urlType = urlTypes[0] as! [NSString: NSObject]
        let urlSchemes = urlType["CFBundleURLSchemes" as NSString] as! Array<NSObject>
        return urlSchemes[0] as! String
    }
    
    static var pushwooshAppId: String {
        return NSBundle.mainBundle().objectForInfoDictionaryKey("Pushwoosh_APPID") as! String
    }
    
    static var appVersionNumber: String {
        return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
    }
    
    static var appBuildNumber: String {
        return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as! String
    }
    
    static var appDisplayName: String {
        return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleDisplayName") as! String
    }
}