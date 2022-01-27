// Generated using Sourcery 1.6.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

import PromiseKit

@testable import Pola














class AnalyticsProviderMock: AnalyticsProvider {

    //MARK: - configure

    var configureCallsCount = 0
    var configureCalled: Bool {
        return configureCallsCount > 0
    }
    var configureClosure: (() -> Void)?

    func configure() {
        configureCallsCount += 1
        configureClosure?()
    }

    //MARK: - logEvent

    var logEventNameParametersCallsCount = 0
    var logEventNameParametersCalled: Bool {
        return logEventNameParametersCallsCount > 0
    }
    var logEventNameParametersReceivedArguments: (name: String, parameters: [String: String]?)?
    var logEventNameParametersReceivedInvocations: [(name: String, parameters: [String: String]?)] = []
    var logEventNameParametersClosure: ((String, [String: String]?) -> Void)?

    func logEvent(name: String, parameters: [String: String]?) {
        logEventNameParametersCallsCount += 1
        logEventNameParametersReceivedArguments = (name: name, parameters: parameters)
        logEventNameParametersReceivedInvocations.append((name: name, parameters: parameters))
        logEventNameParametersClosure?(name, parameters)
    }

}
class KeyboardManagerMock: KeyboardManager {
    var delegate: KeyboardManagerDelegate?

    //MARK: - turnOn

    var turnOnCallsCount = 0
    var turnOnCalled: Bool {
        return turnOnCallsCount > 0
    }
    var turnOnClosure: (() -> Void)?

    func turnOn() {
        turnOnCallsCount += 1
        turnOnClosure?()
    }

    //MARK: - turnOff

    var turnOffCallsCount = 0
    var turnOffCalled: Bool {
        return turnOffCallsCount > 0
    }
    var turnOffClosure: (() -> Void)?

    func turnOff() {
        turnOffCallsCount += 1
        turnOffClosure?()
    }

}
class ProductImageManagerMock: ProductImageManager {

    //MARK: - saveImage

    var saveImageForIndexCallsCount = 0
    var saveImageForIndexCalled: Bool {
        return saveImageForIndexCallsCount > 0
    }
    var saveImageForIndexReceivedArguments: (image: UIImage, key: ReportProblemReason, index: Int)?
    var saveImageForIndexReceivedInvocations: [(image: UIImage, key: ReportProblemReason, index: Int)] = []
    var saveImageForIndexReturnValue: Bool!
    var saveImageForIndexClosure: ((UIImage, ReportProblemReason, Int) -> Bool)?

    func saveImage(_ image: UIImage, for key: ReportProblemReason, index: Int) -> Bool {
        saveImageForIndexCallsCount += 1
        saveImageForIndexReceivedArguments = (image: image, key: key, index: index)
        saveImageForIndexReceivedInvocations.append((image: image, key: key, index: index))
        return saveImageForIndexClosure.map({ $0(image, key, index) }) ?? saveImageForIndexReturnValue
    }

    //MARK: - removeImage

    var removeImageForIndexCallsCount = 0
    var removeImageForIndexCalled: Bool {
        return removeImageForIndexCallsCount > 0
    }
    var removeImageForIndexReceivedArguments: (key: ReportProblemReason, index: Int)?
    var removeImageForIndexReceivedInvocations: [(key: ReportProblemReason, index: Int)] = []
    var removeImageForIndexReturnValue: Bool!
    var removeImageForIndexClosure: ((ReportProblemReason, Int) -> Bool)?

    func removeImage(for key: ReportProblemReason, index: Int) -> Bool {
        removeImageForIndexCallsCount += 1
        removeImageForIndexReceivedArguments = (key: key, index: index)
        removeImageForIndexReceivedInvocations.append((key: key, index: index))
        return removeImageForIndexClosure.map({ $0(key, index) }) ?? removeImageForIndexReturnValue
    }

    //MARK: - removeImages

