import Foundation
import Swinject

class ManagerAssembly: AssemblyType {
    func assemble(container: Container) {
        container.register(UserManager.self) { r in
            return UserManager(apiService: r.resolve(ApiService.self)!, emarsysService: r.resolve(EmarsysService.self)!
                , keychainManager: r.resolve(KeychainManager.self)!, storageManager: r.resolve(StorageManager.self)!)
        }.inObjectScope(.Container)
        
        container.register(StorageManager.self) { r in
            return StorageManager()
        }.inObjectScope(.Container)
        
        container.register(BasketManager.self) { r in
            return BasketManager(with: r.resolve(ApiService.self)!, emarsysService: r.resolve(EmarsysService.self)!, storageManager: r.resolve(StorageManager.self)!, userManager: r.resolve(UserManager.self)!)
        }.inObjectScope(.Container)
        
        container.register(ToastManager.self) { r in
            return ToastManager()
        }.inObjectScope(.Container)
        
        container.register(WishlistManager.self) { r in
            return WishlistManager(with: r.resolve(StorageManager.self)!, and: r.resolve(UserManager.self)!, and: r.resolve(ApiService.self)!)
        }.inObjectScope(.Container)
        
        container.register(KeychainManager.self) { r in
            return KeychainManager()
        }.inObjectScope(.Container)
        
        container.register(PayUManager.self) { r in
            return PayUManager(api: r.resolve(ApiService.self)!, userManager: r.resolve(UserManager.self)!)
        }.inObjectScope(.Container)
        
        container.register(QuickActionManager.self) { r in
            return QuickActionManager(resolver: r.resolve(DiResolver.self)!)
        }.inObjectScope(.Container)
        
        container.register(NotificationsManager.self) { r in
            return NotificationsManager(with: r.resolve(ApiService.self)!, and: r.resolve(UIApplication.self)!)
        }.inObjectScope(.Container)
        
        container.register(RateAppManager.self) { r in
            return RateAppManager()
        }.inObjectScope(.Container)
        
        container.register(VersionManager.self) { r in
            return VersionManager(api: r.resolve(ApiService.self)!)
        }.inObjectScope(.Container)
        
        container.register(PlatformLanguageManager.self) { r in
            return PlatformLanguageManager()
        }.inObjectScope(.Container)
    }
}