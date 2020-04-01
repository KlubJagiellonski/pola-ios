import Alamofire
import PromiseKit

struct GetScanResultRequestBody : Encodable {
    let code: String
}

final class ProductManager {
    private let dataRequestFactory: DataRequestFactory
    
    init(dataRequestFactory: DataRequestFactory) {
        self.dataRequestFactory = dataRequestFactory
    }
    
    func retrieveProduct(barcode: String) -> Promise<ScanResult> {
        dataRequestFactory
            .request(path: "get_by_code",
                     method: .get,
                     parameters: GetScanResultRequestBody(code: barcode),
                     encoding: URLEncoding.default)
            .responseDecodable(ScanResult.self)
    }
    
}
