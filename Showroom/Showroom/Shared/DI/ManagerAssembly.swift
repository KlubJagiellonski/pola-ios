import Foundation
import Swinject

class ManagerAssembly: AssemblyType {
    func assemble(container: Container) {
        container.register(UserManager.self) { r in
            return UserManager(apiService: r.resolve(ApiService.self)!, emarsysService: r.resolve(EmarsysService.self)!, keychainManager: r.resolve(KeychainManager.self)!, storage: r.resolve(KeyValueStorage.self)!, platformManager: r.resolve(PlatformManager.self)!)
        }.inObjectScope(.Container)
        
        container.register(StorageManager.self) { r in
            return StorageManager()
        }.inObjectScope(.Container)
        
        container.register(BasketManager.self) { r in
            return BasketManager(with: r.resolve(ApiService.self)!, emarsysService: r.resolve(EmarsysService.self)!, storage: r.resolve(KeyValueStorage.self)!, userManager: r.resolve(UserManager.self)!, platformManager: r.resolve(PlatformManager.self)!)
        }.inObjectScope(.Container)
        
        container.register(ToastManager.self) { r in
            return ToastManager()
        }.inObjectScope(.Container)
        
        container.register(WishlistManager.self) { r in
            return WishlistManager(with: r.resolve(KeyValueStorage.self)!, and: r.resolve(UserManager.self)!, and: r.resolve(PlatformManager.self)!, and: r.resolve(ApiService.self)!)
        }.inObjectScope(.Container)
        
        container.register(KeychainManager.self) { r in
            return KeychainManager(platformManager: r.resolve(PlatformManager.self)!)
        }.inObjectScope(.Container)
        
        container.register(QuickActionManager.self) { r in
            return QuickActionManager(resolver: r.resolve(DiResolver.self)!)
        }.inObjectScope(.Container)
        
        container.register(NotificationsManager.self) { r in
            return NotificationsManager(with: r.resolve(ApiService.self)!, application: r.resolve(UIApplication.self)!, storage: r.resolve(KeyValueStorage.self)!)
        }.inObjectScope(.Container)
        
        container.register(RateAppManager.self) { r in
            return RateAppManager(storage: r.resolve(KeyValueStorage.self)!)
        }.inObjectScope(.Container)
        
        container.register(VersionManager.self) { r in
            return VersionManager(api: r.resolve(ApiService.self)!, storage: r.resolve(KeyValueStorage.self)!)
        }.inObjectScope(.Container)
        
        container.register(PlatformManager.self) { r in
            return PlatformManager(keyValueStorage: r.resolve(KeyValueStorage.self)!, api: r.resolve(ApiService.self)!)
        }.inObjectScope(.Container)
        
        container.register(PaymentManager.self) { r in
            return PaymentManager(api: r.resolve(ApiService.self)!)
        }.inObjectScope(.Container)
        
        container.register(PrefetchingManager.self) { r in
            return PrefetchingManager(api: r.resolve(ApiService.self)!, emarsysService: r.resolve(EmarsysService.self)!, storage: r.resolve(KeyValueStorage.self)!)
        }.inObjectScope(.Container)
        
        container.register(KeyValueStorage.self) { r in
            return r.resolve(StorageManager.self)!
        }
    }
}