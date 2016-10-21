// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation

enum L10n {
  /// OK
  case AlertViewAccept
  /// NIE, DZIĘKI
  case AlertViewDecline
  /// INNYM RAZEM
  case AlertViewRemindLater
  /// IDŹ DO APP STORE
  case AppVersionNotSupportedAccept
  /// ANULUJ
  case AppVersionNotSupportedDecline
  /// Niestety ta wersja aplikacji nie jest już wspierana. Aby dalej korzystać z SHOWROOM zainstaluj najnowszą wersję z App Store
  case AppVersionNotSupportedDescription
  /// CZAS NA UPDATE
  case AppVersionNotSupportedTitle
  /// 0 (usuń z koszyka)
  case BasketAmount0
  /// DO KASY
  case BasketCheckoutButton
  /// Kod %@ został dodany do koszyka.
  case BasketCouponCodeAddedToBasket(String)
  /// Usuń
  case BasketDelete
  /// Kraj dostawy
  case BasketDeliveryDeliveryCountry
  /// KRAJ DOSTAWY
  case BasketDeliveryDeliveryCountryTitle
  /// Sposób dostawy
  case BasketDeliveryDeliveryOption
  /// Aby maksymalnie przyspieszyć czas dostawy, w SHOWROOM każdy projektant wysyła produkty oddzielnie - bezpośrednio do Ciebie. Dlatego ponosisz koszty dostawy kilkukrotnie. Możesz wybrać tylko jeden sposób wysyłki dla całego zamówienia.
  case BasketDeliveryInfo
  /// OK
  case BasketDeliveryOk
  /// DOSTAWA
  case BasketDeliveryTitle
  /// zniżka
  case BasketDiscount
  /// KOD RABATOWY
  case BasketDiscountCode
  /// TWÓJ KOSZYK JEST PUSTY
  case BasketEmpty
  /// Cena lub termin wysyłki poniższych produktów uległy zmianie:
  case BasketErrorDeilveryInfoChanged
  /// Błąd kodu rabatowego:
  case BasketErrorInvalidDiscountCode
  /// Ceny poniższych produktów uległy zmianie:
  case BasketErrorPriceChanged
  /// Liczba poniższych produktów została zmniejszona:
  case BasketErrorProductsAmountChanged
  /// Poniższe produkty zostały usunięte z listy, ponieważ nie są już dostępne:
  case BasketErrorProductsRemoved
  /// szt.
  case BasketPieces
  /// DOSTAWA
  case BasketShipping
  /// ZMIEŃ
  case BasketShippingChange
  /// ZACZNIJ ZAKUPY
  case BasketStartShopping
  /// SUMA
  case BasketTotalPrice
  /// O projektancie
  case BrandAboutTitle
  /// Miasto
  case CheckoutDeliveryAddressFormCity
  /// Kraj
  case CheckoutDeliveryAddressFormCountry
  /// Imię
  case CheckoutDeliveryAddressFormFirstName
  /// Nazwisko
  case CheckoutDeliveryAddressFormLastName
  /// Numer telefonu
  case CheckoutDeliveryAddressFormPhone
  /// Kod pocztowy
  case CheckoutDeliveryAddressFormPostalCode
  /// Ulica, numer domu i mieszkania
  case CheckoutDeliveryAddressFormStreetAndApartmentNumbers
  /// DODAJ INNY ADRES
  case CheckoutDeliveryAdressAdd
  /// EDYTUJ ADRES
  case CheckoutDeliveryAdressEdit
  /// tel.
  case CheckoutDeliveryAdressPhoneNumber
  /// ADRES DOSTAWY
  case CheckoutDeliveryCourierHeader
  /// DOSTAWA
  case CheckoutDeliveryDeliveryHeader
  /// ZMIEŃ KIOSK
  case CheckoutDeliveryDeliveryRUCHChangeKiosk
  /// WYBIERZ KIOSK
  case CheckoutDeliveryDeliveryRUCHPickKiosk
  /// Dodaj inny adres
  case CheckoutDeliveryEditAddressNavigationHeader
  /// ZAPISZ
  case CheckoutDeliveryEditAddressSave
  /// Nie znaleziono adresu
  case CheckoutDeliveryEditKioskGeocodingError
  /// Wybór kiosku
  case CheckoutDeliveryEditKioskNavigationHeader
  /// WYBIERZ
  case CheckoutDeliveryEditKioskSave
  /// Znajdź kiosk w pobliżu:
  case CheckoutDeliveryEditKioskSearchInputLabel
  /// Hoża 51, Warszawa
  case CheckoutDeliveryEditKioskSearchInputPlaceholder
  /// Kasa
  case CheckoutDeliveryNavigationHeader
  /// DALEJ
  case CheckoutDeliveryNext
  /// TWÓJ ADRES
  case CheckoutDeliveryRUCHHeader
  /// Zamówienie nie mogło zostać złożone z powodu nieoczekiwanego błędu. Spróbuj ponownie. Przepraszamy za kłopot.
  case CheckoutPaymentOn400Error
  /// Twoje zamówienie nr %@ zostało zapisane, jednak wystąpił błąd z płatnością.\n\nMożesz sprawdzić jej status oraz ponowić na %@.\n\nPrzepraszamy za kłopot.
  case CheckoutPaymentResultFailureDescription(String, String)
  /// UUUPS!
  case CheckoutPaymentResultFailureHeader
  /// STRONA GŁÓWNA
  case CheckoutPaymentResultGoToMain
  /// Twoje zamówienie zostało przekazane do realizacji pod numerem %@.\n\nO postępach będziemy informować Cię e-mailem, możesz też sprawdzić status zamówienia na %@.\n\nW imieniu swoim i Projektantów dziękujemy za zakupy w aplikacji SHOWROOM!
  case CheckoutPaymentResultSuccessDescription(String, String)
  /// GRATULACJE!
  case CheckoutPaymentResultSuccessHeader
  /// naszej stronie internetowej
  case CheckoutPaymentResultWebsiteLink
  /// DODAJ KOMENTARZ
  case CheckoutSummaryAddComment
  /// ZŁÓŻ ZAMÓWIENIE
  case CheckoutSummaryBuy
  /// Tutaj wpisz swoje uwagi do projektanta.
  case CheckoutSummaryCommentPlaceholder
  /// KOMENTARZ
  case CheckoutSummaryCommentTitle
  /// USUŃ
  case CheckoutSummaryDeleteComment
  /// Kod rabatowy %@
  case CheckoutSummaryDiscountCode(String)
  /// EDYTUJ
  case CheckoutSummaryEditComment
  /// Podsumowanie
  case CheckoutSummaryNavigationHeader
  /// SPOSÓB PŁATNOŚCI
  case CheckoutSummaryPaymentMethod
  /// %@ szt. Rozmiar: %@ Kolor: %@
  case CheckoutSummaryProductDescription(String, String, String)
  /// ZAPISZ
  case CheckoutSummarySaveComment
  /// Kwota do zapłaty
  case CheckoutSummaryTotalPrice
  /// Wysyłka w %@ dni
  case CommonDeliveryInfoMulti(String)
  /// Wysyłka w %@ dzień
  case CommonDeliveryInfoSingle(String)
  /// E-mail
  case CommonEmail
  /// UUUPS!
  case CommonEmptyResultTitle
  /// Ups, coś poszło nie tak.\nNie udało się załadować danych.
  case CommonError
  /// Nie udało się załadować danych.
  case CommonErrorShort
  /// Cześć %@!
  case CommonGreeting(String)
  /// Hasło
  case CommonPassword
  /// Niestety użytkownik został wylogowany. Zaloguj się ponownie.
  case CommonUserLoggedOut
  /// POLECANE
  case DashboardRecommendationTitleFirstPart
  /// dla Ciebie
  case DashboardRecommendationTitleSecondPart
  /// Błędne dane logowania. Spróbuj jeszcze raz.
  case LoginErrorInvalidCredentials
  /// Wystąpił błąd podczas logowania. Spróbuj jeszcze raz.
  case LoginErrorUnknown
  /// ZALOGUJ SIĘ
  case LoginLoginButton
  /// ZALOGUJ SIĘ FACEBOOKIEM
  case LoginLoginWithFacebook
  /// Logowanie
  case LoginNavigationHeader
  /// Załóż nowe konto
  case LoginNewAccount
  /// lub
  case LoginOr
  /// Nie pamiętam hasła
  case LoginPassReminder
  /// Koszyk
  case MainTabBasket
  /// Ulubione
  case MainTabWishlist
  /// zł
  case MoneyZl
  /// Stuknij dwukrotnie w zdjęcie, aby szybko dodać produkt do ulubionych.
  case OnboardingDoubleTapLabel
  /// %@\n\nZnajdziesz tu wyselekcjonowane produkty najciekawszych projektantów i marek.
  case OnboardingInfiniteScrollingLabel(String)
  /// Witaj w aplikacji SHOWROOM!
  case OnboardingInfiniteScrollingLabelBoldPart
  /// DALEJ
  case OnboardingInfiniteScrollingNext
  /// JASNE!
  case OnboardingNotificationsAskMe
  /// Czy chcesz w pierwszej kolejności dostawać informacje o specjalnych promocjach, wyprzedażach i nowych kolekcjach?
  case OnboardingNotificationsLabel
  /// POMIŃ
  case OnboardingNotificationsSkip
  /// Przesuń palcem w górę, aby zobaczyć kolejne zdjęcie przeglądanego produktu.
  case OnboardingPhotosPagingLabel
  /// DALEJ
  case OnboardingPhotosPagingNext
  /// ROZUMIEM
  case OnboardingProductPagingDismiss
  /// Przesuń palcem w bok, aby szybko przejść do kolejnego produktu z listy.
  case OnboardingProductPagingLabel
  /// brak koloru w wybranym rozmiarze
  case ProductActionColorCellColorUnavailable
  /// WYBIERZ LICZBĘ
  case ProductActionPickAmountTitle
  /// WYBIERZ KOLOR
  case ProductActionPickColorTitle
  /// WYBIERZ ROZMIAR
  case ProductActionPickSizeTitleFirstPart
  /// TABELA ROZMIARÓW
  case ProductActionPickSizeTitleSecondPart
  /// brak rozmiaru w wybranym kolorze
  case ProductActionSizeCellSizeUnavailable
  /// DOSTĘPNY: %@
  case ProductDetailsAvailableAtDate(String)
  /// Pozostałe produkty %@
  case ProductDetailsOtherBrandProducts(String)
  /// Opis produktu
  case ProductDetailsProductDescription
  /// Tabela rozmiarów
  case ProductDetailsSizeChart
  /// [cm]
  case ProductDetailsSizeChartSize
  /// TABELA ROZMIARÓW
  case ProductDetailsSizeChartUppercase
  /// WYPRZEDANY
  case ProductDetailsSoldOut
  /// DO KOSZYKA
  case ProductDetailsToBasket
  /// DARMOWA DOSTAWA
  case ProductListBadgeFreeDelivery
  /// NEW
  case ProductListBadgeNew
  /// PREMIUM
  case ProductListBadgePremium
  /// Niestety nie znaleźliśmy żadnych produktów spełniających podane kryteria.
  case ProductListEmptyDescription
  /// Niestety nie znaleźliśmy żadnych produktów.\nSpróbuj ponownie z innym słowem kluczowym.
  case ProductListEmptySearchDescription
  /// ZASTOSUJ
  case ProductListFilterApply
  /// Anuluj
  case ProductListFilterCancel
  /// Wyczyść
  case ProductListFilterClear
  /// MAX
  case ProductListFilterMax
  /// MIN
  case ProductListFilterMin
  /// %@ - %@
  case ProductListFilterPriceRange(String, String)
  /// POKAŻ PRODUKTY (%@)
  case ProductListFilterShowProducts(String)
  /// Filtrowanie
  case ProductListFilterTitle
  /// POWTÓRZ
  case PromoVideoSummaryRepeat
  /// CHCĘ
  case PushNotificationAllow
  /// Możemy w pierwszej kolejności informować Cię o specjalnych promocjach, wyprzedażach i nowych kolekcjach.
  case PushNotificationDescriptionAfterTime
  /// Możemy informować Cię o obniżkach cen produktów z Twojej listy ulubionych.
  case PushNotificationDescriptionAfterWishlist
  /// Czy chcesz dostawać od nas powiadomienia?
  case PushNotificationQuestion
  /// BĄDŹ NA BIEŻĄCO
  case PushNotificationTitle
  /// Koszyk
  case QuickActionBasket
  /// Strona główna
  case QuickActionDashboard
  /// produktów
  case QuickActionProductCountFiveAndMore
  /// produkt
  case QuickActionProductCountOne
  /// produkty
  case QuickActionProductCountTwoToFour
  /// Szukaj
  case QuickActionSearch
  /// Profil
  case QuickActionSettings
  /// Ulubione
  case QuickActionWishlist
  /// Mamy nadzieję, że zakupy w naszej aplikacji były dla Ciebie przyjemnością!\nPodziel się swoją opinią z innymi i oceń SHOWROOM w App Store.
  case RateAppDescriptionAfterBuy
  /// Mamy nadzieję, że z przyjemnością korzystasz z naszej aplikacji!\nPodziel się swoją opinią z innymi i oceń SHOWROOM w App Store.
  case RateAppDescriptionAfterTime
  /// OCEŃ
  case RateAppRate
  /// OCEŃ NAS
  case RateAppTitle
  /// UTWÓRZ KONTO
  case RegistrationCraeteAccount
  /// Wystąpił błąd podczas rejestracji. Spróbuj jeszcze raz.
  case RegistrationErrorUnknown
  /// Kobieta
  case RegistrationFemale
  /// Płeć
  case RegistrationGender
  /// Masz już konto?
  case RegistrationHaveAccount
  /// Mężczyzna
  case RegistrationMale
  /// Imię
  case RegistrationName
  /// Rejestracja
  case RegistrationNavigationHeader
  /// Chcę otrzymywać newsletter
  case RegistrationNewsletterCheck
  /// lub
  case RegistrationOr
  /// REJESTRACJA FACEBOOKIEM
  case RegistrationRegisterWithFacebook
  /// Powtórz hasło
  case RegistrationRepeatPassword
  /// Akceptacja regulaminu SHOWROOM jest wymagana.
  case RegistrationRequiringRulesMessage
  /// Akceptuję regulamin SHOWROOM
  case RegistrationRulesCheck
  /// regulamin
  case RegistrationRulesCheckHighlighted
  /// Podaj adres e-mail powiązany z Twoim kontem, abyśmy mogli przesłać Ci nowe, tymczasowe hasło.
  case ResetPasswordEmailDescription
  /// Zapomniane hasło
  case ResetPasswordNavigationHeader
  /// DALEJ
  case ResetPasswordReset
  /// Nowe hasło tymczasowe zostało wysłane na podany przez Ciebie adres e-mail.
  case ResetPasswordSuccessDescription
  /// Wszystko: %@
  case SearchAllSearchItems(String)
  /// Cofnij
  case SearchBack
  /// szukaj
  case SearchPlaceholder
  /// Spytaj
  case SettingsAskForNotifications
  /// Kontakt
  case SettingsContact
  /// Załóż konto
  case SettingsCreateAccount
  /// Domyślna oferta
  case SettingsDefaultOffer
  /// ONA
  case SettingsFemale
  /// Częste pytania
  case SettingsFrequentQuestions
  /// Historia zamówień
  case SettingsHistory
  /// Jak się mierzyć?
  case SettingsHowToMeasure
  /// Zaloguj się
  case SettingsLogin
  /// Wyloguj
  case SettingsLogout
  /// ON
  case SettingsMale
  /// Zgoda na powiadomienia
  case SettingsPermissionForNotifications
  /// Platforma
  case SettingsPlatform
  /// Wybór platformy
  case SettingsPlatformSelection
  /// Polityka prywatności
  case SettingsPrivacyPolicy
  /// Regulamin
  case SettingsRules
  /// Wyślij uwagi na temat aplikacji
  case SettingsSendReport
  /// Brak skonfigurowanego konta e-mail w systemie.
  case SettingsSendReportMailNotConfigured
  /// Uwagi na temat aplikacji SHOWROOM
  case SettingsSendReportTitle
  /// Twoje dane
  case SettingsUserData
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
  /// Niedawno opublikowaliśmy nową wersję aplikacji SHOWROOM, którą wzbogaciliśmy o bardzo ciekawe funkcje. Zachęcamy do jej pobrania z App Store.
  case UpdateAppDescription
  /// AKTUALIZACJA
  case UpdateAppTitle
  /// IDŹ DO APP STORE
  case UpdateAppUpdate
  /// Niepoprawny format adresu
  case ValidatorEmail
  /// To pole nie może być puste
  case ValidatorNotEmpty
  /// Wpisane hasła są różne
  case ValidatorRepeatPassword
  /// Usuń
  case WishlistDelete
  /// Dodawaj produkty do ulubionych\ndwukrotnie stukając palcem w ich zdjęcia.
  case WishlistEmptyDescription
}

