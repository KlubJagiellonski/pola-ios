import UIKit

enum CellType {
    case Header, Login, Logout, Gender, Normal, AskForNotification
}

struct Setting {
    let type: CellType
    let labelString: String?
    let action: () -> ()
    let secondaryAction: (() -> ())?
    let cellClickable: Bool
    var value: Any?
    
    init(type: CellType, labelString: String? = nil, action: () -> (), secondaryAction: (() -> ())? = nil, cellClickable: Bool = true, value: Any? = nil) {
        self.type = type
        self.labelString = labelString
        self.action = action
        self.secondaryAction = secondaryAction
        self.cellClickable = cellClickable
        self.value = value
    }
}

