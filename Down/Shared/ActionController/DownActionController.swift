//
//  ActionController.swift
//  Down
//
//  Created by Ruud Puts on 22/12/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import Foundation
import DownKit
import XLActionController

class DownActionController: ActionController<DownActionCell, ActionData, UICollectionReusableView, Void, UICollectionReusableView, Void> {
    let applicationType: DownApplicationType

    init(applicationType: DownApplicationType) {
        self.applicationType = applicationType

        super.init(nibName: nil, bundle: nil)

        collectionViewLayout.minimumLineSpacing = -0.5

        settings.behavior.hideOnScrollDown = true
        settings.animation.scale = nil
        settings.animation.present.duration = 0.6
        settings.animation.dismiss.duration = 0.6
        settings.animation.dismiss.offset = 30
        settings.animation.dismiss.options = .curveLinear

        cellSpec = .nibFile(nibName: "DownActionCell", bundle: Bundle(for: DownActionCell.self), height: { _  in 46 })

        onConfigureCellForAction = { cell, action, indexPath in
            cell.setup(action.data?.title, detail: action.data?.subtitle, image: action.data?.image)
            cell.style(as: .actionCell(for: self.applicationType, actionStyle: action.style))
            cell.alpha = action.enabled ? 1.0 : 0.5
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DownActionController {
    func addAction(title: String, subtitle: String? = nil, image: UIImage? = nil, style: ActionStyle = .default, handler: ((Action<ActionData>) -> Void)? = nil) {
        let data = ActionData(title: title, subtitle: subtitle ?? "", image: image ?? UIImage())
        let action = Action(data, style: style, handler: handler)

        addAction(action)
    }
}

class DownActionCell: ActionCell {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }

    func initialize() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.blue
        selectedBackgroundView = backgroundView
    }
}
