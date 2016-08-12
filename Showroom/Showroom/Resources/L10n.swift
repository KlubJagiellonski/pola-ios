// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation

enum L10n {
  /// Wysyłka w %@ dzień
  case CommonDeliveryInfoSingle(String)
  /// Wysyłka w %@ dni
  case CommonDeliveryInfoMulti(String)
  /// Coś poszło nie tak. Nie udało się załadować danych.
  case CommonError
  /// Nie udało się załadować danych.
  case CommonErrorShort
  /// UUUPS!
  case CommonEmptyResultTitle
  /// E-mail
  case CommonEmail
  /// Hasło
  case CommonPassword
  /// Cześć, %@!
  case CommonGreeting(String)
  /// Niestety użytkownik został wylogowany. Zaloguj ponownie.
  case CommonUserLoggedOut
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
  /// Wybór kiosku
  case CheckoutDeliveryEditKioskNavigationHeader
  /// Znajdź kiosk w pobliżu
  case CheckoutDeliveryEditKioskSearchInputLabel
  /// Piękna 5, Warszawa
  case CheckoutDeliveryEditKioskSearchInputPlaceholder
  /// Nie znaleziono adresu
  case CheckoutDeliveryEditKioskGeocodingError
  /// WYBIERZ
  case CheckoutDeliveryEditKioskSave
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
  /// Kod rabatowy %@
  case CheckoutSummaryDiscountCode(String)
  /// Kwota do zapłaty
  case CheckoutSummaryTotalPrice
  /// Sposób płatności
  case CheckoutSummaryPaymentMethod
  /// KUP I ZAPŁAĆ
  case CheckoutSummaryBuy
  /// SUKCES!
  case CheckoutPaymentResultSuccessHeader
  /// Twoje zamówienie nr %@ zostało złożone do realizacji. Możesz sprawdzić status zamówienia w %@.
  case CheckoutPaymentResultSuccessDescription(String, String)
  /// serwisie internetowym
  case CheckoutPaymentResultWebsiteLink
  /// UUUPS!
  case CheckoutPaymentResultFailureHeader
  /// Twoje zamówienie nr %@ zostało złożone, jednak nie udało się go opłacić. Możesz to zrobić w %@.
  case CheckoutPaymentResultFailureDescription(String, String)
  /// POWRÓT DO EKRANU GŁÓWNEGO
  case CheckoutPaymentResultGoToMain
  /// NEW
  case ProductListBadgeNew
  /// DARMOWA DOSTAWA
  case ProductListBadgeFreeDelivery
  /// PREMIUM
  case ProductListBadgePremium
  /// Niestety nie znaleziono żadnych produktów.
  case ProductListEmptyDescription
  /// Niestety nie znaleziono żadnych produktów.\nSpróbuj ponownie z innym hasłem.
  case ProductListEmptySearchDescription
  /// Filtry
  case ProductListFilterTitle
  /// Anuluj
  case ProductListFilterCancel
  /// Wyczyść
  case ProductListFilterClear
  /// %@ - %@
  case ProductListFilterPriceRange(String, String)
  /// POKAŻ PRODUKTY
  case ProductListFilterShowProducts
  /// ZASTOSUJ
  case ProductListFilterApply
  /// Wszystkie kategorie
  case ProductListFilterAllCategories
  /// MIN
  case ProductListFilterMin
  /// MAX
  case ProductListFilterMax
  /// Logowanie
  case LoginNavigationHeader
  /// ZALOGUJ SIĘ Z FACEBOOKIEM
  case LoginLoginWithFacebook
  /// lub
  case LoginOr
  /// ZALOGUJ SIĘ
  case LoginLoginButton
  /// Przypomnienie hasła
  case LoginPassReminder
  /// Załóż nowe konto
  case LoginNewAccount
  /// Błędne dane logowania. Spróbuj jeszcze raz.
  case LoginErrorInvalidCredentials
  /// Wystąpił błąd podczas logowania. Spróbuj jeszcze raz.
  case LoginErrorUnknown
  /// Rejestracja
  case RegistrationNavigationHeader
  /// REJESTRACJA Z FACEBOOKIEM
  case RegistrationRegisterWithFacebook
  /// lub
  case RegistrationOr
  /// Imię
  case RegistrationName
  /// Powtórz hasło
  case RegistrationRepeatPassword
  /// Płeć
  case RegistrationGender
  /// Kobieta
  case RegistrationFemale
  /// Mężczyzna
  case RegistrationMale
  /// Chcę zapisać się do newslettera
  case RegistrationNewsletterCheck
  /// Akceptuję regulamin SHOWROOM
  case RegistrationRulesCheck
  /// regulamin
  case RegistrationRulesCheckHighlighted
  /// UTWÓRZ KONTO
  case RegistrationCraeteAccount
  /// Masz już konto?
  case RegistrationHaveAccount
  /// Akceptacja regulaminu jest wymagana do utworzenia konta w serwisie SHOWROOM.
  case RegistrationRequiringRulesMessage
  /// Wystąpił błąd podczas rejestracji. Spróbuj jeszcze raz.
  case RegistrationErrorUnknown
  /// Reset hasła
  case ResetPasswordNavigationHeader
  /// Wpisz adres e-mail powiązany z Twoim kontem.
  case ResetPasswordEmailDescription
  /// ZRESETUJ
  case ResetPasswordReset
  /// Nowe hasło zostało wysłane na podany adres e-mail.
  case ResetPasswordSuccessDescription
  /// To pole nie może być puste
  case ValidatorNotEmpty
  /// Brakuje międzynarodowego numeru kierunkowego (np. +48)
  case ValidatorPhoneNumber
  /// Niepoprawny format adresu
  case ValidatorEmail
  /// O projektancie
  case BrandAboutTitle
  /// Powtórzone hasło jest inne
  case ValidatorRepeatPassword
  /// Zaloguj się
  case SettingsLogin
  /// Wyloguj
  case SettingsLogout
  /// Załóż konto
  case SettingsCreateAccount
  /// Domyślna oferta
  case SettingsDefaultOffer
  /// ON
  case SettingsMale
  /// ONA
  case SettingsFemale
  /// Zgoda na notyfikacje
  case SettingsPermissionForNotifications
  /// Spytaj
  case SettingsAskForNotifications
  /// Twoje dane
  case SettingsUserData
  /// Historia zamówień
  case SettingsHistory
  /// Jak się mierzyć?
  case SettingsHowToMeasure
  /// Polityka prywatności
  case SettingsPrivacyPolicy
  /// Częste pytania
  case SettingsFrequentQuestions
  /// Regulamin
  case SettingsRules
  /// Kontakt
  case SettingsContact
  /// przeglądaj produkty
  case StartBrowse
  /// DLA NIEJ
  case StartForHer
  /// DLA NIEGO
  case StartForHim
  /// ZALOGUJ SIĘ
  case StartLogin
  /// ZAREJESTRUJ SIĘ
  case StartRegister
  /// Przeglądaj tysiące produktów bezpośrednio od polskich projektantów
  case OnboardingInfiniteScrollingLabel
  /// Za chwilę zostaniesz poproszony o zgodę na notyfikacje, które pozwolą na informowanie Ciebie o promocjach.
  case OnboardingNotificationsLabel
  /// SPYTAJ MNIE
  case OnboardingNotificationsAskMe
  /// POMIŃ
  case OnboardingNotificationsSkip
  /// Stuknij dwukrotnie w zdjęcie, aby dodać produkt do ulubionych
  case OnboardingDoubleTapLabel
  /// Przesuń palcem w bok, aby przejść do kolejnego produktu z listy
  case OnboardingProductPagingLabel
  /// szukaj
  case SearchPlaceholder
  /// WSZYSTKO: %@
  case SearchAllSearchItems(String)
  /// Cofnij
  case SearchBack
  /// Możesz łatwo dodawać produkty z\U00A0listy dwukrotnie stukając palcem w\U00A0ich zdjęcia.
  case WishlistEmptyDescription
  /// Usuń
  case WishlistDelete
  /// Dashboard
  case QuickActionDashboard
  /// Szukaj
  case QuickActionSearch
  /// Koszyk
  case QuickActionBasket
  /// Ulubione
  case QuickActionWishlist
  /// Profil
  case QuickActionSettings
  /// produkt
  case QuickActionProductCountOne
  /// produkty
  case QuickActionProductCountTwoToFour
  /// produktów
  case QuickActionProductCountFiveAndMore
  /// Wersja nie wspierana
  case AppVersionNotSupportedTitle
  /// Ta wersja aplikacji nie jest już wspierana. Aby dalej korzystać z Showroom zainstaluj najnowszą wersję z App Store
  case AppVersionNotSupportedDescription
  /// App Store
  case AppVersionNotSupportedAccept
  /// Anuluj
  case AppVersionNotSupportedDecline
}

