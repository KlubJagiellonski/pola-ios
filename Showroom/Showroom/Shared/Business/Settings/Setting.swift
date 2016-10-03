import UIKit

enum CellType {
    case Header, Login, Logout, Gender, Normal, AskForNotification, Platform
}

struct Setting {
    let type: CellType
    let labelString: String?
    let secondaryLabelString: String?
    let action: () -> ()
    let secondaryAction: (() -> ())?
    let cellClickable: Bool
    var value: Any?
    
    init(type: CellType, labelString: String? = nil, secondaryLabelString: String? = nil, action: () -> (), secondaryAction: (() -> ())? = nil, cellClickable: Bool = true, value: Any? = nil) {
        self.type = type
        self.labelString = labelString
        self.secondaryLabelString = secondaryLabelString
        self.action = action
        self.secondaryAction = secondaryAction
        self.cellClickable = cellClickable
        self.value = value
    }
}

