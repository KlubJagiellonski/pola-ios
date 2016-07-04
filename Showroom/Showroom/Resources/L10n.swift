// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation

enum L10n {
  /// Wysyłka w %@ dzień
  case CommonDeliveryInfoSingle(String)
  /// Wysyłka w %@ dni
  case CommonDeliveryInfoMulti(String)
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
  /// 0 (usuń z koszyka)
  case BasketAmount0
  /// Usuń
  case BasketDelete
  /// TWÓJ KOSZYK JEST PUSTY
  case BasketEmpty
  /// ZACZNIJ ZAKUPY
  case BasketStartShopping
  /// SPOSÓB DOSTAWY
  case BasketDeliveryTitle
  /// Kraj dostawy
  case BasketDeliveryDeliveryCountry
  /// Sposób dostawy
  case BasketDeliveryDeliveryOption
  /// W SHOWROOM każdy projektant wysyła produkty oddzielnie, dlatego ponosisz koszty wysyłki kilkukrotnie. Możesz wybrać tylko jeden sposób wysyłki dla całego zamówienia.
  case BasketDeliveryInfo
  /// OK
  case BasketDeliveryOk
  /// KRAJ DOSTAWY
  case BasketDeliveryDeliveryCountryTitle
  /// Poniższe produkty zostały usunięte z listy, ponieważ już nie są dostępne:
  case BasketErrorProductsRemoved
  /// Ceny poniższych produktów uległy zmianie:
  case BasketErrorPriceChanged
  /// Cena lub termin wysyłki poniższych marek uległy zmianie:
  case BasketErrorDeilveryInfoChanged
  /// Ilość poniższych produktów została zmniejszona:
  case BasketErrorProductsAmountChanged
  /// Błąd kodu rabatowego:
  case BasketErrorInvalidDiscountCode
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
  /// Inne produkty %@
  case ProductDetailsOtherBrandProducts(String)
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
  case CheckoutDeliveryAddressFormFirstName
  /// Nazwisko
  case CheckoutDeliveryAddressFormLastName
  /// Ulica, numer domu i mieszkania
  case CheckoutDeliveryAddressFormStreetAndApartmentNumbers
  /// Kod pocztowy
  case CheckoutDeliveryAddressFormPostalCode
  /// Miejscowość
  case CheckoutDeliveryAddressFormCity
  /// Kraj
  case CheckoutDeliveryAddressFormCountry
  /// Numer telefonu
  case CheckoutDeliveryAddressFormPhone
  /// Adres
  case CheckoutDeliveryAdressHeader
  /// EDYTUJ ADRES
  case CheckoutDeliveryAdressEdit
  /// DODAJ INNY ADRES
  case CheckoutDeliveryAdressAdd
  /// ul.
  case CheckoutDeliveryAdressStreet
  /// tel.
  case CheckoutDeliveryAdressPhoneNumber
  /// Dostawa
  case CheckoutDeliveryDeliveryHeader
  /// Paczka w Ruchu
  case CheckoutDeliveryDeliveryRUCH
  /// Polska, kurier UPS
  case CheckoutDeliveryDeliveryCourier
  /// WYBIERZ KIOSK
  case CheckoutDeliveryDeliveryRUCHPickKiosk
  /// ZMIEŃ KIOSK
  case CheckoutDeliveryDeliveryRUCHChangeKiosk
  /// DALEJ
  case CheckoutDeliveryNext
  /// Dodaj inny adres
  case CheckoutDeliveryEditAddressNavigationHeader
  /// ZAPISZ
  case CheckoutDeliveryEditAddressSave
  /// Coś poszło nie tak. Nie udało się załadować danych.
  case CommonError
  /// Podsumowanie
  case CheckoutSummaryNavigationHeader
  /// %@ szt. Rozmiar: %@ Kolor: %@
  case CheckoutSummaryProductDescription(String, String, String)
  /// Uwagi do projektanta
  case CheckoutSummaryCommentTitle
  /// DODAJ UWAGĘ
  case CheckoutSummaryAddComment
  /// EDYTUJ
  case CheckoutSummaryEditComment
  /// USUŃ
  case CheckoutSummaryDeleteComment
  /// ZAPISZ
  case CheckoutSummarySaveComment
  /// Tutaj wpisz wiadomość do projektanta.
  case CheckoutSummaryCommentPlaceholder
  /// Przecena
  case CheckoutSummaryDiscount
  /// Kwota do zapłaty
  case CheckoutSummaryTotalPrice
  /// Sposób płatności
  case CheckoutSummaryPaymentMethod
  /// płatność PayU
  case CheckoutSummaryPayU
  /// opłata za pobraniem
  case CheckoutSummaryCash
  /// KUP I ZAPŁAĆ
  case CheckoutSummaryBuy
  /// NEW
  case ProductListBadgeNew
  /// DARMOWA DOSTAWA
  case ProductListBadgeFreeDelivery
  /// PREMIUM
  case ProductListBadgePremium
  /// Logowanie
  case LoginNavigationHeader
  /// ZALOGUJ SIĘ Z FACEBOOKIEM
  case LoginLoginWithFacebook
  /// lub
  case LoginOr
  /// E-mail
  case LoginEmail
  /// Hasło
  case LoginPassword
  /// ZALOGUJ SIĘ
  case LoginLoginButton
  /// Przypomnienie hasła
  case LoginPassReminder
  /// Załóż nowe konto
  case LoginNewAccount
  /// To pole nie może być puste
  case ValidatorNotEmpty
  /// Brakuje międzynarodowego numeru kierunkowego (np. +48)
  case ValidatorPhoneNumber
  /// Niepoprawny format adresu
  case ValidatorEmail
}

