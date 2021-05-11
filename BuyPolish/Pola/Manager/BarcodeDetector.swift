//
//  BarcodeDetector.swift
//  Pola
//
//  Created by Damian on 10/05/2021.
//  Copyright © 2021 PJMS. All rights reserved.
//

import UIKit
import Vision

final class BarcodeDetector {
    private var barcodeText: String?

    private let barcodeDetector = VNDetectBarcodesRequest { request, error in
        guard error == nil else { return }
        guard let results = request.results,
              let barcode = results
                .compactMap({ $0 as? VNBarcodeObservation })
                .first,
              let barcodePayload = barcode.payloadStringValue else { return }

    }

    private lazy var vnBarcodeRequest: VNDetectBarcodesRequest = .init(completionHandler: barcodeHandler)

    private func barcodeHandler(request: VNRequest, error: Error?) {
        guard let results = request.results,
              let barcode = results
                .compactMap({ $0 as? VNBarcodeObservation })
                .first,
              let barcodePayload = barcode.payloadStringValue else { return }
        barcodeText = barcodePayload
    }

    func getBarcodeFromImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        guard let ciImage = image.cgImage else {
            completion(nil)
            return
        }
        let handler = VNImageRequestHandler(cgImage: ciImage, options: [.properties: ""])
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else {
                completion(nil)
                return
            }
            do {
                try handler.perform([self.vnBarcodeRequest])
                DispatchQueue.main.async {
                    completion(self.barcodeText)
                    self.barcodeText = nil
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}
