import UIKit

enum CellType {
    case Header, Login, Logout, Gender, Normal
}

struct Setting {
    let type: CellType
    let labelString: String?
    let action: () -> ()
    let secondaryAction: (() -> ())?
    var value: Any?
    
    init(type: CellType, labelString: String? = nil, action: () -> (), secondaryAction: (() -> ())? = nil, value: Any? = nil) {
        self.type = type
        self.labelString = labelString
        self.action = action
        self.secondaryAction = secondaryAction
        self.value = value
    }
}

