import Foundation
import RxSwift

final class SearchModel {
    private let api: ApiService
    private(set) var searchResult: SearchResult?
    
    init(with api: ApiService) {
        self.api = api
    }
    
    func fetchSearchItems() -> Observable<FetchCacheResult<SearchResult>> {
        //todo retrieve from api
        return Observable.just(mockResult())
            .doOnNext { [weak self] result in self?.searchResult = result }
            .map { FetchCacheResult.Success($0) }
    }
    
    //MARK:- mock
    
    private func mockResult() -> SearchResult {
        let onaBranches = [
            SearchItem(name: "Ubrania", link: "http://www.showroom.pl/tag/ubrania", branches: [
                SearchItem(name: "Sukienki i tuniki", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "T-shirty", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Bluzki", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Bluzy", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Topy", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Koszule", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Kombinezony", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Stroje kąpielowe", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Kurtki i płaszcze", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Golfy", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                ]),
            SearchItem(name: "Akcesoria", link: "http://www.showroom.pl/tag/ubrania", branches: [
                SearchItem(name: "Torby", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Plecaki", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Nerki", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Portfele", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Etui i pokrowce", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Okulary", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Kosmetyczki", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Nakrycia głowy", link: "http://www.showroom.pl/tag/ubrania", branches: nil)
                ]),
            SearchItem(name: "Bielizna", link: "http://www.showroom.pl/tag/ubrania", branches: [
                SearchItem(name: "Torby", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Plecaki", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Nerki", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Portfele", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Etui i pokrowce", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Okulary", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Kosmetyczki", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Nakrycia głowy", link: "http://www.showroom.pl/tag/ubrania", branches: nil)
                ]),
            SearchItem(name: "Biżuteria", link: "http://www.showroom.pl/tag/ubrania", branches: [
                SearchItem(name: "Torby", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Plecaki", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Nerki", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Portfele", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Etui i pokrowce", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Okulary", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Kosmetyczki", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Nakrycia głowy", link: "http://www.showroom.pl/tag/ubrania", branches: nil)
                ]),
            SearchItem(name: "Buty", link: "http://www.showroom.pl/tag/ubrania", branches: [
                SearchItem(name: "Torby", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Plecaki", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Nerki", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Portfele", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Etui i pokrowce", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Okulary", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Kosmetyczki", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Nakrycia głowy", link: "http://www.showroom.pl/tag/ubrania", branches: nil)
                ])
        ]
        
        let onBranches = [
            SearchItem(name: "Ubrania", link: "http://www.showroom.pl/tag/ubrania", branches: [
                SearchItem(name: "Sukienki i tuniki", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "T-shirty", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Bluzki", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Bluzy", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Topy", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Koszule", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Kombinezony", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Stroje kąpielowe", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Kurtki i płaszcze", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Golfy", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                ]),
            SearchItem(name: "Akcesoria", link: "http://www.showroom.pl/tag/ubrania", branches: [
                SearchItem(name: "Torby", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Plecaki", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Nerki", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Portfele", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Etui i pokrowce", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Okulary", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Kosmetyczki", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
                SearchItem(name: "Nakrycia głowy", link: "http://www.showroom.pl/tag/ubrania", branches: nil)
                ])
        ]
        
        let brandBranches = [
            SearchItem(name: "A 1 5 8", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
            SearchItem(name: "Anniss", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
            SearchItem(name: "Anna Ławska", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
            SearchItem(name: "ANNA TRONOWSKA", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
            SearchItem(name: "ANNA GREGORY", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
            SearchItem(name: "Anna Dudzińska", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
            SearchItem(name: "ANKA KRYSTYNIAK", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
            SearchItem(name: "animalbale", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
            SearchItem(name: "Animal Kingdom", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
            SearchItem(name: "Ania Kuczyńska", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
            SearchItem(name: "Anelis Atelier", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
            SearchItem(name: "Anatomy of Change", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
            SearchItem(name: "AMBIGANTE", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
            SearchItem(name: "Altra Dea couture", link: "http://www.showroom.pl/tag/ubrania", branches: nil),
        ]
        
        let rootItems = [
            SearchItem(name: "ONA", link: "test", branches: onaBranches),
            SearchItem(name: "ON", link: "test", branches: onBranches),
            SearchItem(name: "MARKI", link: "test", branches: brandBranches),
        ]
        return SearchResult(rootItems: rootItems)
    }
}