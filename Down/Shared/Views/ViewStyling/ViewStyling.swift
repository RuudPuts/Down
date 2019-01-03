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

protocol Stylable { }
extension Stylable {
    @discardableResult
    func style<T>(as styling: ViewStyling<T>) -> Self {
        guard let view = self as? T else {
            return self
        }

        styling.style(view)

        return self
    }
}

extension UIView: Stylable { }

extension UIViewController: Stylable { }

extension UIBarButtonItem: Stylable { }

extension Reactive where Base: UIView {
    var style: Binder<ViewStyling<Base>> {
        return Binder(base) { view, style in
            view.style(as: style)
        }
    }
}
