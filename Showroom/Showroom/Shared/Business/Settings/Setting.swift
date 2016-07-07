import UIKit

enum CellType {
    case Header, Login, Logout, Gender, Normal
}

struct Setting {
    let type: CellType
    let labelString: String?
    let action: () -> ()
    let secondaryAction: (() -> ())?
    let url: String?
    
    init(type: CellType, labelString: String? = nil, action: () -> (), secondaryAction: (() -> ())? = nil, url: String? = nil) {
        self.type = type
        self.labelString = labelString
        self.action = action
        self.secondaryAction = secondaryAction
        self.url = url
    }
}

