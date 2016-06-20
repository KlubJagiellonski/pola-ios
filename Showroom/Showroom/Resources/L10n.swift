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
  /// 0 (usuń z koszyka)
  case BasketAmount0
  /// Usuń
  case BasketDelete
  /// SPOSÓB DOSTAWY
  case BasketDeliveryTitle
  /// Kraj dostawy
  case BasketDeliveryDeliveryCountry
  /// Sposób dostawy
  case BasketDeliveryDeliveryOption
  /// kurier UPS
  case BasketDeliveryUPS
  /// paczka w RUCH-u
  case BasketDeliveryRUCH
  /// W SHOWROOM każdy projektant wysyła produkty oddzielnie, dlatego ponosisz koszty wysyłki kilkukrotnie. Możesz wybrać tylko jeden sposób wysyłki dla całego zamówienia.
  case BasketDeliveryInfo
  /// OK
  case BasketDeliveryOk
  /// KRAJ DOSTAWY
  case BasketDeliveryDeliveryCountryTitle
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
  /// WYBIERZ KOLOR
  case ProductActionPickColorTitle
  /// tylko w innym rozmiarze
  case ProductActionColorCellColorUnavailable
  /// WYBIERZ ILOŚĆ
  case ProductActionPickAmountTitle
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
  /// TABELA ROZMIARÓW
  case ProductDetailsSizeChartUppercase
  /// rozmiar
  case ProductDetailsSizeChartSize
  /// Kasa
  case CheckoutDeliveryNavigationHeader
  /// Adres dostawy
  case CheckoutDeliveryCourierHeader
  /// Twój adres
  case CheckoutDeliveryRUCHHeader
  /// Imię
  case CheckoutDeliveryFirstName
  /// Nazwisko
  case CheckoutDeliveryLastName
  /// Adres
  case CheckoutDeliveryAdressHeader
  /// EDYTUJ ADRES
  case CheckoutDeliveryAdressEdit
  /// DODAJ INNY ADRES
  case CheckoutDeliveryAdressAdd
  /// Dostawa
  case CheckoutDeliveryDeliveryHeader
  /// WYBIERZ KIOSK
  case CheckoutDeliveryDeliveryRUCHPickKiosk
  /// ZMIEŃ KIOSK
  case CheckoutDeliveryDeliveryRUCHChangeKiosk
  /// DALEJ
  case CheckoutDeliveryNext
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
      case .BasketAmount0:
        return L10n.tr("Basket.Amount0")
      case .BasketDelete:
        return L10n.tr("Basket.Delete")
      case .BasketDeliveryTitle:
        return L10n.tr("Basket.Delivery.Title")
      case .BasketDeliveryDeliveryCountry:
        return L10n.tr("Basket.Delivery.DeliveryCountry")
      case .BasketDeliveryDeliveryOption:
        return L10n.tr("Basket.Delivery.DeliveryOption")
      case .BasketDeliveryUPS:
        return L10n.tr("Basket.Delivery.UPS")
      case .BasketDeliveryRUCH:
        return L10n.tr("Basket.Delivery.RUCH")
      case .BasketDeliveryInfo:
        return L10n.tr("Basket.Delivery.Info")
      case .BasketDeliveryOk:
        return L10n.tr("Basket.Delivery.Ok")
      case .BasketDeliveryDeliveryCountryTitle:
        return L10n.tr("Basket.Delivery.DeliveryCountryTitle")
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
      case .ProductActionPickColorTitle:
        return L10n.tr("ProductAction.PickColorTitle")
      case .ProductActionColorCellColorUnavailable:
        return L10n.tr("ProductAction.ColorCell.ColorUnavailable")
      case .ProductActionPickAmountTitle:
        return L10n.tr("ProductAction.PickAmountTitle")
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
      case .ProductDetailsSizeChartUppercase:
        return L10n.tr("ProductDetails.SizeChart.Uppercase")
      case .ProductDetailsSizeChartSize:
        return L10n.tr("ProductDetails.SizeChart.Size")
      case .CheckoutDeliveryNavigationHeader:
        return L10n.tr("Checkout.Delivery.NavigationHeader")
      case .CheckoutDeliveryCourierHeader:
        return L10n.tr("Checkout.Delivery.Courier.Header")
      case .CheckoutDeliveryRUCHHeader:
        return L10n.tr("Checkout.Delivery.RUCH.Header")
      case .CheckoutDeliveryFirstName:
        return L10n.tr("Checkout.Delivery.FirstName")
      case .CheckoutDeliveryLastName:
        return L10n.tr("Checkout.Delivery.LastName")
      case .CheckoutDeliveryAdressHeader:
        return L10n.tr("Checkout.Delivery.Adress.Header")
      case .CheckoutDeliveryAdressEdit:
        return L10n.tr("Checkout.Delivery.Adress.Edit")
      case .CheckoutDeliveryAdressAdd:
        return L10n.tr("Checkout.Delivery.Adress.Add")
      case .CheckoutDeliveryDeliveryHeader:
        return L10n.tr("Checkout.Delivery.Delivery.Header")
      case .CheckoutDeliveryDeliveryRUCHPickKiosk:
        return L10n.tr("Checkout.Delivery.Delivery.RUCH.PickKiosk")
      case .CheckoutDeliveryDeliveryRUCHChangeKiosk:
        return L10n.tr("Checkout.Delivery.Delivery.RUCH.ChangeKiosk")
      case .CheckoutDeliveryNext:
        return L10n.tr("Checkout.Delivery.Next")
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

