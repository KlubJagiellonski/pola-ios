// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation

enum L10n {
  /// Wysyłka w %@ dzień
  case CommonDeliveryInfoSingle(String)
  /// Wysyłka w %@ dni
  case CommonDeliveryInfoMulti(String)
  /// Ups, coś poszło nie tak.\nNie udało się załadować danych.
  case CommonError
  /// Nie udało się załadować danych.
  case CommonErrorShort
  /// UUUPS!
  case CommonEmptyResultTitle
  /// E-mail
  case CommonEmail
  /// Hasło
  case CommonPassword
  /// Cześć %@!
  case CommonGreeting(String)
  /// Niestety użytkownik został wylogowany. Zaloguj się ponownie.
  case CommonUserLoggedOut
  /// Koszyk
  case MainTabBasket
  /// Ulubione
  case MainTabWishlist
  /// KOD RABATOWY
  case BasketDiscountCode
  /// DOSTAWA
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
  /// DOSTAWA
  case BasketDeliveryTitle
  /// Kraj dostawy
  case BasketDeliveryDeliveryCountry
  /// Sposób dostawy
  case BasketDeliveryDeliveryOption
  /// Aby maksymalnie przyspieszyć czas dostawy, w SHOWROOM każdy projektant wysyła produkty oddzielnie - bezpośrednio do Ciebie. Dlatego ponosisz koszty dostawy kilkukrotnie. Możesz wybrać tylko jeden sposób wysyłki dla całego zamówienia.
  case BasketDeliveryInfo
  /// OK
  case BasketDeliveryOk
  /// KRAJ DOSTAWY
  case BasketDeliveryDeliveryCountryTitle
  /// Poniższe produkty zostały usunięte z listy, ponieważ nie są już dostępne:
  case BasketErrorProductsRemoved
  /// Ceny poniższych produktów uległy zmianie:
  case BasketErrorPriceChanged
  /// Cena lub termin wysyłki poniższych produktów uległy zmianie:
  case BasketErrorDeilveryInfoChanged
  /// Liczba poniższych produktów została zmniejszona:
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
  /// brak koloru w wybranym rozmiarze
  case ProductActionColorCellColorUnavailable
  /// WYBIERZ LICZBĘ
  case ProductActionPickAmountTitle
  /// DO KOSZYKA
  case ProductDetailsToBasket
  /// WYPRZEDANY
  case ProductDetailsSoldOut
  /// DOSTĘPNY: %@
  case ProductDetailsAvailableAtDate(String)
  /// Tabela rozmiarów
  case ProductDetailsSizeChart
  /// Pozostałe produkty %@
  case ProductDetailsOtherBrandProducts(String)
  /// Opis produktu
  case ProductDetailsProductDescription
  /// TABELA ROZMIARÓW
  case ProductDetailsSizeChartUppercase
  /// [cm]
  case ProductDetailsSizeChartSize
  /// Kasa
  case CheckoutDeliveryNavigationHeader
  /// ADRES DOSTAWY
  case CheckoutDeliveryCourierHeader
  /// TWÓJ ADRES
  case CheckoutDeliveryRUCHHeader
  /// Imię
  case CheckoutDeliveryAddressFormFirstName
  /// Nazwisko
  case CheckoutDeliveryAddressFormLastName
  /// Ulica, numer domu i mieszkania
  case CheckoutDeliveryAddressFormStreetAndApartmentNumbers
  /// Kod pocztowy
  case CheckoutDeliveryAddressFormPostalCode
  /// Miasto  
  case CheckoutDeliveryAddressFormCity
  /// Kraj
  case CheckoutDeliveryAddressFormCountry
  /// Numer telefonu
  case CheckoutDeliveryAddressFormPhone
  /// EDYTUJ ADRES
  case CheckoutDeliveryAdressEdit
  /// DODAJ INNY ADRES
  case CheckoutDeliveryAdressAdd
  /// ul.
  case CheckoutDeliveryAdressStreet
  /// tel.
  case CheckoutDeliveryAdressPhoneNumber
  /// DOSTAWA
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
  /// Znajdź kiosk w pobliżu:
  case CheckoutDeliveryEditKioskSearchInputLabel
  /// Hoża 51, Warszawa
  case CheckoutDeliveryEditKioskSearchInputPlaceholder
  /// Nie znaleziono adresu
  case CheckoutDeliveryEditKioskGeocodingError
  /// WYBIERZ
  case CheckoutDeliveryEditKioskSave
  /// Podsumowanie
  case CheckoutSummaryNavigationHeader
  /// %@ szt. Rozmiar: %@ Kolor: %@
  case CheckoutSummaryProductDescription(String, String, String)
  /// KOMENTARZ
  case CheckoutSummaryCommentTitle
  /// DODAJ KOMENTARZ
  case CheckoutSummaryAddComment
  /// EDYTUJ
  case CheckoutSummaryEditComment
  /// USUŃ
  case CheckoutSummaryDeleteComment
  /// ZAPISZ
  case CheckoutSummarySaveComment
  /// Tutaj wpisz swoje uwagi do projektanta.
  case CheckoutSummaryCommentPlaceholder
  /// Kod rabatowy %@
  case CheckoutSummaryDiscountCode(String)
  /// Kwota do zapłaty
  case CheckoutSummaryTotalPrice
  /// SPOSÓB PŁATNOŚCI
  case CheckoutSummaryPaymentMethod
  /// ZŁÓŻ ZAMÓWIENIE
  case CheckoutSummaryBuy
  /// GRATULACJE!
  case CheckoutPaymentResultSuccessHeader
  /// Twoje zamówienie zostało przekazane do realizacji pod numerem %@.\n\nO postępach będziemy informować Cię e-mailem, możesz też sprawdzić status zamówienia na %@.\n\nW imieniu swoim i Projektantów dziękujemy za zakupy w aplikacji SHOWROOM!
  case CheckoutPaymentResultSuccessDescription(String, String)
  /// naszej stronie internetowej
  case CheckoutPaymentResultWebsiteLink
  /// UUUPS!
  case CheckoutPaymentResultFailureHeader
  /// Twoje zamówienie nr %@ zostało zapisane, jednak wystąpił błąd z płatnością.\n\nMożesz sprawdzić jej status oraz ponowić na %@.\n\nPrzepraszamy za kłopot.
  case CheckoutPaymentResultFailureDescription(String, String)
  /// STRONA GŁÓWNA
  case CheckoutPaymentResultGoToMain
  /// Zamówienie nie mogło zostać złożone z powodu nieoczekiwanego błędu. Spróbuj ponownie. Przepraszamy za kłopot.
  case CheckoutPaymentOn400Error
  /// NEW
  case ProductListBadgeNew
  /// DARMOWA DOSTAWA
  case ProductListBadgeFreeDelivery
  /// PREMIUM
  case ProductListBadgePremium
  /// Niestety nie znaleźliśmy żadnych produktów spełniających podane kryteria.
  case ProductListEmptyDescription
  /// Niestety nie znaleźliśmy żadnych produktów.\nSpróbuj ponownie z innym słowem kluczowym.
  case ProductListEmptySearchDescription
  /// Filtrowanie
  case ProductListFilterTitle
  /// Anuluj
  case ProductListFilterCancel
  /// Wyczyść
  case ProductListFilterClear
  /// %@ - %@
  case ProductListFilterPriceRange(String, String)
  /// POKAŻ PRODUKTY (%@)
  case ProductListFilterShowProducts(String)
  /// ZASTOSUJ
  case ProductListFilterApply
  /// MIN
  case ProductListFilterMin
  /// MAX
  case ProductListFilterMax
  /// Logowanie
  case LoginNavigationHeader
  /// ZALOGUJ SIĘ FACEBOOKIEM
  case LoginLoginWithFacebook
  /// lub
  case LoginOr
  /// ZALOGUJ SIĘ
  case LoginLoginButton
  /// Nie pamiętam hasła
  case LoginPassReminder
  /// Załóż nowe konto
  case LoginNewAccount
  /// Błędne dane logowania. Spróbuj jeszcze raz.
  case LoginErrorInvalidCredentials
  /// Wystąpił błąd podczas logowania. Spróbuj jeszcze raz.
  case LoginErrorUnknown
  /// Rejestracja
  case RegistrationNavigationHeader
  /// REJESTRACJA FACEBOOKIEM
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
  /// Chcę otrzymywać newsletter
  case RegistrationNewsletterCheck
  /// Akceptuję regulamin SHOWROOM
  case RegistrationRulesCheck
  /// regulamin
  case RegistrationRulesCheckHighlighted
  /// UTWÓRZ KONTO
  case RegistrationCraeteAccount
  /// Masz już konto?
  case RegistrationHaveAccount
  /// Akceptacja regulaminu SHOWROOM jest wymagana.
  case RegistrationRequiringRulesMessage
  /// Wystąpił błąd podczas rejestracji. Spróbuj jeszcze raz.
  case RegistrationErrorUnknown
  /// Zapomniane hasło
  case ResetPasswordNavigationHeader
  /// Podaj adres e-mail powiązany z Twoim kontem, abyśmy mogli przesłać Ci nowe, tymczasowe hasło.
  case ResetPasswordEmailDescription
  /// DALEJ
  case ResetPasswordReset
  /// Nowe hasło tymczasowe zostało wysłane na podany przez Ciebie adres e-mail.
  case ResetPasswordSuccessDescription
  /// To pole nie może być puste
  case ValidatorNotEmpty
  /// Niepoprawny format adresu
  case ValidatorEmail
  /// O projektancie
  case BrandAboutTitle
  /// Wpisane hasła są różne
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
  /// Zgoda na powiadomienia
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
  /// Wyślij uwagi na temat aplikacji
  case SettingsSendReport
  /// Uwagi na temat aplikacji SHOWROOM
  case SettingsSendReportTitle
  /// Brak skonfigurowanego konta e-mail w systemie.
  case SettingsSendReportMailNotConfigured
  /// Platforma
  case SettingsPlatform
  /// Wybór platformy
  case SettingsPlatformSelection
  /// Przeglądaj produkty
  case StartBrowse
  /// DLA NIEJ
  case StartForHer
  /// DLA NIEGO
  case StartForHim
  /// ZALOGUJ SIĘ
  case StartLogin
  /// ZAREJESTRUJ SIĘ
  case StartRegister
  /// DALEJ
  case OnboardingInfiniteScrollingNext
  /// %@\n\nZnajdziesz tu wyselekcjonowane produkty najciekawszych projektantów i marek.
  case OnboardingInfiniteScrollingLabel(String)
  /// Witaj w aplikacji SHOWROOM!
  case OnboardingInfiniteScrollingLabelBoldPart
  /// Czy chcesz w pierwszej kolejności dostawać informacje o specjalnych promocjach, wyprzedażach i nowych kolekcjach?
  case OnboardingNotificationsLabel
  /// JASNE!
  case OnboardingNotificationsAskMe
  /// POMIŃ
  case OnboardingNotificationsSkip
  /// Stuknij dwukrotnie w zdjęcie, aby szybko dodać produkt do ulubionych.
  case OnboardingDoubleTapLabel
  /// Przesuń palcem w górę, aby zobaczyć kolejne zdjęcie przeglądanego produktu.
  case OnboardingPhotosPagingLabel
  /// DALEJ
  case OnboardingPhotosPagingNext
  /// Przesuń palcem w bok,\naby szybko przejść do kolejnego produktu z listy.
  case OnboardingProductPagingLabel
  /// ROZUMIEM
  case OnboardingProductPagingDismiss
  /// szukaj
  case SearchPlaceholder
  /// Wszystko: %@
  case SearchAllSearchItems(String)
  /// Cofnij
  case SearchBack
  /// Dodawaj produkty do ulubionych\ndwukrotnie stukając palcem w ich zdjęcia.
  case WishlistEmptyDescription
  /// Usuń
  case WishlistDelete
  /// Strona główna
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
  /// OK
  case AlertViewAccept
  /// NIE, DZIĘKI
  case AlertViewDecline
  /// INNYM RAZEM
  case AlertViewRemindLater
  /// CZAS NA UPDATE
  case AppVersionNotSupportedTitle
  /// Niestety ta wersja aplikacji nie jest już wspierana. Aby dalej korzystać z SHOWROOM zainstaluj najnowszą wersję z App Store
  case AppVersionNotSupportedDescription
  /// IDŹ DO APP STORE
  case AppVersionNotSupportedAccept
  /// ANULUJ
  case AppVersionNotSupportedDecline
  /// OCEŃ NAS
  case RateAppTitle
  /// Mamy nadzieję, że z przyjemnością korzystasz z naszej aplikacji!\nPodziel się swoją opinią z innymi i oceń SHOWROOM w App Store.
  case RateAppDescriptionAfterTime
  /// Mamy nadzieję, że zakupy w naszej aplikacji były dla Ciebie przyjemnością!\nPodziel się swoją opinią z innymi i oceń SHOWROOM w App Store.
  case RateAppDescriptionAfterBuy
  /// OCEŃ
  case RateAppRate
  /// BĄDŹ NA BIEŻĄCO
  case PushNotificationTitle
  /// Możemy w pierwszej kolejności informować Cię o specjalnych promocjach, wyprzedażach i nowych kolekcjach.
  case PushNotificationDescriptionAfterTime
  /// Możemy informować Cię o obniżkach cen produktów z Twojej listy ulubionych.
  case PushNotificationDescriptionAfterWishlist
  /// Czy chcesz dostawać od nas powiadomienia?
  case PushNotificationQuestion
  /// CHCĘ
  case PushNotificationAllow
  /// AKTUALIZACJA
  case UpdateAppTitle
  /// Niedawno opublikowaliśmy nową wersję aplikacji SHOWROOM, którą wzbogaciliśmy o bardzo ciekawe funkcje. Zachęcamy do jej pobrania z App Store.
  case UpdateAppDescription
  /// IDŹ DO APP STORE
  case UpdateAppUpdate
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
      case .MainTabBasket:
        return L10n.tr("MainTab.Basket")
      case .MainTabWishlist:
        return L10n.tr("MainTab.Wishlist")
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
      case .ProductDetailsSoldOut:
        return L10n.tr("ProductDetails.SoldOut")
      case .ProductDetailsAvailableAtDate(let p0):
        return L10n.tr("ProductDetails.AvailableAtDate", p0)
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
      case .CheckoutPaymentOn400Error:
        return L10n.tr("Checkout.Payment.On400Error")
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
      case .ProductListFilterShowProducts(let p0):
        return L10n.tr("ProductListFilter.ShowProducts", p0)
      case .ProductListFilterApply:
        return L10n.tr("ProductListFilter.Apply")
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
      case .SettingsSendReport:
        return L10n.tr("Settings.SendReport")
      case .SettingsSendReportTitle:
        return L10n.tr("Settings.SendReport.Title")
      case .SettingsSendReportMailNotConfigured:
        return L10n.tr("Settings.SendReport.MailNotConfigured")
      case .SettingsPlatform:
        return L10n.tr("Settings.Platform")
      case .SettingsPlatformSelection:
        return L10n.tr("Settings.PlatformSelection")
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
      case .OnboardingInfiniteScrollingNext:
        return L10n.tr("Onboarding.InfiniteScrolling.Next")
      case .OnboardingInfiniteScrollingLabel(let p0):
        return L10n.tr("Onboarding.InfiniteScrolling.Label", p0)
      case .OnboardingInfiniteScrollingLabelBoldPart:
        return L10n.tr("Onboarding.InfiniteScrolling.LabelBoldPart")
      case .OnboardingNotificationsLabel:
        return L10n.tr("Onboarding.Notifications.Label")
      case .OnboardingNotificationsAskMe:
        return L10n.tr("Onboarding.Notifications.AskMe")
      case .OnboardingNotificationsSkip:
        return L10n.tr("Onboarding.Notifications.Skip")
      case .OnboardingDoubleTapLabel:
        return L10n.tr("Onboarding.DoubleTap.Label")
      case .OnboardingPhotosPagingLabel:
        return L10n.tr("Onboarding.PhotosPaging.Label")
      case .OnboardingPhotosPagingNext:
        return L10n.tr("Onboarding.PhotosPaging.Next")
      case .OnboardingProductPagingLabel:
        return L10n.tr("Onboarding.ProductPaging.Label")
      case .OnboardingProductPagingDismiss:
        return L10n.tr("Onboarding.ProductPaging.Dismiss")
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
      case .AlertViewAccept:
        return L10n.tr("AlertView.Accept")
      case .AlertViewDecline:
        return L10n.tr("AlertView.Decline")
      case .AlertViewRemindLater:
        return L10n.tr("AlertView.RemindLater")
      case .AppVersionNotSupportedTitle:
        return L10n.tr("AppVersionNotSupported.Title")
      case .AppVersionNotSupportedDescription:
        return L10n.tr("AppVersionNotSupported.Description")
      case .AppVersionNotSupportedAccept:
        return L10n.tr("AppVersionNotSupported.Accept")
      case .AppVersionNotSupportedDecline:
        return L10n.tr("AppVersionNotSupported.Decline")
      case .RateAppTitle:
        return L10n.tr("RateApp.Title")
      case .RateAppDescriptionAfterTime:
        return L10n.tr("RateApp.DescriptionAfterTime")
      case .RateAppDescriptionAfterBuy:
        return L10n.tr("RateApp.DescriptionAfterBuy")
      case .RateAppRate:
        return L10n.tr("RateApp.Rate")
      case .PushNotificationTitle:
        return L10n.tr("PushNotification.Title")
      case .PushNotificationDescriptionAfterTime:
        return L10n.tr("PushNotification.DescriptionAfterTime")
      case .PushNotificationDescriptionAfterWishlist:
        return L10n.tr("PushNotification.DescriptionAfterWishlist")
      case .PushNotificationQuestion:
        return L10n.tr("PushNotification.Question")
      case .PushNotificationAllow:
        return L10n.tr("PushNotification.Allow")
      case .UpdateAppTitle:
        return L10n.tr("UpdateApp.Title")
      case .UpdateAppDescription:
        return L10n.tr("UpdateApp.Description")
      case .UpdateAppUpdate:
        return L10n.tr("UpdateApp.Update")
    }
  }

  private static func tr(key: String, _ args: CVarArgType...) -> String {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let languageManager = appDelegate.assembler.resolver.resolve(LanguageManager.self)!
    guard let format = languageManager.translation(forKey: key), let locale = languageManager.language?.locale else {
        return ""
    }
    return String(format: format, locale: locale, arguments: args)
  }
}

func tr(key: L10n) -> String {
  return key.string
}


