//
//  ViewControllerFactory.swift
//  Down
//
//  Created by Ruud Puts on 12/07/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit

protocol ViewControllerProducing {
    func makeDownloadRoot() -> UIViewController

    func makeDvrRoot() -> UIViewController
    func makeDvrDetail() -> UIViewController
}

enum Identifier {
    enum Download: String {
        case root = "downloadRoot"
    }

    enum Dvr: String {
        case root = "dvrRoot"
        case detail = "dvrDetail"
    }
}

class ViewControllerFactory: ViewControllerProducing {
    let storyboard: UIStoryboard

    init(storyboard: UIStoryboard) {
        self.storyboard = storyboard
    }

    func makeDownloadRoot() -> UIViewController {
        return makeViewController(Identifier.Dvr.root.rawValue)
    }

    func makeDvrRoot() -> UIViewController {
        return makeViewController(Identifier.Download.root.rawValue)
    }

    func makeDvrDetail() -> UIViewController {
        return makeViewController(Identifier.Dvr.detail.rawValue)
    }
}

private extension ViewControllerFactory {
    func makeViewController(_ identifier: String) -> UIViewController {
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
}
