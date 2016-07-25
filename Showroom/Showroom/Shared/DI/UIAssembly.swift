import Foundation
import Swinject

class UIAssembly: AssemblyType {
    func assemble(container: Container) {
        container.register(RootViewController.self) { r in
            return RootViewController(resolver: r.resolve(DiResolver.self)!)!
        }
        container.register(RootModel.self) { r in
            return RootModel(resolver: r.resolve(DiResolver.self)!)
        }
        container.register(StartViewController.self) { r in
            return StartViewController(resolver: r.resolve(DiResolver.self)!)
        }
        container.register(MainTabViewController.self) { r in
            return MainTabViewController(resolver: r.resolve(DiResolver.self)!, basketManager: r.resolve(BasketManager.self)!)
        }
        container.register(CommonPresenterController.self) { r, contentViewController in
            return CommonPresenterController(with: r.resolve(DiResolver.self)!, contentViewController: contentViewController)
        }.inObjectScope(.None)
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
            return SearchViewController(with: r.resolve(DiResolver.self)!)
        }
        container.register(SearchModel.self) { r in
            return SearchModel(with: r.resolve(ApiService.self)!)
        }
        container.register(SettingsViewController.self) { r in
            return SettingsViewController(resolver: r.resolve(DiResolver.self)!)
        }
        container.register(WishlistNavigationController.self) { r in
            return WishlistNavigationController(resolver: r.resolve(DiResolver.self)!)
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
            return ProductDetailsModel(context: context, emarsysService: r.resolve(EmarsysService.self)!)
        }
        container.register(ProductPageViewController.self) { r, productId, product in
            return ProductPageViewController(resolver: r.resolve(DiResolver.self)!, productId: productId, product: product)
        }
        container.register(ProductPageModel.self) { r, productId, product in
            return ProductPageModel(api: r.resolve(ApiService.self)!, basketManager: r.resolve(BasketManager.self)!, storageManager: r.resolve(StorageManager.self)!, wishlistManager: r.resolve(WishlistManager.self)!, productId: productId, product: product)
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
        container.register(CheckoutNavigationController.self) { r, checkout in
            return CheckoutNavigationController(with: r.resolve(DiResolver.self)!, and: checkout)
        }
        container.register(CheckoutDeliveryViewController.self) { r, checkoutModel in
            return CheckoutDeliveryViewController(with: checkoutModel)
        }
        container.register(CheckoutSummaryViewController.self) { r, model in
            return CheckoutSummaryViewController(resolver: r.resolve(DiResolver.self)!, model: model)
        }
        container.register(EditAddressViewController.self) { r, userAddress, defaultCountry in
            return EditAddressViewController(with: userAddress, defaultCountry: defaultCountry)
        }
        container.register(CheckoutSummaryCommentViewController.self) { r, comment, index in
            return CheckoutSummaryCommentViewController(resolver: r.resolve(DiResolver.self)!, comment: comment, index: index)
        }
        container.register(CheckoutModel.self) { r, checkout in
            return CheckoutModel(with: checkout, and: r.resolve(UserManager.self)!)
        }
        container.register(CategoryProductListViewController.self) { r, category in
            return CategoryProductListViewController(withResolver: r.resolve(DiResolver.self)!, category: category)
        }
        container.register(CategoryProductListModel.self) { r, category in
            return CategoryProductListModel(with: category, and: r.resolve(ApiService.self)!)
        }
        container.register(SigningNavigationController.self) { r, mode in
            return SigningNavigationController(resolver: r.resolve(DiResolver.self)!, mode: mode)
        }
        container.register(LoginViewController.self) { r in
            return LoginViewController(resolver: r.resolve(DiResolver.self)!)
        }
        container.register(RegistrationViewController.self) { r in
            return RegistrationViewController(resolver: r.resolve(DiResolver.self)!)
        }
        container.register(EditKioskViewController.self) { r, checkoutModel in
            return EditKioskViewController(with: r.resolve(DiResolver.self)!, and: checkoutModel)
        }
        container.register(EditKioskModel.self) { r, checkoutModel in
            return EditKioskModel(with: r.resolve(ApiService.self)!, and: checkoutModel)
        }
        container.register(TrendProductListViewController.self) { r, trendInfo in
            return TrendProductListViewController(with: r.resolve(DiResolver.self)!, and: trendInfo)
        }
        container.register(TrendProductListModel.self) { r, trendInfo in
            return TrendProductListModel(with: r.resolve(ApiService.self)!, and: trendInfo)
        }
        container.register(BrandProductListViewController.self) { r, brand in
            return BrandProductListViewController(with: r.resolve(DiResolver.self)!, and: brand)
        }
        container.register(BrandProductListModel.self) { r, brand in
            return BrandProductListModel(with: r.resolve(ApiService.self)!, and: r.resolve(EmarsysService.self)!, and: brand)
        }
        container.register(BrandDescriptionViewController.self) { r, brand in
            return BrandDescriptionViewController(with: brand)
        }
        container.register(SettingsNavigationController.self) { r in
            return SettingsNavigationController(resolver: r.resolve(DiResolver.self)!)
        }
        container.register(SettingsViewController.self) { r in
            return SettingsViewController(resolver: r.resolve(DiResolver.self)!)
        }
        container.register(HistoryOfOrderViewController.self) { r in
            return HistoryOfOrderViewController(resolver: r.resolve(DiResolver.self)!)
        }
        container.register(SettingsWebViewController.self) { r, url in
            return SettingsWebViewController(resolver: r.resolve(DiResolver.self)!, url: url)
        }
        container.register(UserInfoViewController.self) { r, user in
            return UserInfoViewController(resolver: r.resolve(DiResolver.self)!, initialUser: user)
        }
        container.register(SplashViewController.self) { r in
            return SplashViewController()
        }
        container.register(OnboardingViewController.self) { r in
            return OnboardingViewController(resolver: r.resolve(DiResolver.self)!)
        }
        container.register(ProductFilterNavigationController.self) { r, filter in
            return ProductFilterNavigationController(with: r.resolve(DiResolver.self)!, and: filter)
        }
        container.register(ProductFilterViewController.self) { r, model in
            return ProductFilterViewController(with: model)
        }
        container.register(ProductFilterModel.self) { r, filter in
            return ProductFilterModel(with: filter, and: r.resolve(ApiService.self)!)
        }
        container.register(FilterDetailsViewController.self) { r, model, option in
            return FilterDetailsViewController(with: model, and: option)
        }
        container.register(SearchNavigationController.self) { r in
            return SearchNavigationController(with: r.resolve(DiResolver.self)!)
        }
        container.register(SearchProductListViewController.self) { r, data in
            return SearchProductListViewController(with: r.resolve(DiResolver.self)!, entryData: data)
        }
        container.register(SearchProductListModel.self) { r, data in
            return SearchProductListModel(with: data, and: r.resolve(ApiService.self)!, and: r.resolve(EmarsysService.self)!)
        }
        container.register(SearchContentViewController.self) { r, searchItem, contentType in
            return SearchContentViewController(mainSearchItem: searchItem, type: contentType)
        }
        container.register(SearchContentNavigationController.self) { r, searchItem in
            return SearchContentNavigationController(with: r.resolve(DiResolver.self)!, mainSearchItem: searchItem)
        }
    }
}
