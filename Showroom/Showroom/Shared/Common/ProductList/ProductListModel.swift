import Foundation
import RxSwift

struct ProductListResult: Equatable {
    let products: [Product]
    let isLastPage: Bool
}

func ==(lhs: ProductListResult, rhs: ProductListResult) -> Bool {
    return true //todo change
}

class ProductListModel {
    func fetchFirstPage() -> Observable<FetchResult<ProductListResult>> {
        let products: [Product] = [
            Product(id: 1, brand: "ECHO", name: "Sukienka Rosie z czerwonym kapturem", basePrice: Money(amt: 10119.00), price: Money(amt: 10089.00), imageUrl: "https://static.shwrm.net/images/7/l/7l5773d518c5c92_500x643.jpg", lowResImageUrl: nil),
            Product(id: 2, brand: "Tomaotomo by Tomasz Olejniczak test", name: "Sukienka Rosie z czerwonym kapturem", basePrice: Money(amt: 479.00), price: Money(amt: 218.00), imageUrl: "https://static.shwrm.net/images/p/5/p55772f826bed13_500x643.jpg", lowResImageUrl: nil),
            Product(id: 3, brand: "Justyna Chrabelska", name: "Sukienka jedwabna z falbanką", basePrice: Money(amt: 369.00), price: Money(amt: 369.00), imageUrl: "https://static.shwrm.net/images/f/z/fz57729609b985b_500x643.jpg", lowResImageUrl: nil),
            Product(id: 4, brand: "byCabo", name: "Sukienka z dzianiny", basePrice: Money(amt: 289.00), price: Money(amt: 289.00), imageUrl: "https://static.shwrm.net/images/e/v/ev5512ae375543e_500x643.jpg", lowResImageUrl: nil),
            Product(id: 1, brand: "ECHO", name: "Sukienka Rosie z czerwonym kapturem", basePrice: Money(amt: 10119.00), price: Money(amt: 10089.00), imageUrl: "https://static.shwrm.net/images/7/l/7l5773d518c5c92_500x643.jpg", lowResImageUrl: nil),
            Product(id: 2, brand: "Tomaotomo by Tomasz Olejniczak test", name: "Sukienka Rosie z czerwonym kapturem", basePrice: Money(amt: 479.00), price: Money(amt: 218.00), imageUrl: "https://static.shwrm.net/images/p/5/p55772f826bed13_500x643.jpg", lowResImageUrl: nil),
            Product(id: 3, brand: "Justyna Chrabelska", name: "Sukienka jedwabna z falbanką", basePrice: Money(amt: 369.00), price: Money(amt: 369.00), imageUrl: "https://static.shwrm.net/images/f/z/fz57729609b985b_500x643.jpg", lowResImageUrl: nil),
            Product(id: 4, brand: "byCabo", name: "Sukienka z dzianiny", basePrice: Money(amt: 289.00), price: Money(amt: 289.00), imageUrl: "https://static.shwrm.net/images/e/v/ev5512ae375543e_500x643.jpg", lowResImageUrl: nil),
            Product(id: 1, brand: "ECHO", name: "Sukienka Rosie z czerwonym kapturem", basePrice: Money(amt: 10119.00), price: Money(amt: 10089.00), imageUrl: "https://static.shwrm.net/images/7/l/7l5773d518c5c92_500x643.jpg", lowResImageUrl: nil),
            Product(id: 2, brand: "Tomaotomo by Tomasz Olejniczak test", name: "Sukienka Rosie z czerwonym kapturem", basePrice: Money(amt: 479.00), price: Money(amt: 218.00), imageUrl: "https://static.shwrm.net/images/p/5/p55772f826bed13_500x643.jpg", lowResImageUrl: nil),
            Product(id: 3, brand: "Justyna Chrabelska", name: "Sukienka jedwabna z falbanką", basePrice: Money(amt: 369.00), price: Money(amt: 369.00), imageUrl: "https://static.shwrm.net/images/f/z/fz57729609b985b_500x643.jpg", lowResImageUrl: nil),
            Product(id: 4, brand: "byCabo", name: "Sukienka z dzianiny", basePrice: Money(amt: 289.00), price: Money(amt: 289.00), imageUrl: "https://static.shwrm.net/images/e/v/ev5512ae375543e_500x643.jpg", lowResImageUrl: nil),
        ]
        let result = ProductListResult(products: products, isLastPage: false)
        return Observable.just(FetchResult.Success(result)).delaySubscription(1, scheduler: ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background)).observeOn(MainScheduler.instance)
    }
    
    func fetchNextProductPage() -> Observable<FetchResult<ProductListResult>> {
        let products: [Product] = [
            Product(id: 1, brand: "ECHO", name: "Sukienka Rosie z czerwonym kapturem", basePrice: Money(amt: 10119.00), price: Money(amt: 10089.00), imageUrl: "https://static.shwrm.net/images/7/l/7l5773d518c5c92_500x643.jpg", lowResImageUrl: nil),
            Product(id: 2, brand: "Tomaotomo by Tomasz Olejniczak test", name: "Sukienka Rosie z czerwonym kapturem", basePrice: Money(amt: 479.00), price: Money(amt: 218.00), imageUrl: "https://static.shwrm.net/images/p/5/p55772f826bed13_500x643.jpg", lowResImageUrl: nil)
        ]
        let result = ProductListResult(products: products, isLastPage: true)
        return Observable.just(FetchResult.Success(result)).delaySubscription(4, scheduler: ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background)).observeOn(MainScheduler.instance)
    }
}