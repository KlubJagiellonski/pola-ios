import Foundation
import Swinject

class ManagerAssembly: AssemblyType {
    func assemble(container: Container) {
        container.register(UserManager.self) { r in
            return UserManager(apiService: r.resolve(ApiService.self)!)
        }.inObjectScope(.Container)
        
        container.register(CacheManager.self) { r in
            return CacheManager()
        }.inObjectScope(.Container)
    }
}