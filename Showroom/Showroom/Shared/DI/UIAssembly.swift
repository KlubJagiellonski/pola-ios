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
            return MainTabViewController(resolver: r.resolve(DiResolver.self)!, basketManager: r.resolve(BasketManager.self)!)
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
        container.register(ProductDetailsViewController.self) { r, context in
            return ProductDetailsViewController(resolver: r.resolve(DiResolver.self)!, context: context)
        }
        container.register(ProductDetailsModel.self) { r, context in
            return ProductDetailsModel(context: context)
        }
        container.register(ProductPageViewController.self) { r, productId, product in
            return ProductPageViewController(resolver: r.resolve(DiResolver.self)!, productId: productId, product: product)
        }
        container.register(ProductPageModel.self) { r, productId, product in
            return ProductPageModel(api: r.resolve(ApiService.self)!, basketManager: r.resolve(BasketManager.self)!, storageManager: r.resolve(StorageManager.self)!, productId: productId, product: product)
        }
        container.register(ProductSizeViewController.self) { r, sizes, selectedSizeId in
            return ProductSizeViewController(resolver: r.resolve(DiResolver.self)!, sizes: sizes, initialSelectedSizeId: selectedSizeId)
        }
        container.register(ProductColorViewController.self) { r, colors, selectedColorId in
            return ProductColorViewController(resolver: r.resolve(DiResolver.self)!, colors: colors, initialSelectedColorId: selectedColorId)
        }
        container.register(ProductAmountViewController.self) { r, product in
            return ProductAmountViewController(resolver: r.resolve(DiResolver.self)!, product: product)
        }
        container.register(ProductDescriptionViewController.self) { r, modelState in
            return ProductDescriptionViewController(modelState: modelState)
        }
        container.register(SizeChartViewController.self) { r, sizes in
            return SizeChartViewController(sizes: sizes)
        }
        container.register(BasketDeliveryNavigationController.self) { r in
            return BasketDeliveryNavigationController(resolver: r.resolve(DiResolver.self)!)
        }
        container.register(BasketDeliveryViewController.self) { r in
            return BasketDeliveryViewController(basketManager: r.resolve(BasketManager.self)!)
        }
        container.register(BasketCountryViewController.self) { r in
            return BasketCountryViewController(basketManager: r.resolve(BasketManager.self)!)
        }
        container.register(CheckoutNavigationController.self) { r in
            return CheckoutNavigationController(resolver: r.resolve(DiResolver.self)!)
        }
        container.register(CheckoutDeliveryViewController.self) { r, basketManager in
            return CheckoutDeliveryViewController(resolver: r.resolve(DiResolver.self)!, basketManager: basketManager)
        }
        container.register(CheckoutSummaryViewController.self) { r in
            return CheckoutSummaryViewController(resolver: r.resolve(DiResolver.self)!)
        }
        container.register(EditAddressViewController.self) { r, formFields, editingState in
            return EditAddressViewController(resolver: r.resolve(DiResolver.self)!, formFields: formFields, editingState: editingState)
        }
        container.register(CheckoutSummaryCommentViewController.self) { r in
            return CheckoutSummaryCommentViewController(resolver: r.resolve(DiResolver.self)!)
        }
        container.register(CategoryProductListViewController.self) { r, category in
            return CategoryProductListViewController(withResolver: r.resolve(DiResolver.self)!, category: category)
        }
        container.register(CategoryProductListModel.self) { r, category in
            return CategoryProductListModel(category: category)
        }
        
    }
}
