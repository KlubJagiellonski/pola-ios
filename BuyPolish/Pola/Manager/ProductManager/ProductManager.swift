import Alamofire

class ProductManager {
    
    private var baseURL: String {
        ProcessInfo.processInfo.environment["POLA_URL"] ?? "https://www.pola-app.pl/a/v3"
    }
    
    func retrieveProduct(barcode: String, completion: @escaping ResultHandler<ScanResult>) {
        let parameters = ["device_id" : UIDevice.current.deviceId, "code" : barcode]
        Alamofire.request("\(baseURL)/get_by_code",
                          method: .get,
                          parameters: parameters).responseData { response in
                            switch response.result {
                            case .success(let data):
                                do {
                                    let decoder = JSONDecoder()
                                    let scanResult = try decoder.decode(ScanResult.self, from: data)
                                    completion(.success(scanResult))
                                } catch {
                                    completion(.failure(error))
                                }
                                
                            case .failure(let error):
                                completion(.failure(error))
                            }
        }
    }
    
}