extension L10n: CustomStringConvertible {
  var description: String { return self.string }

  var string: String {
    switch self {
      case .CommonDeliveryInfoSingle(let p0):
        return L10n.tr("Common.DeliveryInfo.Single", p0)
      case .CommonDeliveryInfoMulti(let p0):
        return L10n.tr("Common.DeliveryInfo.Multi", p0)
      case .CommonError:
        return L10n.tr("Common.Error")
      case .CommonErrorShort:
        return L10n.tr("Common.ErrorShort")
      case .CommonEmptyResultTitle:
        return L10n.tr("Common.EmptyResultTitle")
      case .CommonEmail:
        return L10n.tr("Common.Email")
      case .CommonPassword:
        return L10n.tr("Common.Password")
      case .CommonGreeting(let p0):
        return L10n.tr("Common.Greeting", p0)
      case .CommonUserLoggedOut:
        return L10n.tr("Common.UserLoggedOut")
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
      case .CheckoutDeliveryEditKioskNavigationHeader:
        return L10n.tr("Checkout.Delivery.EditKiosk.NavigationHeader")
      case .CheckoutDeliveryEditKioskSearchInputLabel:
        return L10n.tr("Checkout.Delivery.EditKiosk.SearchInputLabel")
      case .CheckoutDeliveryEditKioskSearchInputPlaceholder:
        return L10n.tr("Checkout.Delivery.EditKiosk.SearchInputPlaceholder")
      case .CheckoutDeliveryEditKioskGeocodingError:
        return L10n.tr("Checkout.Delivery.EditKiosk.GeocodingError")
      case .CheckoutDeliveryEditKioskSave:
        return L10n.tr("Checkout.Delivery.EditKiosk.Save")
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
      case .CheckoutSummaryDiscountCode(let p0):
        return L10n.tr("Checkout.Summary.DiscountCode", p0)
      case .CheckoutSummaryTotalPrice:
        return L10n.tr("Checkout.Summary.TotalPrice")
      case .CheckoutSummaryPaymentMethod:
        return L10n.tr("Checkout.Summary.PaymentMethod")
      case .CheckoutSummaryBuy:
        return L10n.tr("Checkout.Summary.Buy")
      case .CheckoutPaymentResultSuccessHeader:
        return L10n.tr("Checkout.PaymentResult.SuccessHeader")
      case .CheckoutPaymentResultSuccessDescription(let p0, let p1):
        return L10n.tr("Checkout.PaymentResult.SuccessDescription", p0, p1)
      case .CheckoutPaymentResultWebsiteLink:
        return L10n.tr("Checkout.PaymentResult.WebsiteLink")
      case .CheckoutPaymentResultFailureHeader:
        return L10n.tr("Checkout.PaymentResult.FailureHeader")
      case .CheckoutPaymentResultFailureDescription(let p0, let p1):
        return L10n.tr("Checkout.PaymentResult.FailureDescription", p0, p1)
      case .CheckoutPaymentResultGoToMain:
        return L10n.tr("Checkout.PaymentResult.GoToMain")
      case .ProductListBadgeNew:
        return L10n.tr("ProductList.Badge.New")
      case .ProductListBadgeFreeDelivery:
        return L10n.tr("ProductList.Badge.FreeDelivery")
      case .ProductListBadgePremium:
        return L10n.tr("ProductList.Badge.Premium")
      case .ProductListEmptyDescription:
        return L10n.tr("ProductList.Empty.Description")
      case .ProductListEmptySearchDescription:
        return L10n.tr("ProductList.Empty.SearchDescription")
      case .ProductListFilterTitle:
        return L10n.tr("ProductListFilter.Title")
      case .ProductListFilterCancel:
        return L10n.tr("ProductListFilter.Cancel")
      case .ProductListFilterClear:
        return L10n.tr("ProductListFilter.Clear")
      case .ProductListFilterPriceRange(let p0, let p1):
        return L10n.tr("ProductListFilter.PriceRange", p0, p1)
      case .ProductListFilterShowProducts:
        return L10n.tr("ProductListFilter.ShowProducts")
      case .ProductListFilterApply:
        return L10n.tr("ProductListFilter.Apply")
      case .ProductListFilterAllCategories:
        return L10n.tr("ProductListFilter.AllCategories")
      case .ProductListFilterMin:
        return L10n.tr("ProductListFilter.Min")
      case .ProductListFilterMax:
        return L10n.tr("ProductListFilter.Max")
      case .LoginNavigationHeader:
        return L10n.tr("Login.NavigationHeader")
      case .LoginLoginWithFacebook:
        return L10n.tr("Login.LoginWithFacebook")
      case .LoginOr:
        return L10n.tr("Login.Or")
      case .LoginLoginButton:
        return L10n.tr("Login.LoginButton")
      case .LoginPassReminder:
        return L10n.tr("Login.PassReminder")
      case .LoginNewAccount:
        return L10n.tr("Login.NewAccount")
      case .LoginErrorInvalidCredentials:
        return L10n.tr("Login.Error.InvalidCredentials")
      case .LoginErrorUnknown:
        return L10n.tr("Login.Error.Unknown")
      case .RegistrationNavigationHeader:
        return L10n.tr("Registration.NavigationHeader")
      case .RegistrationRegisterWithFacebook:
        return L10n.tr("Registration.RegisterWithFacebook")
      case .RegistrationOr:
        return L10n.tr("Registration.Or")
      case .RegistrationName:
        return L10n.tr("Registration.Name")
      case .RegistrationRepeatPassword:
        return L10n.tr("Registration.RepeatPassword")
      case .RegistrationGender:
        return L10n.tr("Registration.Gender")
      case .RegistrationFemale:
        return L10n.tr("Registration.Female")
      case .RegistrationMale:
        return L10n.tr("Registration.Male")
      case .RegistrationNewsletterCheck:
        return L10n.tr("Registration.NewsletterCheck")
      case .RegistrationRulesCheck:
        return L10n.tr("Registration.RulesCheck")
      case .RegistrationRulesCheckHighlighted:
        return L10n.tr("Registration.RulesCheck.Highlighted")
      case .RegistrationCraeteAccount:
        return L10n.tr("Registration.CraeteAccount")
      case .RegistrationHaveAccount:
        return L10n.tr("Registration.HaveAccount")
      case .RegistrationRequiringRulesMessage:
        return L10n.tr("Registration.RequiringRulesMessage")
      case .RegistrationErrorUnknown:
        return L10n.tr("Registration.Error.Unknown")
      case .ResetPasswordNavigationHeader:
        return L10n.tr("ResetPassword.NavigationHeader")
      case .ResetPasswordEmailDescription:
        return L10n.tr("ResetPassword.EmailDescription")
      case .ResetPasswordReset:
        return L10n.tr("ResetPassword.Reset")
      case .ResetPasswordSuccessDescription:
        return L10n.tr("ResetPassword.SuccessDescription")
      case .ValidatorNotEmpty:
        return L10n.tr("Validator.NotEmpty")
      case .ValidatorPhoneNumber:
        return L10n.tr("Validator.PhoneNumber")
      case .ValidatorEmail:
        return L10n.tr("Validator.Email")
      case .BrandAboutTitle:
        return L10n.tr("Brand.AboutTitle")
      case .ValidatorRepeatPassword:
        return L10n.tr("Validator.RepeatPassword")
      case .SettingsLogin:
        return L10n.tr("Settings.Login")
      case .SettingsLogout:
        return L10n.tr("Settings.Logout")
      case .SettingsCreateAccount:
        return L10n.tr("Settings.CreateAccount")
      case .SettingsDefaultOffer:
        return L10n.tr("Settings.DefaultOffer")
      case .SettingsMale:
        return L10n.tr("Settings.Male")
      case .SettingsFemale:
        return L10n.tr("Settings.Female")
      case .SettingsPermissionForNotifications:
        return L10n.tr("Settings.PermissionForNotifications")
      case .SettingsAskForNotifications:
        return L10n.tr("Settings.AskForNotifications")
      case .SettingsUserData:
        return L10n.tr("Settings.UserData")
      case .SettingsHistory:
        return L10n.tr("Settings.History")
      case .SettingsHowToMeasure:
        return L10n.tr("Settings.HowToMeasure")
      case .SettingsPrivacyPolicy:
        return L10n.tr("Settings.PrivacyPolicy")
      case .SettingsFrequentQuestions:
        return L10n.tr("Settings.FrequentQuestions")
      case .SettingsRules:
        return L10n.tr("Settings.Rules")
      case .SettingsContact:
        return L10n.tr("Settings.Contact")
      case .StartBrowse:
        return L10n.tr("Start.Browse")
      case .StartForHer:
        return L10n.tr("Start.ForHer")
      case .StartForHim:
        return L10n.tr("Start.ForHim")
      case .StartLogin:
        return L10n.tr("Start.Login")
      case .StartRegister:
        return L10n.tr("Start.Register")
      case .OnboardingInfiniteScrollingLabel:
        return L10n.tr("Onboarding.InfiniteScrolling.Label")
      case .OnboardingNotificationsLabel:
        return L10n.tr("Onboarding.Notifications.Label")
      case .OnboardingNotificationsAskMe:
        return L10n.tr("Onboarding.Notifications.AskMe")
      case .OnboardingNotificationsSkip:
        return L10n.tr("Onboarding.Notifications.Skip")
      case .OnboardingDoubleTapLabel:
        return L10n.tr("Onboarding.DoubleTap.Label")
      case .OnboardingProductPagingLabel:
        return L10n.tr("Onboarding.ProductPaging.Label")
      case .SearchPlaceholder:
        return L10n.tr("Search.Placeholder")
      case .SearchAllSearchItems(let p0):
        return L10n.tr("Search.AllSearchItems", p0)
      case .SearchBack:
        return L10n.tr("Search.Back")
      case .WishlistEmptyDescription:
        return L10n.tr("Wishlist.Empty.Description")
      case .WishlistDelete:
        return L10n.tr("Wishlist.Delete")
      case .QuickActionDashboard:
        return L10n.tr("QuickAction.Dashboard")
      case .QuickActionSearch:
        return L10n.tr("QuickAction.Search")
      case .QuickActionBasket:
        return L10n.tr("QuickAction.Basket")
      case .QuickActionWishlist:
        return L10n.tr("QuickAction.Wishlist")
      case .QuickActionSettings:
        return L10n.tr("QuickAction.Settings")
      case .QuickActionProductCountOne:
        return L10n.tr("QuickAction.ProductCount.One")
      case .QuickActionProductCountTwoToFour:
        return L10n.tr("QuickAction.ProductCount.TwoToFour")
      case .QuickActionProductCountFiveAndMore:
        return L10n.tr("QuickAction.ProductCount.FiveAndMore")
      case .AppVersionNotSupportedTitle:
        return L10n.tr("AppVersionNotSupported.Title")
      case .AppVersionNotSupportedDescription:
        return L10n.tr("AppVersionNotSupported.Description")
      case .AppVersionNotSupportedAccept:
        return L10n.tr("AppVersionNotSupported.Accept")
      case .AppVersionNotSupportedDecline:
        return L10n.tr("AppVersionNotSupported.Decline")
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

