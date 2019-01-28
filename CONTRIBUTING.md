### 1. Chciałbyś zgłosić błąd lub zaproponować nową funkcjonalność?

Wpierw [sprawdź](https://github.com/KlubJagiellonski/pola-ios/issues) czy już ktoś wcześniej nie zgłosił podobnego rozwiązania.

Jeżeli nie, to śmiało, [stwórz nowe issue](https://github.com/KlubJagiellonski/pola-ios/issues/new)!

### 2. Fork i tworzenie brancha

Jeżeli jest coś co chciałbyś poprawić/dodać to [zrób forka Poli](https://help.github.com/articles/fork-a-repo)
oraz stwórz branch'a z opisową nazwą.

Do nazewnictwa brancha zastosuj prefixowanie `fix/` lub `feature/` wraz z numerem issues'a i krótkim opisem (najlepiej po angielsku), przykładowo:
```sh
git checkout -b feature/423_added_new_feature
```

### 3. Konfiguracja aplikacji

Wykorzystujemy CocoaPods jako narzędzia do pobierania i konfigurowania zależności. Więcej info znajdzesz na [ich stronie](https://cocoapods.org)

### 4. Stwórz Pull Request'a

Preferujemy metodę rebase & squash przed samym stworzeniem PR. 
Oznacza to, że branch na którym pracujesz powinien mieć jak najmniej commitów (przy małych zmianach tylko jeden) oraz powinien odchodzić od najnowszego commita na masterze.

Gdy już masz to gotowe [stwórz PR](https://help.github.com/articles/creating-a-pull-request)

### 5. Merge PR (tylko opiekunowie)

PR może być tylko zmergowany gdy:

* Został zaakceptowany przez opiekuna.
* Wszystkie komentarze zostały zamknięte/zakończone.
* Branch odchodzi od najnowszego master.
* Zmiany zostały pomyślnie zbudowane i przetestowane przez serwer [CI](https://travis-ci.org/KlubJagiellonski/pola-ios).
