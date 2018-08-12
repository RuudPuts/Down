//
//  DesignableView.swift
//  Down
//
//  Created by Ruud Puts on 14/07/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit

class DesignableView: UIView {
    var contentView: UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)

        initContentView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initContentView()
    }

    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()

        initContentView()
        contentView?.prepareForInterfaceBuilder()
    }

    func initContentView() {
        guard let contentView = loadViewFromNib() else {
            return
        }

        addSubview(contentView)
        contentView.constraintToFillParent()

        self.contentView = contentView
    }

    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: Bundle.main)

        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
