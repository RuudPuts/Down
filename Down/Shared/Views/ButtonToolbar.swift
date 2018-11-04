//
//  ButtonToolbar.swift
//  Down
//
//  Created by Ruud Puts on 06/10/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit

class ButtonToolbar: UIView {
    var insets = UIEdgeInsets.zero {
        didSet {
            updateStackViewConstraints()
        }
    }

    private let stackView: UIStackView

    init() {
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false

        super.init(frame: .zero)

        addSubview(stackView)
        updateStackViewConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateStackViewConstraints() {
        removeConstraints(constraints.filter {
            $0.firstItem === self.stackView || $0.secondItem === self.stackView
        })

        stackView.topAnchor
            .constraint(equalTo: topAnchor, constant: insets.top)
            .isActive = true

        stackView.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: insets.left)
            .isActive = true

        stackView.bottomAnchor
            .constraint(equalTo: bottomAnchor, constant: insets.bottom)
            .isActive = true

        stackView.trailingAnchor
            .constraint(equalTo: trailingAnchor, constant: -insets.right)
            .isActive = true
    }

    func addButton(title: String, style: ViewStyling<UIButton>) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.style(as: style)

        stackView.addArrangedSubview(button)

        return button
    }
}
