import Swifter
import XCTest

class MockServer {
    private let server = HttpServer()
    
    func start() throws {
        configureGetCode()
        try server.start()
    }
    
    func stop() {
        server.stop()
    }
    
    private func configureGetCode() {
        let codeToResponse = [
            Company.Staropramen.barcode : "staropramen",
            Company.Gustaw.barcode : "gustaw",
            ISBNCode : "isbn"
        ]
        
        server["/get_by_code"] =
            { request in
                let code = request.queryParams.first(where: { (key, value) -> Bool in
                    return key == "code"
                })!.1
                let responseFilename = codeToResponse[code]!
                return self.response(from: responseFilename)
        }
        
    }
    
    private func response(from filename: String) -> HttpResponse {
        let path = Bundle(for: MockServer.self).path(forResource: filename, ofType: "json")!
        let data: Data
        do {
            data = try Data(contentsOf: URL(fileURLWithPath: path))
        } catch {
            NSLog("MockServer: Failed read response from file with error \(error)")
            return HttpResponse.badRequest(nil)
        }
        return HttpResponse.ok(.data(data))
    }
    
}