extension L10n: CustomStringConvertible {
  var description: String { return self.string }

  var string: String {
    switch self {
      case .AlertViewAccept:
        return L10n.tr("AlertView.Accept")
      case .AlertViewDecline:
        return L10n.tr("AlertView.Decline")
      case .AlertViewRemindLater:
        return L10n.tr("AlertView.RemindLater")
      case .AppVersionNotSupportedAccept:
        return L10n.tr("AppVersionNotSupported.Accept")
      case .AppVersionNotSupportedDecline:
        return L10n.tr("AppVersionNotSupported.Decline")
      case .AppVersionNotSupportedDescription:
        return L10n.tr("AppVersionNotSupported.Description")
      case .AppVersionNotSupportedTitle:
        return L10n.tr("AppVersionNotSupported.Title")
      case .BasketAmount0:
        return L10n.tr("Basket.Amount0")
      case .BasketCheckoutButton:
        return L10n.tr("Basket.CheckoutButton")
      case .BasketCouponCodeAddedToBasket(let p0):
        return L10n.tr("Basket.CouponCodeAddedToBasket", p0)
      case .BasketDelete:
        return L10n.tr("Basket.Delete")
      case .BasketDeliveryDeliveryCountry:
        return L10n.tr("Basket.Delivery.DeliveryCountry")
      case .BasketDeliveryDeliveryCountryTitle:
        return L10n.tr("Basket.Delivery.DeliveryCountryTitle")
      case .BasketDeliveryDeliveryOption:
        return L10n.tr("Basket.Delivery.DeliveryOption")
      case .BasketDeliveryInfo:
        return L10n.tr("Basket.Delivery.Info")
      case .BasketDeliveryOk:
        return L10n.tr("Basket.Delivery.Ok")
      case .BasketDeliveryTitle:
        return L10n.tr("Basket.Delivery.Title")
      case .BasketDiscount:
        return L10n.tr("Basket.Discount")
      case .BasketDiscountCode:
        return L10n.tr("Basket.DiscountCode")
      case .BasketEmpty:
        return L10n.tr("Basket.Empty")
      case .BasketErrorDeilveryInfoChanged:
        return L10n.tr("Basket.Error.DeilveryInfoChanged")
      case .BasketErrorInvalidDiscountCode:
        return L10n.tr("Basket.Error.InvalidDiscountCode")
      case .BasketErrorPriceChanged:
        return L10n.tr("Basket.Error.PriceChanged")
      case .BasketErrorProductsAmountChanged:
        return L10n.tr("Basket.Error.ProductsAmountChanged")
      case .BasketErrorProductsRemoved:
        return L10n.tr("Basket.Error.ProductsRemoved")
      case .BasketPieces:
        return L10n.tr("Basket.Pieces")
      case .BasketShipping:
        return L10n.tr("Basket.Shipping")
      case .BasketShippingChange:
        return L10n.tr("Basket.ShippingChange")
      case .BasketStartShopping:
        return L10n.tr("Basket.StartShopping")
      case .BasketTotalPrice:
        return L10n.tr("Basket.TotalPrice")
      case .BrandAboutTitle:
        return L10n.tr("Brand.AboutTitle")
      case .CheckoutDeliveryAddressFormCity:
        return L10n.tr("Checkout.Delivery.AddressForm.City")
      case .CheckoutDeliveryAddressFormCountry:
        return L10n.tr("Checkout.Delivery.AddressForm.Country")
      case .CheckoutDeliveryAddressFormFirstName:
        return L10n.tr("Checkout.Delivery.AddressForm.FirstName")
      case .CheckoutDeliveryAddressFormLastName:
        return L10n.tr("Checkout.Delivery.AddressForm.LastName")
      case .CheckoutDeliveryAddressFormPhone:
        return L10n.tr("Checkout.Delivery.AddressForm.Phone")
      case .CheckoutDeliveryAddressFormPostalCode:
        return L10n.tr("Checkout.Delivery.AddressForm.PostalCode")
      case .CheckoutDeliveryAddressFormStreetAndApartmentNumbers:
        return L10n.tr("Checkout.Delivery.AddressForm.StreetAndApartmentNumbers")
      case .CheckoutDeliveryAdressAdd:
        return L10n.tr("Checkout.Delivery.Adress.Add")
      case .CheckoutDeliveryAdressEdit:
        return L10n.tr("Checkout.Delivery.Adress.Edit")
      case .CheckoutDeliveryAdressPhoneNumber:
        return L10n.tr("Checkout.Delivery.Adress.PhoneNumber")
      case .CheckoutDeliveryCourierHeader:
        return L10n.tr("Checkout.Delivery.Courier.Header")
      case .CheckoutDeliveryDeliveryHeader:
        return L10n.tr("Checkout.Delivery.Delivery.Header")
      case .CheckoutDeliveryDeliveryRUCHChangeKiosk:
        return L10n.tr("Checkout.Delivery.Delivery.RUCH.ChangeKiosk")
      case .CheckoutDeliveryDeliveryRUCHPickKiosk:
        return L10n.tr("Checkout.Delivery.Delivery.RUCH.PickKiosk")
      case .CheckoutDeliveryEditAddressNavigationHeader:
        return L10n.tr("Checkout.Delivery.EditAddress.NavigationHeader")
      case .CheckoutDeliveryEditAddressSave:
        return L10n.tr("Checkout.Delivery.EditAddress.Save")
      case .CheckoutDeliveryEditKioskGeocodingError:
        return L10n.tr("Checkout.Delivery.EditKiosk.GeocodingError")
      case .CheckoutDeliveryEditKioskNavigationHeader:
        return L10n.tr("Checkout.Delivery.EditKiosk.NavigationHeader")
      case .CheckoutDeliveryEditKioskSave:
        return L10n.tr("Checkout.Delivery.EditKiosk.Save")
      case .CheckoutDeliveryEditKioskSearchInputLabel:
        return L10n.tr("Checkout.Delivery.EditKiosk.SearchInputLabel")
      case .CheckoutDeliveryEditKioskSearchInputPlaceholder:
        return L10n.tr("Checkout.Delivery.EditKiosk.SearchInputPlaceholder")
      case .CheckoutDeliveryNavigationHeader:
        return L10n.tr("Checkout.Delivery.NavigationHeader")
      case .CheckoutDeliveryNext:
        return L10n.tr("Checkout.Delivery.Next")
      case .CheckoutDeliveryRUCHHeader:
        return L10n.tr("Checkout.Delivery.RUCH.Header")
      case .CheckoutPaymentOn400Error:
        return L10n.tr("Checkout.Payment.On400Error")
      case .CheckoutPaymentResultFailureDescription(let p0, let p1):
        return L10n.tr("Checkout.PaymentResult.FailureDescription", p0, p1)
      case .CheckoutPaymentResultFailureHeader:
        return L10n.tr("Checkout.PaymentResult.FailureHeader")
      case .CheckoutPaymentResultGoToMain:
        return L10n.tr("Checkout.PaymentResult.GoToMain")
      case .CheckoutPaymentResultSuccessDescription(let p0, let p1):
        return L10n.tr("Checkout.PaymentResult.SuccessDescription", p0, p1)
      case .CheckoutPaymentResultSuccessHeader:
        return L10n.tr("Checkout.PaymentResult.SuccessHeader")
      case .CheckoutPaymentResultWebsiteLink:
        return L10n.tr("Checkout.PaymentResult.WebsiteLink")
      case .CheckoutSummaryAddComment:
        return L10n.tr("Checkout.Summary.AddComment")
      case .CheckoutSummaryBuy:
        return L10n.tr("Checkout.Summary.Buy")
      case .CheckoutSummaryCommentPlaceholder:
        return L10n.tr("Checkout.Summary.CommentPlaceholder")
      case .CheckoutSummaryCommentTitle:
        return L10n.tr("Checkout.Summary.CommentTitle")
      case .CheckoutSummaryDeleteComment:
        return L10n.tr("Checkout.Summary.DeleteComment")
      case .CheckoutSummaryDiscountCode(let p0):
        return L10n.tr("Checkout.Summary.DiscountCode", p0)
      case .CheckoutSummaryEditComment:
        return L10n.tr("Checkout.Summary.EditComment")
      case .CheckoutSummaryNavigationHeader:
        return L10n.tr("Checkout.Summary.NavigationHeader")
      case .CheckoutSummaryPaymentMethod:
        return L10n.tr("Checkout.Summary.PaymentMethod")
      case .CheckoutSummaryProductDescription(let p0, let p1, let p2):
        return L10n.tr("Checkout.Summary.ProductDescription", p0, p1, p2)
      case .CheckoutSummarySaveComment:
        return L10n.tr("Checkout.Summary.SaveComment")
      case .CheckoutSummaryTotalPrice:
        return L10n.tr("Checkout.Summary.TotalPrice")
      case .CommonDeliveryInfoMulti(let p0):
        return L10n.tr("Common.DeliveryInfo.Multi", p0)
      case .CommonDeliveryInfoSingle(let p0):
        return L10n.tr("Common.DeliveryInfo.Single", p0)
      case .CommonEmail:
        return L10n.tr("Common.Email")
      case .CommonEmptyResultTitle:
        return L10n.tr("Common.EmptyResultTitle")
      case .CommonError:
        return L10n.tr("Common.Error")
      case .CommonErrorShort:
        return L10n.tr("Common.ErrorShort")
      case .CommonGreeting(let p0):
        return L10n.tr("Common.Greeting", p0)
      case .CommonPassword:
        return L10n.tr("Common.Password")
      case .CommonUserLoggedOut:
        return L10n.tr("Common.UserLoggedOut")
      case .DashboardRecommendationTitleFirstPart:
        return L10n.tr("Dashboard.RecommendationTitle.FirstPart")
      case .DashboardRecommendationTitleSecondPart:
        return L10n.tr("Dashboard.RecommendationTitle.SecondPart")
      case .LoginErrorInvalidCredentials:
        return L10n.tr("Login.Error.InvalidCredentials")
      case .LoginErrorUnknown:
        return L10n.tr("Login.Error.Unknown")
      case .LoginLoginButton:
        return L10n.tr("Login.LoginButton")
      case .LoginLoginWithFacebook:
        return L10n.tr("Login.LoginWithFacebook")
      case .LoginNavigationHeader:
        return L10n.tr("Login.NavigationHeader")
      case .LoginNewAccount:
        return L10n.tr("Login.NewAccount")
      case .LoginOr:
        return L10n.tr("Login.Or")
      case .LoginPassReminder:
        return L10n.tr("Login.PassReminder")
      case .MainTabBasket:
        return L10n.tr("MainTab.Basket")
      case .MainTabWishlist:
        return L10n.tr("MainTab.Wishlist")
      case .MoneyZl:
        return L10n.tr("Money.Zl")
      case .OnboardingDoubleTapLabel:
        return L10n.tr("Onboarding.DoubleTap.Label")
      case .OnboardingInfiniteScrollingLabel(let p0):
        return L10n.tr("Onboarding.InfiniteScrolling.Label", p0)
      case .OnboardingInfiniteScrollingLabelBoldPart:
        return L10n.tr("Onboarding.InfiniteScrolling.LabelBoldPart")
      case .OnboardingInfiniteScrollingNext:
        return L10n.tr("Onboarding.InfiniteScrolling.Next")
      case .OnboardingNotificationsAskMe:
        return L10n.tr("Onboarding.Notifications.AskMe")
      case .OnboardingNotificationsLabel:
        return L10n.tr("Onboarding.Notifications.Label")
      case .OnboardingNotificationsSkip:
        return L10n.tr("Onboarding.Notifications.Skip")
      case .OnboardingPhotosPagingLabel:
        return L10n.tr("Onboarding.PhotosPaging.Label")
      case .OnboardingPhotosPagingNext:
        return L10n.tr("Onboarding.PhotosPaging.Next")
      case .OnboardingProductPagingDismiss:
        return L10n.tr("Onboarding.ProductPaging.Dismiss")
      case .OnboardingProductPagingLabel:
        return L10n.tr("Onboarding.ProductPaging.Label")
      case .ProductActionColorCellColorUnavailable:
        return L10n.tr("ProductAction.ColorCell.ColorUnavailable")
      case .ProductActionPickAmountTitle:
        return L10n.tr("ProductAction.PickAmountTitle")
      case .ProductActionPickColorTitle:
        return L10n.tr("ProductAction.PickColorTitle")
      case .ProductActionPickSizeTitleFirstPart:
        return L10n.tr("ProductAction.PickSizeTitle.FirstPart")
      case .ProductActionPickSizeTitleSecondPart:
        return L10n.tr("ProductAction.PickSizeTitle.SecondPart")
      case .ProductActionSizeCellSizeUnavailable:
        return L10n.tr("ProductAction.SizeCell.SizeUnavailable")
      case .ProductDetailsAvailableAtDate(let p0):
        return L10n.tr("ProductDetails.AvailableAtDate", p0)
      case .ProductDetailsOtherBrandProducts(let p0):
        return L10n.tr("ProductDetails.OtherBrandProducts", p0)
      case .ProductDetailsProductDescription:
        return L10n.tr("ProductDetails.ProductDescription")
      case .ProductDetailsSizeChart:
        return L10n.tr("ProductDetails.SizeChart")
      case .ProductDetailsSizeChartSize:
        return L10n.tr("ProductDetails.SizeChart.Size")
      case .ProductDetailsSizeChartUppercase:
        return L10n.tr("ProductDetails.SizeChart.Uppercase")
      case .ProductDetailsSoldOut:
        return L10n.tr("ProductDetails.SoldOut")
      case .ProductDetailsToBasket:
        return L10n.tr("ProductDetails.ToBasket")
      case .ProductListBadgeFreeDelivery:
        return L10n.tr("ProductList.Badge.FreeDelivery")
      case .ProductListBadgeNew:
        return L10n.tr("ProductList.Badge.New")
      case .ProductListBadgePremium:
        return L10n.tr("ProductList.Badge.Premium")
      case .ProductListEmptyDescription:
        return L10n.tr("ProductList.Empty.Description")
      case .ProductListEmptySearchDescription:
        return L10n.tr("ProductList.Empty.SearchDescription")
      case .ProductListFilterApply:
        return L10n.tr("ProductListFilter.Apply")
      case .ProductListFilterCancel:
        return L10n.tr("ProductListFilter.Cancel")
      case .ProductListFilterClear:
        return L10n.tr("ProductListFilter.Clear")
      case .ProductListFilterMax:
        return L10n.tr("ProductListFilter.Max")
      case .ProductListFilterMin:
        return L10n.tr("ProductListFilter.Min")
      case .ProductListFilterPriceRange(let p0, let p1):
        return L10n.tr("ProductListFilter.PriceRange", p0, p1)
      case .ProductListFilterShowProducts(let p0):
        return L10n.tr("ProductListFilter.ShowProducts", p0)
      case .ProductListFilterTitle:
        return L10n.tr("ProductListFilter.Title")
      case .PromoVideoSummaryRepeat:
        return L10n.tr("PromoVideo.Summary.Repeat")
      case .PushNotificationAllow:
        return L10n.tr("PushNotification.Allow")
      case .PushNotificationDescriptionAfterTime:
        return L10n.tr("PushNotification.DescriptionAfterTime")
      case .PushNotificationDescriptionAfterWishlist:
        return L10n.tr("PushNotification.DescriptionAfterWishlist")
      case .PushNotificationQuestion:
        return L10n.tr("PushNotification.Question")
      case .PushNotificationTitle:
        return L10n.tr("PushNotification.Title")
      case .QuickActionBasket:
        return L10n.tr("QuickAction.Basket")
      case .QuickActionDashboard:
        return L10n.tr("QuickAction.Dashboard")
      case .QuickActionProductCountFiveAndMore:
        return L10n.tr("QuickAction.ProductCount.FiveAndMore")
      case .QuickActionProductCountOne:
        return L10n.tr("QuickAction.ProductCount.One")
      case .QuickActionProductCountTwoToFour:
        return L10n.tr("QuickAction.ProductCount.TwoToFour")
      case .QuickActionSearch:
        return L10n.tr("QuickAction.Search")
      case .QuickActionSettings:
        return L10n.tr("QuickAction.Settings")
      case .QuickActionWishlist:
        return L10n.tr("QuickAction.Wishlist")
      case .RateAppDescriptionAfterBuy:
        return L10n.tr("RateApp.DescriptionAfterBuy")
      case .RateAppDescriptionAfterTime:
        return L10n.tr("RateApp.DescriptionAfterTime")
      case .RateAppRate:
        return L10n.tr("RateApp.Rate")
      case .RateAppTitle:
        return L10n.tr("RateApp.Title")
      case .RegistrationCraeteAccount:
        return L10n.tr("Registration.CraeteAccount")
      case .RegistrationErrorUnknown:
        return L10n.tr("Registration.Error.Unknown")
      case .RegistrationFemale:
        return L10n.tr("Registration.Female")
      case .RegistrationGender:
        return L10n.tr("Registration.Gender")
      case .RegistrationHaveAccount:
        return L10n.tr("Registration.HaveAccount")
      case .RegistrationMale:
        return L10n.tr("Registration.Male")
      case .RegistrationName:
        return L10n.tr("Registration.Name")
      case .RegistrationNavigationHeader:
        return L10n.tr("Registration.NavigationHeader")
      case .RegistrationNewsletterCheck:
        return L10n.tr("Registration.NewsletterCheck")
      case .RegistrationOr:
        return L10n.tr("Registration.Or")
      case .RegistrationRegisterWithFacebook:
        return L10n.tr("Registration.RegisterWithFacebook")
      case .RegistrationRepeatPassword:
        return L10n.tr("Registration.RepeatPassword")
      case .RegistrationRequiringRulesMessage:
        return L10n.tr("Registration.RequiringRulesMessage")
      case .RegistrationRulesCheck:
        return L10n.tr("Registration.RulesCheck")
      case .RegistrationRulesCheckHighlighted:
        return L10n.tr("Registration.RulesCheck.Highlighted")
      case .ResetPasswordEmailDescription:
        return L10n.tr("ResetPassword.EmailDescription")
      case .ResetPasswordNavigationHeader:
        return L10n.tr("ResetPassword.NavigationHeader")
      case .ResetPasswordReset:
        return L10n.tr("ResetPassword.Reset")
      case .ResetPasswordSuccessDescription:
        return L10n.tr("ResetPassword.SuccessDescription")
      case .SearchAllSearchItems(let p0):
        return L10n.tr("Search.AllSearchItems", p0)
      case .SearchBack:
        return L10n.tr("Search.Back")
      case .SearchPlaceholder:
        return L10n.tr("Search.Placeholder")
      case .SettingsAskForNotifications:
        return L10n.tr("Settings.AskForNotifications")
      case .SettingsContact:
        return L10n.tr("Settings.Contact")
      case .SettingsCreateAccount:
        return L10n.tr("Settings.CreateAccount")
      case .SettingsDefaultOffer:
        return L10n.tr("Settings.DefaultOffer")
      case .SettingsFemale:
        return L10n.tr("Settings.Female")
      case .SettingsFrequentQuestions:
        return L10n.tr("Settings.FrequentQuestions")
      case .SettingsHistory:
        return L10n.tr("Settings.History")
      case .SettingsHowToMeasure:
        return L10n.tr("Settings.HowToMeasure")
      case .SettingsLogin:
        return L10n.tr("Settings.Login")
      case .SettingsLogout:
        return L10n.tr("Settings.Logout")
      case .SettingsMale:
        return L10n.tr("Settings.Male")
      case .SettingsPermissionForNotifications:
        return L10n.tr("Settings.PermissionForNotifications")
      case .SettingsPlatform:
        return L10n.tr("Settings.Platform")
      case .SettingsPlatformSelection:
        return L10n.tr("Settings.PlatformSelection")
      case .SettingsPrivacyPolicy:
        return L10n.tr("Settings.PrivacyPolicy")
      case .SettingsRules:
        return L10n.tr("Settings.Rules")
      case .SettingsSendReport:
        return L10n.tr("Settings.SendReport")
      case .SettingsSendReportMailNotConfigured:
        return L10n.tr("Settings.SendReport.MailNotConfigured")
      case .SettingsSendReportTitle:
        return L10n.tr("Settings.SendReport.Title")
      case .SettingsUserData:
        return L10n.tr("Settings.UserData")
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
      case .UpdateAppDescription:
        return L10n.tr("UpdateApp.Description")
      case .UpdateAppTitle:
        return L10n.tr("UpdateApp.Title")
      case .UpdateAppUpdate:
        return L10n.tr("UpdateApp.Update")
      case .ValidatorEmail:
        return L10n.tr("Validator.Email")
      case .ValidatorNotEmpty:
        return L10n.tr("Validator.NotEmpty")
      case .ValidatorRepeatPassword:
        return L10n.tr("Validator.RepeatPassword")
      case .WishlistDelete:
        return L10n.tr("Wishlist.Delete")
      case .WishlistEmptyDescription:
        return L10n.tr("Wishlist.Empty.Description")
    }
  }

  private static func tr(key: String, _ args: CVarArgType...) -> String {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let platformManager = appDelegate.assembler.resolver.resolve(PlatformManager.self)!
    guard let format = platformManager.translation(forKey: key), let locale = platformManager.platform?.locale else {
        return ""
    }
    return String(format: format, locale: locale, arguments: args)
  }
}

func tr(key: L10n) -> String {
  return key.string
}


