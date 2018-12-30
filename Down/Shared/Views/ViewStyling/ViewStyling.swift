import UIKit
import RxSwift
import RxCocoa

// Heavily based on https://hackernoon.com/simple-stylesheets-in-swift-6dda57b5b00d

struct ViewStyling<ViewType> {
    let style: (ViewType) -> Void

    init(_ style: @escaping (ViewType) -> Void) {
        self.style = style
    }
}

extension UIView {
    @discardableResult
    func style<T>(as styling: ViewStyling<T>) -> Self {
        guard let view = self as? T else {
            return self
        }

        styling.style(view)

        return self
    }
}

extension UIViewController {
    @discardableResult
    func style<T>(as styling: ViewStyling<T>) -> Self {
        guard let view = self as? T else {
            return self
        }

        styling.style(view)

        return self
    }
}

extension Reactive where Base: UILabel {
    var style: Binder<ViewStyling<UILabel>> {
        return Binder(base) { view, style in
            view.style(as: style)
        }
    }
}
