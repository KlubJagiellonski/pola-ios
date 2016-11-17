import Foundation

enum HandoffPathType {
    case Home, Cart, Product, Wishlist
    
    private func pathComponent(with configuration: DeepLinkConfiguration) -> String {
        switch self {
        case .Home: return ""
        case .Cart: return configuration.cartPathComponent
        case .Product: return configuration.productPathComponent
        case .Wishlist: return configuration.wishlistPathComponent
        }
    }
}

struct HandoffPath {
    let type: HandoffPathType
    let additionalPath: String?
    
    func pathComponent(with configuration: DeepLinkConfiguration) -> String {
        let typePathComponent = type.pathComponent(with: configuration)
        if let additionalPath  = additionalPath {
            return "\(typePathComponent)/\(additionalPath)"
        } else {
            return typePathComponent
        }
    }
}

extension UIResponder {
    func markHandoffUrlActivity(withType pathType: HandoffPathType, resolver: DiResolver) {
        markHandoffUrlActivity(withPath: HandoffPath(type: pathType, additionalPath: nil), resolver: resolver)
    }
    
    func markHandoffUrlActivity(withPath path: HandoffPath, resolver: DiResolver) {
        let configurationManager = resolver.resolve(ConfigurationManager.self)
        guard let configuration = configurationManager.configuration else { return }
        
        let pathComponent = path.pathComponent(with: configuration.deepLinkConfiguration)
        let userActivity = NSUserActivity(activityType: NSBundle.mainBundle().bundleIdentifier!.stringByAppendingString(".browsing"))
        userActivity.webpageURL = configuration.webPageURL.URLByAppendingPathComponent(pathComponent)
        self.userActivity = userActivity
    }
}
