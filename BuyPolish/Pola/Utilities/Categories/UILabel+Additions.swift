import UIKit

extension UILabel {
    func height(forWidth width: CGFloat) -> CGFloat {
        guard let text = text,
              let font = font else {
            return 0
        }
        let string = NSString(string: text)
        return string.boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude),
                                   options: .usesLineFragmentOrigin,
                                   attributes: [NSAttributedString.Key.font: font],
                                   context: nil).size.height
    }

    var textIsNotEmpty: Bool {
        text?.isNotEmpty ?? false
    }

    var nonNullText: String {
        text ?? ""
    }
}
