//
//  DvrDetailViewController.swift
//  Down
//
//  Created by Ruud Puts on 03/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import RxSwift
import UIKit

class DvrDetailViewController: DvrRouterViewController {
    var dvrRouter: DvrRouter?
    
    var show: DvrShow? {
        didSet { title = show?.name }
    }
}
