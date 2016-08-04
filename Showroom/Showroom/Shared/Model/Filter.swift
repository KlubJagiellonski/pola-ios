import Foundation
import Decodable

typealias FilterId = String
typealias FilterObjectId = Int

enum FilterType: String {
    case Tree = "tree"
    case Choice = "choice"
    case Select = "select"
    case Range = "range"
    case Unknown = "unknown"
}

enum FilterColorType: String {
    case RGB = "RGB"
    case Image = "Image"
    case Unknown = "Unknown"
}

struct Filter {
    let id: FilterId
    let label: String
    let type: FilterType
    let multiple: Bool
    var data: [FilterObjectId]
    let defaultId: FilterObjectId?
    let branches: [FilterBranch]?
    let choices: [FilterChoice]?
    let step: Int?
    let range: ValueRange?
}

struct FilterBranch {
    let id: FilterObjectId
    let label: String
    let branches: [FilterBranch]
}

struct FilterChoice {
    let id: FilterObjectId
    let name: String
    let colorType: FilterColorType?
    let colorValue: String?
}

struct ValueRange {
    let min: Int
    let max: Int
}

// MARK:- Decodable

extension Filter: Decodable {
    static func decode(json: AnyObject) throws -> Filter {
        var range: ValueRange?
        if let rangeMin: Int = try json =>? "min", let rangeMax: Int = try json =>? "max" {
            range = ValueRange(min: rangeMin, max: rangeMax)
        }
        
        return try Filter(
            id: json => "id",
            label: json => "label",
            type: FilterType(rawValue: json => "type") ?? .Unknown,
            multiple: json =>? "multiple" ?? false,
            data: json => "data",
            defaultId: json =>? "default",
            branches: json =>? "branches",
            choices: json =>? "choices",
            step: json =>? "step",
            range: range
        )
    }
}

extension FilterBranch: Decodable {
    static func decode(json: AnyObject) throws -> FilterBranch {
        return try FilterBranch(
            id: json => "id",
            label: json => "label",
            branches: json =>? "branches" ?? []
        )
    }
}

extension FilterChoice: Decodable {
    static func decode(json: AnyObject) throws -> FilterChoice {
        return try FilterChoice(
            id: json => "id",
            name: json => "name",
            colorType: json =>? "type",
            colorValue: json =>? "value"
        )
    }
}

extension FilterColorType: Decodable {
    static func decode(json: AnyObject) throws -> FilterColorType {
        guard let string = json as? String else { return .Unknown }
        return FilterColorType(rawValue: string) ?? .Unknown
    }
}