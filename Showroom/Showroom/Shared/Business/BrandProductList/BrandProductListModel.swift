import Foundation
import CocoaMarkdown

final class BrandProductListModel: ProductListModel {
    private let emarsysService: EmarsysService
    private(set) var productBrand: EntryProductBrand
    var brand: Brand?
    
    //todo it should be created in background on rx network chain
    var description: NSAttributedString? {
        guard let brand = brand else { return nil }
        
        return brand.description.markdownToAttributedString(treatBoldAsNormalText: true)
    }
    
    init(with apiService: ApiService, wishlistManager: WishlistManager, emarsysService: EmarsysService, productBrand: EntryProductBrand) {
        self.productBrand = productBrand
        self.emarsysService = emarsysService
        super.init(with: apiService, wishlistManager: wishlistManager)
    
        self.brand = Brand(id: productBrand.id, name: productBrand.name ?? "Test", imageUrl: "https://assets.shwrm.net/images/s/j/sj573dad96220a8.png?1463659926", description: headerDescription, lowResImageUrl: nil)
    }
    
    func update(with productBrand: EntryProductBrand) {
        self.productBrand = productBrand
        self.brand = Brand(id: productBrand.id, name: productBrand.name ?? "Test", imageUrl: "https://assets.shwrm.net/images/s/j/sj573dad96220a8.png?1463659926", description: headerDescription, lowResImageUrl: nil)
        //reset other stuff, e.g. markdown
    }
    
    //todo remove this method and add calling to observer
    func sendToEmarsys() {
        emarsysService.sendBrandViewEvent(withName: productBrand.name!)
    }
}

//TODO:- remove when model will exist

extension BrandProductListModel {
    private var headerDescription: String {
        return "Risk. Made in Warsaw stawia czoła dylematowi *\"jak wyglądać stylowo, a jednocześnie czuć się swobodnie?\".* Projektantki Antonina Samecka i Klara Kowtun nie idą na kompromisy – ubranie ma sprawiać, że nie tylko **fantastycznie wyglądasz,** ale przede wszystkim, że **świetnie się w nim czujesz.** A to wszystko dzięki połączeniu **szykownych, kobiecych ubrań z dresowym materiałem.** RISK made in Warsaw ma jedno zadanie – podkreślać to, co w sylwetce najlepsze. Projektantki z powodzeniem realizują swoją misję - kobiety na nowo pokochały dres, a **[sukienki](/marki/135,risk-made-in-warsaw?tagGroup%5B8%5D%5B%5D=sukienki-tuniki&minPrice=&maxPrice=&offset=0&count=40&property=order&order=ascending)** brandu są dowodem na to, że warto eksperymentować z modą!" +
        "Risk. Made in Warsaw stawia czoła dylematowi *\"jak wyglądać stylowo, a jednocześnie czuć się swobodnie?\".* Projektantki Antonina Samecka i Klara Kowtun nie idą na kompromisy – ubranie ma sprawiać, że nie tylko **fantastycznie wyglądasz,** ale przede wszystkim, że **świetnie się w nim czujesz.** A to wszystko dzięki połączeniu **szykownych, kobiecych ubrań z dresowym materiałem.** RISK made in Warsaw ma jedno zadanie – podkreślać to, co w sylwetce najlepsze. Projektantki z powodzeniem realizują swoją misję - kobiety na nowo pokochały dres, a **[sukienki](/marki/135,risk-made-in-warsaw?tagGroup%5B8%5D%5B%5D=sukienki-tuniki&minPrice=&maxPrice=&offset=0&count=40&property=order&order=ascending)** brandu są dowodem na to, że warto eksperymentować z modą!"
    }
}