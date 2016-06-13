import Foundation
import EmarsysPredictSDK
import RxSwift

struct EmarsysService {
    let session: EMSession
}

extension EmarsysService {
    func fetchProductRecommendations() -> Observable<ProductRecommendationResult> {
        return Observable<ProductRecommendationResult>.create { observer in
            let session = EMSession.sharedSession()
            let transaction = EMTransaction()
            
            let recommendationRequest = EMRecommendationRequest(logic: "HOME")
            recommendationRequest.limit = Constants.emarsysRecommendationItemsLimit
            recommendationRequest.completionHandler = { result in
                do {
                    let productRecommendations = try result.products.map { item in try ProductRecommendation.decode(item.data) }
                    let productRecommendationResult = ProductRecommendationResult(productRecommendations: productRecommendations)
                    observer.onNext(productRecommendationResult)
                } catch {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            transaction.recommend(recommendationRequest)
            session.sendTransaction(transaction) { error in
                observer.onError(error)
                observer.onCompleted()
            }
            return NopDisposable.instance
        }
    }
}