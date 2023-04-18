import UIKit

enum CustomFontType {
    case heavy
    case bold
    case regular
    case medium
}

extension UIFont {
    static func customFont(type: CustomFontType, size: CGFloat) -> UIFont {
        switch type {
        case .heavy:
            return UIFont(name: "MarkPro-heavy", size: size)!
        case .bold:
            return UIFont(name: "MarkPro-Bold", size: size)!
        case .regular:
            return UIFont(name: "MarkPro-Regular", size: size)!
        case .medium:
            return UIFont(name: "MarkPro-Medium", size: size)!
        }
    }
}
