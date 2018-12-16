import UIKit
import DownKit

struct Stylesheet {
    struct Colors {
        struct Backgrounds {
            static let lightGray = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1.00)
            static let darkGray = UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1.00)

            static let lightBlue = UIColor(red: 0.20, green: 0.24, blue: 0.30, alpha: 1.00)
            static let darkBlue = UIColor(red: 0.11, green: 0.14, blue: 0.20, alpha: 1.00)
        }

        static func primaryColor(for type: DownApplicationType) -> UIColor {
            switch type {
            case .sabnzbd: return UIColor(red: 0.97, green: 0.78, blue: 0, alpha: 1)
            case .sickbeard, .sickgear: return UIColor(red: 0.15, green: 0.68, blue: 0.38, alpha: 1)
            case .couchpotato: return UIColor(red: 0.21, green: 0.6, blue: 0.86, alpha: 1)
            }
        }

        static func secondaryColor(for type: DownApplicationType) -> UIColor {
            switch type {
            case .sabnzbd: return UIColor(red: 0.94, green: 0.73, blue: 0.1, alpha: 1)
            case .sickbeard, .sickgear: return UIColor(red: 0.11, green: 0.62, blue: 0.37, alpha: 1)
            case .couchpotato: return UIColor(red: 0.18, green: 0.5, blue: 0.71, alpha: 1)
            }
        }

        static var black = UIColor.black
        static var white = UIColor.white
        static var green = UIColor(red: 0.25, green: 0.75, blue: 0.45, alpha: 1)
        static var orange = UIColor(red: 0.87, green: 0.63, blue: 0.31, alpha: 1.00)
        static var red = UIColor(red: 0.84, green: 0.29, blue: 0.26, alpha: 1)
        static var blue = UIColor(red: 0.25, green: 0.50, blue: 0.71, alpha: 1.00)
        static var purple = UIColor(red: 0.52, green: 0.30, blue: 0.66, alpha: 1.00)
    }

    struct Fonts {
        static let headerFont = regularFont(ofSize: 18)
        static let largeHeaderFont = regularFont(ofSize: 22)
        static let titleFont = regularFont(ofSize: 16)
        static let boldTitleFont = boldFont(ofSize: 16)
        static let detailFont = lightFont(ofSize: 14)
        static let boldDetailFont = regularFont(ofSize: 14)

        static func regularFont(ofSize size: CGFloat) -> UIFont {
            return UIFont(name: "OpenSans", size: size)!
        }

        static func lightFont(ofSize size: CGFloat) -> UIFont {
            return UIFont(name: "OpenSans-Light", size: size)!
        }

        static func boldFont(ofSize size: CGFloat) -> UIFont {
            return UIFont(name: "OpenSans-Bold", size: size)!
        }
    }
}
