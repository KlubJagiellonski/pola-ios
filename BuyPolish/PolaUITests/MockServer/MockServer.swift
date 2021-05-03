import Swifter
import XCTest

final class MockServer {
    static let shared = MockServer()
    private let server = HttpServer()
    private(set) var loggedRequest = [HttpRequest]()

    func start() throws {
        configureResponses()
        try server.start(8888)
    }

    func stop() {
        server.stop()
    }

    func clearLogs() {
        loggedRequest.removeAll()
    }

    private let codeDatas = [
        CodeData.Radziemska,
        CodeData.Gustaw,
        CodeData.ISBN,
        CodeData.Koral,
        CodeData.Lomza,
        CodeData.Staropramen,
        CodeData.Tymbark,
        CodeData.Naleczowianka,
        CodeData.Krasnystaw,
        CodeData.Lidl,
    ]

    private func configureResponses() {
        server["/get_by_code"] = {
            request in
            self.record(request: request)
            let code = self.code(from: request)
            let responseFilename = self.responseFilename(for: code)
            return self.response(from: responseFilename)
        }
        server["/create_report"] = {
            request in
            self.record(request: request)
            return self.response(from: "create_report")
        }

        server["/image"] = {
            request in
            self.record(request: request)
            return HttpResponse.ok(.text(""))
        }
    }

    private func record(request: HttpRequest) {
        loggedRequest.append(request)
        print("Mock server handle request \(request.path)")
    }

    private func code(from request: HttpRequest) -> String {
        return request.queryParams.first(where: { (key, _) -> Bool in
            key == "code"
        })!.1
    }

    private func responseFilename(for code: String) -> String {
        return codeDatas.first(where: { $0.barcode == code })!.responseFile
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
