import Foundation
import Swinject

class UIAssembly: AssemblyType {
    func assemble(container: Container) {
        container.register(RootViewController.self) { r in
            return RootViewController(resolver: r.resolve(DiResolver.self)!)!
        }
        container.register(RootModel.self) { r in
            return RootModel(with: r.resolve(UserManager.self)!, apiService: r.resolve(ApiService.self)!, rateAppManager: r.resolve(RateAppManager.self)!, notificationManager: r.resolve(NotificationsManager.self)!, versionManager: r.resolve(VersionManager.self)!, platformManager: r.resolve(PlatformManager.self)!, prefetchingManager: r.resolve(PrefetchingManager.self)!, storage: r.resolve(KeyValueStorage.self)!)
        }
        container.register(StartViewController.self) { r in
            return StartViewController(resolver: r.resolve(DiResolver.self)!)
        }
        container.register(MainTabViewController.self) { r in
            return MainTabViewController(resolver: r.resolve(DiResolver.self)!, basketManager: r.resolve(BasketManager.self)!, wishlistManager: r.resolve(WishlistManager.self)!)
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
            return DashboardModel(apiService: r.resolve(ApiService.self)!, userManager: r.resolve(UserManager.self)!, storage: r.resolve(KeyValueStorage.self)!, prefetchingManager: r.resolve(PrefetchingManager.self)!, emarsysService: r.resolve(EmarsysService.self)!)
        }
        container.register(SearchViewController.self) { r in
            return SearchViewController(with: r.resolve(DiResolver.self)!)
        }
        container.register(SearchModel.self) { r in
            return SearchModel(with: r.resolve(ApiService.self)!, and: r.resolve(KeyValueStorage.self)!, and: r.resolve(UserManager.self)!)
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
            return ProductPageModel(api: r.resolve(ApiService.self)!, basketManager: r.resolve(BasketManager.self)!, storage: r.resolve(KeyValueStorage.self)!, wishlistManager: r.resolve(WishlistManager.self)!, productId: productId, product: product)
        }
        container.register(ProductDescriptionNavigationController.self) { r, state, contentInset in
            return ProductDescriptionNavigationController(resolver: r.resolve(DiResolver.self)!, state: state, viewContentInset: contentInset)
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
            return CheckoutDeliveryViewController(with: checkoutModel, and: r.resolve(ToastManager.self)!)
        }
        container.register(CheckoutSummaryViewController.self) { r, model in
            return CheckoutSummaryViewController(resolver: r.resolve(DiResolver.self)!, model: model)
        }
        container.register(EditAddressViewController.self) { r, checkoutModel in
            return EditAddressViewController(with: checkoutModel, and: r.resolve(DiResolver.self)!, and: r.resolve(ToastManager.self)!)
        }
        container.register(CheckoutSummaryCommentViewController.self) { r, comment, index in
            return CheckoutSummaryCommentViewController(resolver: r.resolve(DiResolver.self)!, comment: comment, index: index)
        }
        container.register(CheckoutModel.self) { r, checkout in
            return CheckoutModel(with: checkout, userManager: r.resolve(UserManager.self)!, platformManager: r.resolve(PlatformManager.self)!, paymentManager: r.resolve(PaymentManager.self)!, api: r.resolve(ApiService.self)!, basketManager: r.resolve(BasketManager.self)!, emarsysService: r.resolve(EmarsysService.self)!)
        }
        container.register(CategoryProductListViewController.self) { r, category in
            return CategoryProductListViewController(withResolver: r.resolve(DiResolver.self)!, category: category)
        }
        container.register(CategoryProductListModel.self) { r, category in
            return CategoryProductListModel(with: category, apiService: r.resolve(ApiService.self)!, emarsysService: r.resolve(EmarsysService.self)!, wishlistManager: r.resolve(WishlistManager.self)!)
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
        container.register(ResetPasswordViewController.self) { r in
            return ResetPasswordViewController(resolver: r.resolve(DiResolver.self)!)
        }
        container.register(ResetPasswordModel.self) { r in
            return ResetPasswordModel(with: r.resolve(ApiService.self)!)
        }
        container.register(EditKioskViewController.self) { r, checkoutModel, editKioskEntry in
            return EditKioskViewController(with: r.resolve(DiResolver.self)!, and: checkoutModel, editKioskEntry: editKioskEntry)
        }
        container.register(EditKioskModel.self) { r, checkoutModel in
            return EditKioskModel(with: r.resolve(ApiService.self)!, and: checkoutModel)
        }
        container.register(TrendProductListViewController.self) { r, trendInfo in
            return TrendProductListViewController(with: r.resolve(DiResolver.self)!, and: trendInfo)
        }
        container.register(TrendProductListModel.self) { r, trendInfo in
            return TrendProductListModel(with: r.resolve(ApiService.self)!, emarsysService: r.resolve(EmarsysService.self)!, wishlistManager: r.resolve(WishlistManager.self)!, trendInfo: trendInfo)
        }
        container.register(BrandProductListViewController.self) { r, brand in
            return BrandProductListViewController(with: r.resolve(DiResolver.self)!, and: brand)
        }
        container.register(BrandProductListModel.self) { r, brand in
            return BrandProductListModel(with: r.resolve(ApiService.self)!, wishlistManager: r.resolve(WishlistManager.self)!, emarsysService: r.resolve(EmarsysService.self)!, productBrand: brand)
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
        container.register(SettingsWebViewController.self) { (r: ResolverType, settingsWebType: SettingsWebType) in
            return SettingsWebViewController(model: r.resolve(SettingsWebViewModel.self, argument: settingsWebType)!)
        }
        container.register(SettingsWebViewModel.self) { r, settingsWebType in
            return SettingsWebViewModel(apiService: r.resolve(ApiService.self)!, settingsWebType: settingsWebType)
        }
        container.register(SplashViewController.self) { r in
            return SplashViewController()
        }
        container.register(InitialOnboardingViewController.self) { r in
            return InitialOnboardingViewController(resolver: r.resolve(DiResolver.self)!)
        }
        container.register(ProductFilterNavigationController.self) { r, context in
            return ProductFilterNavigationController(with: r.resolve(DiResolver.self)!, and: context)
        }
        container.register(ProductFilterViewController.self) { r, model in
            return ProductFilterViewController(with: model, and: r.resolve(ToastManager.self)!)
        }
        container.register(ProductFilterModel.self) { r, context in
            return ProductFilterModel(with: context, and: r.resolve(ApiService.self)!)
        }
        container.register(FilterDetailsViewController.self) { r, model, filterInfo in
            return FilterDetailsViewController(with: model, filterInfo: filterInfo, and: r.resolve(ToastManager.self)!)
        }
        container.register(SearchNavigationController.self) { r in
            return SearchNavigationController(with: r.resolve(DiResolver.self)!)
        }
        container.register(SearchProductListViewController.self) { r, data in
            return SearchProductListViewController(with: r.resolve(DiResolver.self)!, entryData: data)
        }
        container.register(SearchProductListModel.self) { r, data in
            return SearchProductListModel(with: data, apiService: r.resolve(ApiService.self)!, wishlistManager: r.resolve(WishlistManager.self)!, emarsysService: r.resolve(EmarsysService.self)!)
        }
        container.register(SearchContentViewController.self) { r, searchItem, contentType in
            return SearchContentViewController(mainSearchItem: searchItem, type: contentType)
        }
        container.register(SearchContentNavigationController.self) { r, searchItem in
            return SearchContentNavigationController(with: r.resolve(DiResolver.self)!, mainSearchItem: searchItem)
        }
        container.register(PaymentSuccessViewController.self) { r, orderNumber, orderUrl in
            return PaymentSuccessViewController(resolver: r.resolve(DiResolver.self)!, orderNumber: orderNumber, orderUrl: orderUrl)
        }
        container.register(PaymentFailureViewController.self) { r, orderNumber, orderUrl in
            return PaymentFailureViewController(resolver: r.resolve(DiResolver.self)!, orderNumber: orderNumber, orderUrl: orderUrl)
        }
        container.register(RateAppViewController.self) { r, type in
            return RateAppViewController(with: type, manager: r.resolve(RateAppManager.self)!, application: r.resolve(UIApplication.self)!)
        }
        container.register(NotificationsAccessViewController.self) { r, type in
            return NotificationsAccessViewController(with: type, manager: r.resolve(NotificationsManager.self)!)
        }
        container.register(UpdateAppViewController.self) { r, imageUrl in
            return UpdateAppViewController(manager: r.resolve(VersionManager.self)!, application: r.resolve(UIApplication.self)!, imageUrl: imageUrl)
        }
        container.register(PlatformSelectionViewController.self) { r in
            return PlatformSelectionViewController(platformManager: r.resolve(PlatformManager.self)!)
        }
        container.register(PromoSlideshowViewController.self) { r, slideshowId in
            return PromoSlideshowViewController(resolver: r.resolve(DiResolver.self)!, slideshowId: slideshowId)
        }
        container.register(PromoSlideshowModel.self) { r, slideshowId in
            return PromoSlideshowModel(apiService: r.resolve(ApiService.self)!, storage: r.resolve(KeyValueStorage.self)!, slideshowId: slideshowId)
        }
        container.register(ImageStepViewController.self) { r, link, duration, pageState in
            return ImageStepViewController(with: r.resolve(DiResolver.self)!, link: link, duration: duration, pageState: pageState)
        }
        container.register(VideoStepViewController.self) { r, link, annotations, additionalData, pageState in
            return VideoStepViewController(with: r.resolve(DiResolver.self)!, link: link, annotations: annotations, additionalData: additionalData, pageState: pageState)
        }
        container.register(ProductStepViewController.self) { r, dataEntry, pageState in
            return ProductStepViewController(with: r.resolve(DiResolver.self)!, dataEntry: dataEntry, pageState: pageState)
        }
        container.register(PromoSummaryViewController.self) { r, promoSlideshow, pageState in
            return PromoSummaryViewController(with: r.resolve(DiResolver.self)!, promoSlideshow: promoSlideshow, pageState: pageState)
        }
        container.register(WebContentViewController.self) { r, webViewId in
            return WebContentViewController(resolver: r.resolve(DiResolver.self)!, webViewId: webViewId)
        }
        container.register(WebContentModel.self) { r, webViewId in
            return WebContentModel(apiService: r.resolve(ApiService.self)!, webViewId: webViewId)
        }
    }
}