extension L10n: CustomStringConvertible {
  var description: String { return self.string }

  var string: String {
    switch self {
      case .CommonDeliveryInfoSingle(let p0):
        return L10n.tr("Common.DeliveryInfo.Single", p0)
      case .CommonDeliveryInfoMulti(let p0):
        return L10n.tr("Common.DeliveryInfo.Multi", p0)
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
      case .BasketAmount0:
        return L10n.tr("Basket.Amount0")
      case .BasketDelete:
        return L10n.tr("Basket.Delete")
      case .BasketEmpty:
        return L10n.tr("Basket.Empty")
      case .BasketStartShopping:
        return L10n.tr("Basket.StartShopping")
      case .BasketDeliveryTitle:
        return L10n.tr("Basket.Delivery.Title")
      case .BasketDeliveryDeliveryCountry:
        return L10n.tr("Basket.Delivery.DeliveryCountry")
      case .BasketDeliveryDeliveryOption:
        return L10n.tr("Basket.Delivery.DeliveryOption")
      case .BasketDeliveryInfo:
        return L10n.tr("Basket.Delivery.Info")
      case .BasketDeliveryOk:
        return L10n.tr("Basket.Delivery.Ok")
      case .BasketDeliveryDeliveryCountryTitle:
        return L10n.tr("Basket.Delivery.DeliveryCountryTitle")
      case .BasketErrorProductsRemoved:
        return L10n.tr("Basket.Error.ProductsRemoved")
      case .BasketErrorPriceChanged:
        return L10n.tr("Basket.Error.PriceChanged")
      case .BasketErrorDeilveryInfoChanged:
        return L10n.tr("Basket.Error.DeilveryInfoChanged")
      case .BasketErrorProductsAmountChanged:
        return L10n.tr("Basket.Error.ProductsAmountChanged")
      case .BasketErrorInvalidDiscountCode:
        return L10n.tr("Basket.Error.InvalidDiscountCode")
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
      case .ProductDetailsOtherBrandProducts(let p0):
        return L10n.tr("ProductDetails.OtherBrandProducts", p0)
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
      case .CheckoutDeliveryAddressFormFirstName:
        return L10n.tr("Checkout.Delivery.AddressForm.FirstName")
      case .CheckoutDeliveryAddressFormLastName:
        return L10n.tr("Checkout.Delivery.AddressForm.LastName")
      case .CheckoutDeliveryAddressFormStreetAndApartmentNumbers:
        return L10n.tr("Checkout.Delivery.AddressForm.StreetAndApartmentNumbers")
      case .CheckoutDeliveryAddressFormPostalCode:
        return L10n.tr("Checkout.Delivery.AddressForm.PostalCode")
      case .CheckoutDeliveryAddressFormCity:
        return L10n.tr("Checkout.Delivery.AddressForm.City")
      case .CheckoutDeliveryAddressFormCountry:
        return L10n.tr("Checkout.Delivery.AddressForm.Country")
      case .CheckoutDeliveryAddressFormPhone:
        return L10n.tr("Checkout.Delivery.AddressForm.Phone")
      case .CheckoutDeliveryAdressHeader:
        return L10n.tr("Checkout.Delivery.Adress.Header")
      case .CheckoutDeliveryAdressEdit:
        return L10n.tr("Checkout.Delivery.Adress.Edit")
      case .CheckoutDeliveryAdressAdd:
        return L10n.tr("Checkout.Delivery.Adress.Add")
      case .CheckoutDeliveryAdressStreet:
        return L10n.tr("Checkout.Delivery.Adress.Street")
      case .CheckoutDeliveryAdressPhoneNumber:
        return L10n.tr("Checkout.Delivery.Adress.PhoneNumber")
      case .CheckoutDeliveryDeliveryHeader:
        return L10n.tr("Checkout.Delivery.Delivery.Header")
      case .CheckoutDeliveryDeliveryRUCH:
        return L10n.tr("Checkout.Delivery.Delivery.RUCH")
      case .CheckoutDeliveryDeliveryCourier:
        return L10n.tr("Checkout.Delivery.Delivery.Courier")
      case .CheckoutDeliveryDeliveryRUCHPickKiosk:
        return L10n.tr("Checkout.Delivery.Delivery.RUCH.PickKiosk")
      case .CheckoutDeliveryDeliveryRUCHChangeKiosk:
        return L10n.tr("Checkout.Delivery.Delivery.RUCH.ChangeKiosk")
      case .CheckoutDeliveryNext:
        return L10n.tr("Checkout.Delivery.Next")
      case .CheckoutDeliveryEditAddressNavigationHeader:
        return L10n.tr("Checkout.Delivery.EditAddress.NavigationHeader")
      case .CheckoutDeliveryEditAddressSave:
        return L10n.tr("Checkout.Delivery.EditAddress.Save")
      case .CommonError:
        return L10n.tr("CommonError")
      case .CheckoutSummaryNavigationHeader:
        return L10n.tr("Checkout.Summary.NavigationHeader")
      case .CheckoutSummaryProductDescription(let p0, let p1, let p2):
        return L10n.tr("Checkout.Summary.ProductDescription", p0, p1, p2)
      case .CheckoutSummaryCommentTitle:
        return L10n.tr("Checkout.Summary.CommentTitle")
      case .CheckoutSummaryAddComment:
        return L10n.tr("Checkout.Summary.AddComment")
      case .CheckoutSummaryEditComment:
        return L10n.tr("Checkout.Summary.EditComment")
      case .CheckoutSummaryDeleteComment:
        return L10n.tr("Checkout.Summary.DeleteComment")
      case .CheckoutSummarySaveComment:
        return L10n.tr("Checkout.Summary.SaveComment")
      case .CheckoutSummaryCommentPlaceholder:
        return L10n.tr("Checkout.Summary.CommentPlaceholder")
      case .CheckoutSummaryDiscount:
        return L10n.tr("Checkout.Summary.Discount")
      case .CheckoutSummaryTotalPrice:
        return L10n.tr("Checkout.Summary.TotalPrice")
      case .CheckoutSummaryPaymentMethod:
        return L10n.tr("Checkout.Summary.PaymentMethod")
      case .CheckoutSummaryPayU:
        return L10n.tr("Checkout.Summary.PayU")
      case .CheckoutSummaryCash:
        return L10n.tr("Checkout.Summary.Cash")
      case .CheckoutSummaryBuy:
        return L10n.tr("Checkout.Summary.Buy")
      case .ProductListBadgeNew:
        return L10n.tr("ProductList.Badge.New")
      case .ProductListBadgeFreeDelivery:
        return L10n.tr("ProductList.Badge.FreeDelivery")
      case .ProductListBadgePremium:
        return L10n.tr("ProductList.Badge.Premium")
      case .LoginNavigationHeader:
        return L10n.tr("Login.NavigationHeader")
      case .LoginLoginWithFacebook:
        return L10n.tr("Login.LoginWithFacebook")
      case .LoginOr:
        return L10n.tr("Login.Or")
      case .LoginEmail:
        return L10n.tr("Login.Email")
      case .LoginPassword:
        return L10n.tr("Login.Password")
      case .LoginLoginButton:
        return L10n.tr("Login.LoginButton")
      case .LoginPassReminder:
        return L10n.tr("Login.PassReminder")
      case .LoginNewAccount:
        return L10n.tr("Login.NewAccount")
      case .ValidatorNotEmpty:
        return L10n.tr("Validator.NotEmpty")
      case .ValidatorPhoneNumber:
        return L10n.tr("Validator.PhoneNumber")
      case .ValidatorEmail:
        return L10n.tr("Validator.Email")
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

