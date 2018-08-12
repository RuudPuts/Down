import UIKit

// Heavily based on https://hackernoon.com/simple-stylesheets-in-swift-6dda57b5b00d

struct ViewStyling<ViewType> {
    let style: (ViewType) -> Void

    init(_ style: @escaping (ViewType) -> Void) {
        self.style = style
    }
}

extension UIView {
    func style<T>(as styling: ViewStyling<T>) {
        guard let view = self as? T else {
            return
        }

        styling.style(view)
    }
}
