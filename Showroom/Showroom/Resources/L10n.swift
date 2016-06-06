// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation

enum L10n {
  /// Główna
  case MainTabDashboard
  /// Przeglądanie
  case MainTabSearch
  /// Koszyk
  case MainTabBasket
  /// Ulubione
  case MainTabWishlist
  /// Ustawienia
  case MainTabSettings
  /// KOD RABATOWY
  case BasketDiscountCode
  /// WYSYŁKA
  case BasketShipping
  /// SUMA
  case BasketTotalPrice
  /// ZMIEŃ
  case BasketShippingChange
  /// DO KASY
  case BasketCheckoutButton
  /// zniżka
  case BasketDiscount
  /// Wysyłka w
  case BasketShippingIn
  /// dzień
  case BasketDay
  /// dni
  case BasketDays
  /// POLECANE
  case DashboardRecommendationTitleFirstPart
  /// dla Ciebie
  case DashboardRecommendationTitleSecondPart
  /// zł
  case MoneyZl
  /// DO KOSZYKA
  case ProductDetailsToBasket
}

extension L10n: CustomStringConvertible {
  var description: String { return self.string }

  var string: String {
    switch self {
      case .MainTabDashboard:
        return L10n.tr("MainTab.Dashboard")
      case .MainTabSearch:
        return L10n.tr("MainTab.Search")
      case .MainTabBasket:
        return L10n.tr("MainTab.Basket")
      case .MainTabWishlist:
        return L10n.tr("MainTab.Wishlist")
      case .MainTabSettings:
        return L10n.tr("MainTab.Settings")
      case .BasketDiscountCode:
        return L10n.tr("Basket.DiscountCode")
      case .BasketShipping:
        return L10n.tr("Basket.Shipping")
      case .BasketTotalPrice:
        return L10n.tr("Basket.TotalPrice")
      case .BasketShippingChange:
        return L10n.tr("Basket.ShippingChange")
      case .BasketCheckoutButton:
        return L10n.tr("Basket.CheckoutButton")
      case .BasketDiscount:
        return L10n.tr("Basket.Discount")
      case .BasketShippingIn:
        return L10n.tr("Basket.ShippingIn")
      case .BasketDay:
        return L10n.tr("Basket.Day")
      case .BasketDays:
        return L10n.tr("Basket.Days")
      case .DashboardRecommendationTitleFirstPart:
        return L10n.tr("Dashboard.RecommendationTitle.FirstPart")
      case .DashboardRecommendationTitleSecondPart:
        return L10n.tr("Dashboard.RecommendationTitle.SecondPart")
      case .MoneyZl:
        return L10n.tr("Money.Zl")
      case .ProductDetailsToBasket:
        return L10n.tr("ProductDetails.ToBasket")
    }
  }

  private static func tr(key: String, _ args: CVarArgType...) -> String {
    let format = NSLocalizedString(key, comment: "")
    return String(format: format, locale: NSLocale.currentLocale(), arguments: args)
  }
}

func tr(key: L10n) -> String {
  return key.string
}

