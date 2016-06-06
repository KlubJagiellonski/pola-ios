import Foundation
import Swinject

class UIAssembly: AssemblyType {
    func assemble(container: Container) {
        container.register(RootViewController.self) { r in
            return RootViewController(resolver: r.resolve(DiResolver.self)!)!
        }
        container.register(RootModel.self) { r in
            return RootModel()
        }
        container.register(MainTabViewController.self) { r in
            return MainTabViewController(resolver: r.resolve(DiResolver.self)!)
        }
        container.register(DashboardPresenterController.self) { r in
            return DashboardPresenterController(resolver: r.resolve(DiResolver.self)!)
        }
        container.register(DashboardNavigationController.self) { r in
            return DashboardNavigationController(resolver: r.resolve(DiResolver.self)!)
        }
        container.register(DashboardViewController.self) { r in
            return DashboardViewController(resolver: r.resolve(DiResolver.self)!)
        }
        container.register(DashboardModel.self) { r in
            return DashboardModel(apiService: r.resolve(ApiService.self)!, userManager: r.resolve(UserManager.self)!, storageManager: r.resolve(StorageManager.self)!, emarsysService: r.resolve(EmarsysService.self)!)
        }
        container.register(SearchViewController.self) { r in
            return SearchViewController(resolver: r.resolve(DiResolver.self)!)
        }
        container.register(SettingsViewController.self) { r in
            return SettingsViewController(resolver: r.resolve(DiResolver.self)!)
        }
        container.register(WishlistViewController.self) { r in
            return WishlistViewController(resolver: r.resolve(DiResolver.self)!)
        }
        container.register(BasketNavigationController.self) { r in
            return BasketNavigationController(resolver: r.resolve(DiResolver.self)!)
        }
        container.register(BasketViewController.self) { r in
            return BasketViewController(resolver: r.resolve(DiResolver.self)!)
        }
        container.register(BasketModel.self) { r in
            return BasketModel(apiService: r.resolve(ApiService.self)!, basketManager: r.resolve(BasketManager.self)!)
        }
        container.register(ProductDetailsViewController.self) { r in
            return ProductDetailsViewController(resolver: r.resolve(DiResolver.self)!)
        }
        container.register(ProductDetailsModel.self) { r in
            return ProductDetailsModel()
        }
        container.register(ProductPageViewController.self) { r in
            return ProductPageViewController(resolver: r.resolve(DiResolver.self)!)
        }
        container.register(ProductPageModel.self) { r in
            return ProductPageModel(api: r.resolve(ApiService.self)!)
        }
    }
}