    var removeImagesForCallsCount = 0
    var removeImagesForCalled: Bool {
        return removeImagesForCallsCount > 0
    }
    var removeImagesForReceivedKey: ReportProblemReason?
    var removeImagesForReceivedInvocations: [ReportProblemReason] = []
    var removeImagesForReturnValue: Bool!
    var removeImagesForClosure: ((ReportProblemReason) -> Bool)?

    func removeImages(for key: ReportProblemReason) -> Bool {
        removeImagesForCallsCount += 1
        removeImagesForReceivedKey = key
        removeImagesForReceivedInvocations.append(key)
        return removeImagesForClosure.map({ $0(key) }) ?? removeImagesForReturnValue
    }

    //MARK: - retrieveThumbnail

    var retrieveThumbnailForIndexCallsCount = 0
    var retrieveThumbnailForIndexCalled: Bool {
        return retrieveThumbnailForIndexCallsCount > 0
    }
    var retrieveThumbnailForIndexReceivedArguments: (key: ReportProblemReason, index: Int)?
    var retrieveThumbnailForIndexReceivedInvocations: [(key: ReportProblemReason, index: Int)] = []
    var retrieveThumbnailForIndexReturnValue: UIImage?
    var retrieveThumbnailForIndexClosure: ((ReportProblemReason, Int) -> UIImage?)?

    func retrieveThumbnail(for key: ReportProblemReason, index: Int) -> UIImage? {
        retrieveThumbnailForIndexCallsCount += 1
        retrieveThumbnailForIndexReceivedArguments = (key: key, index: index)
        retrieveThumbnailForIndexReceivedInvocations.append((key: key, index: index))
        return retrieveThumbnailForIndexClosure.map({ $0(key, index) }) ?? retrieveThumbnailForIndexReturnValue
    }

    //MARK: - retrieveThumbnails

    var retrieveThumbnailsForCallsCount = 0
    var retrieveThumbnailsForCalled: Bool {
        return retrieveThumbnailsForCallsCount > 0
    }
    var retrieveThumbnailsForReceivedKey: ReportProblemReason?
    var retrieveThumbnailsForReceivedInvocations: [ReportProblemReason] = []
    var retrieveThumbnailsForReturnValue: [UIImage]!
    var retrieveThumbnailsForClosure: ((ReportProblemReason) -> [UIImage])?

    func retrieveThumbnails(for key: ReportProblemReason) -> [UIImage] {
        retrieveThumbnailsForCallsCount += 1
        retrieveThumbnailsForReceivedKey = key
        retrieveThumbnailsForReceivedInvocations.append(key)
        return retrieveThumbnailsForClosure.map({ $0(key) }) ?? retrieveThumbnailsForReturnValue
    }

    //MARK: - pathsForImages

    var pathsForImagesForCallsCount = 0
    var pathsForImagesForCalled: Bool {
        return pathsForImagesForCallsCount > 0
    }
    var pathsForImagesForReceivedKey: ReportProblemReason?
    var pathsForImagesForReceivedInvocations: [ReportProblemReason] = []
    var pathsForImagesForReturnValue: [String]!
    var pathsForImagesForClosure: ((ReportProblemReason) -> [String])?

    func pathsForImages(for key: ReportProblemReason) -> [String] {
        pathsForImagesForCallsCount += 1
        pathsForImagesForReceivedKey = key
        pathsForImagesForReceivedInvocations.append(key)
        return pathsForImagesForClosure.map({ $0(key) }) ?? pathsForImagesForReturnValue
    }

}
class ReportManagerMock: ReportManager {

    //MARK: - send

    var sendReportCallsCount = 0
    var sendReportCalled: Bool {
        return sendReportCallsCount > 0
    }
    var sendReportReceivedReport: Report?
    var sendReportReceivedInvocations: [Report] = []
    var sendReportReturnValue: Promise<Void>!
    var sendReportClosure: ((Report) -> Promise<Void>)?

    func send(report: Report) -> Promise<Void> {
        sendReportCallsCount += 1
        sendReportReceivedReport = report
        sendReportReceivedInvocations.append(report)
        return sendReportClosure.map({ $0(report) }) ?? sendReportReturnValue
    }

}
