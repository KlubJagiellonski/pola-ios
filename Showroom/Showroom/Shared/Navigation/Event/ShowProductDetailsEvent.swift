import Foundation

struct ShowProductDetailsEvent: NavigationEvent {
    let context: ProductDetailsContext
    var retrieveCurrentImageViewTag: (() -> Int?)?
}