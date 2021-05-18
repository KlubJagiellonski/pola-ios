import PromiseKit
import UIKit
import Vision

final class BarcodeDetector {
    private var barcodeText: String?

    private lazy var vnBarcodeRequest: VNDetectBarcodesRequest = .init(completionHandler: barcodeHandler)

    private func barcodeHandler(request: VNRequest, error _: Error?) {
        guard let results = request.results,
            let barcode = results
            .compactMap({ $0 as? VNBarcodeObservation })
            .first,
            let barcodePayload = barcode.payloadStringValue else { return }
        barcodeText = barcodePayload
    }

    func getBarcodeFromImage(_ image: UIImage) -> Promise<String?> {
        barcodeText = nil
        return Promise { seal in
            guard let ciImage = image.cgImage else {
                seal.fulfill(nil)
                return
            }
            let handler = VNImageRequestHandler(cgImage: ciImage, options: [.properties: ""])

            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let self = self else { return }
                try? handler.perform([self.vnBarcodeRequest])
                seal.fulfill(self.barcodeText)
            }
        }
    }
}
