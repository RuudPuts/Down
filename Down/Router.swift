//
//  Router.swift
//  Down
//
//  Created by Ruud Puts on 07/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import UIKit

protocol Routing {
    var router: Router? { get set }
}

class Router {    
    let window: UIWindow
    let storyboard: UIStoryboard
    var navigationController: UINavigationController? {
        return window.rootViewController as? UINavigationController
    }
    
    init(window: UIWindow, storyboard: UIStoryboard) {
        self.window = window
        self.storyboard = storyboard
    }
    
    enum Identifier: String {
        case root
        case detail
    }
    
    func start() {
        let rootViewController = makeViewController(.root)
        let navigationController = UINavigationController(rootViewController: rootViewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    private func makeViewController(_ identifier: Identifier) -> UIViewController & Routing {
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier.rawValue)
        guard var rxViewController = viewController as? UIViewController & Routing else {
            fatalError("bye")
        }
        rxViewController.router = self
        
        return rxViewController
    }
    
//    func showDetail(of show: DvrShow) {
//        guard let viewController = makeViewController(.detail) as? DetailViewController else {
//            return
//        }
//        
//        viewController.show = show
//        navigationController?.pushViewController(viewController, animated: true)
//    }
}
