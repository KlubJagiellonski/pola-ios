import Foundation

class CheckoutModel {
    private let basketManager: BasketManager
    
    private(set) var comments: [String?] = []
    
    init(basketManager: BasketManager) {
        self.basketManager = basketManager
        guard let basket = basketManager.state.basket else {
            fatalError("Could not create CheckoutModel instance, because BasketManager returns wrong basket object.")
        }
        self.comments = [String?](count: basket.productsByBrands.count, repeatedValue: nil)
    }
    
    func update(comment comment: String?, at index: Int) {
        if index < 0 || index >= comments.count {
            return
        }
        
        guard let comment = comment else {
            self.comments[index] = nil
            return
        }
        
        let trimmedComment = comment.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        
        if trimmedComment.characters.count == 0 {
            self.comments[index] = nil
            return
        }
        
        self.comments[index] = comment
    }
    
    func comment(at index: Int) -> String? {
        return comments.count > index ? comments[index] : nil
    }
}