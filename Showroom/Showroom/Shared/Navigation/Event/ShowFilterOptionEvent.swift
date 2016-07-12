import Foundation

enum FilterOption {
    case Sort, Category, Size, Color, Brand
}

struct ShowFilterOptionEvent: NavigationEvent {
    let filterOption: FilterOption
}