//
//  UIDevice+Extensions.swift
//  Down
//
//  Created by Ruud Puts on 04/06/2017.
//  Copyright © 2017 Ruud Puts. All rights reserved.
//

import UIKit

extension UIDevice {
    
    enum HapticFeedbackType {
        case smallTick
        case tick
        case doubleTick
    }
    
    class func hapticFeedback(_ feedbackType: HapticFeedbackType) {
        switch feedbackType {
        case .smallTick:
            UISelectionFeedbackGenerator().selectionChanged()
            break
        case .tick:
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
            break
        case .doubleTick:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            break
        }
    }
    
}
