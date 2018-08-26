//
//  DownloadQueueStatusViewStyle.swift
//  Down
//
//  Created by Ruud Puts on 26/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit

extension ViewStyling where ViewType == DownloadQueueStatusView {
    static var defaultQueueStatusView = ViewStyling {
        $0.backgroundColor = .clear

        [$0.speedLabel, $0.timeRemainingLabel, $0.mbRemainingLabel].forEach {
            $0?.font = Stylesheet.Fonts.regularFont(ofSize: 18)
            $0?.textColor = .white
        }

        [$0.speedValueLabel, $0.timeRemainingValueLabel, $0.mbRemainingValueLabel].forEach {
            $0?.font = Stylesheet.Fonts.lightFont(ofSize: 16)
            $0?.textColor = .white
        }
    }
}
