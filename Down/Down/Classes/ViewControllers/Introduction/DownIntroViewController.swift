//
//  DownIntroViewController.swift
//  Down
//
//  Created by Ruud Puts on 21/12/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation

class DownIntroViewController: DownViewController, DownSettingsViewControllerDelegate {
    
    enum IntroType {
        case Welcome
        case SickbeardCacheRefresh
    }
    
    var introType: IntroType!
    
    convenience init(introType: IntroType) {
        self.init(nibName: "DownWelcomeViewController", bundle: nil)
        
        self.introType = introType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        window.statusBarBackgroundColor = .downRedColor()
    }
    
    @IBAction func actionButtonPressed(sender: AnyObject) {
        let settingsViewController = DownSettingsViewController(application: .SabNZBd)
        settingsViewController.delegate = self
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    // MARK: - DownSettingsViewController
    
    func settingsViewControllerDidTapActionButton(viewController: DownSettingsViewController) {
        if viewController.application == .SabNZBd {
            let settingsViewController = DownSettingsViewController(application: .Sickbeard)
            settingsViewController.delegate = self
            navigationController?.pushViewController(settingsViewController, animated: true)
        }
        else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
}