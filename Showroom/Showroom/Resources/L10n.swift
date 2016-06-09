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
  /// WYBIERZ ROZMIAR
  case ProductActionPickSizeTitleFirstPart
  /// TABELA ROZMIARÓW
  case ProductActionPickSizeTitleSecondPart
  /// brak rozmiaru w wybranym kolorze
  case ProductActionSizeCellSizeUnavailable
  /// tylko w innym rozmiarze
  case ProductActionColorCellColorUnavailable
  /// DO KOSZYKA
  case ProductDetailsToBasket
  /// Tabela rozmiarów
  case ProductDetailsSizeChart
  /// Inne produkty marki
  case ProductDetailsOtherBrandProducts
  /// Wysyłka w %@ dzień
  case ProductDetailsDeliveryInfoSingle(String)
  /// Wysyłka w %@ dni
  case ProductDetailsDeliveryInfoMulti(String)
  /// Opis produktu
  case ProductDetailsProductDescription
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
      case .ProductActionPickSizeTitleFirstPart:
        return L10n.tr("ProductAction.PickSizeTitle.FirstPart")
      case .ProductActionPickSizeTitleSecondPart:
        return L10n.tr("ProductAction.PickSizeTitle.SecondPart")
      case .ProductActionSizeCellSizeUnavailable:
        return L10n.tr("ProductAction.SizeCell.SizeUnavailable")
      case .ProductActionColorCellColorUnavailable:
        return L10n.tr("ProductAction.ColorCell.ColorUnavailable")
      case .ProductDetailsToBasket:
        return L10n.tr("ProductDetails.ToBasket")
      case .ProductDetailsSizeChart:
        return L10n.tr("ProductDetails.SizeChart")
      case .ProductDetailsOtherBrandProducts:
        return L10n.tr("ProductDetails.OtherBrandProducts")
      case .ProductDetailsDeliveryInfoSingle(let p0):
        return L10n.tr("ProductDetails.DeliveryInfo.Single", p0)
      case .ProductDetailsDeliveryInfoMulti(let p0):
        return L10n.tr("ProductDetails.DeliveryInfo.Multi", p0)
      case .ProductDetailsProductDescription:
        return L10n.tr("ProductDetails.ProductDescription")
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

