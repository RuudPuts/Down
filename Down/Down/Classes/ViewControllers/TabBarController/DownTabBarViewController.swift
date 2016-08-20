//
//  DownTabBarViewController.swift
//  Down
//
//  Created by Ruud Puts on 07/04/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

class DownTabBarViewController: DownViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet var tabButtons: [UIButton]!

    var currentViewController: UIViewController?
    var selectedTab = TabBarSegue.SabNZBd
    
    enum TabBarSegue: String {
        case SabNZBd = "SabNZBdTab"
        case Sickbeard = "SickbeardTab"
        case CouchPotato = "CouchPotatoTab"
        
        var tabIndex: Int {
            get {
                switch self {
                case .SabNZBd: return 0
                case .Sickbeard: return 1
                case .CouchPotato: return 2
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if currentViewController == nil {
            // Load the SabNZBd view by default
            performSegueWithIdentifier(TabBarSegue.SabNZBd.rawValue, sender: tabButtons.first)
        }
        applyAppearance()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutContentView()
    }
    
    func layoutContentView() {
        for subview in contentView.subviews {
            subview.frame = contentView.bounds
        }
    }
    
    // MARK: Setters and getters
    
    var selectedTabColor: UIColor {
        switch selectedTab {
        case .SabNZBd: return .downSabNZBdDarkColor()
        case .CouchPotato: return .downSickbeardDarkColor()
        case .Sickbeard: return .downCouchPotatoDarkColor()
        }
    }
    
    var deselectedTabColor: UIColor {
        switch selectedTab {
        case .SabNZBd: return .downSabNZBdColor()
        case .CouchPotato: return .downSickbeardColor()
        case .Sickbeard: return .downCouchPotatoColor()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let tabIdentifier = segue.identifier, tabBarSegue = TabBarSegue(rawValue: tabIdentifier){
            selectedTab = tabBarSegue
        }
        
        applyAppearance()
    }
    
    private func applyAppearance() {
        UINavigationBar.appearance().barStyle = .Default
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.downLightGreyColor()]
        UINavigationBar.appearance().tintColor = UIColor.downDarkGreyColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.downDarkGreyColor()], forState: .Normal)
        
        var lightColor = UIColor.clearColor()
        var darkColor = UIColor.clearColor()
        switch selectedTab {
        case .SabNZBd:
            lightColor = UIColor.downSabNZBdColor()
            darkColor = UIColor.downSabNZBdDarkColor()
            break
        case .Sickbeard:
            lightColor = UIColor.downSickbeardColor()
            darkColor = UIColor.downSickbeardDarkColor()
            break
        case .CouchPotato:
            lightColor = UIColor.downCouchPotatoColor()
            darkColor = UIColor.downCouchPotatoDarkColor()
            break
        }
        
//        window.statusBarBackgroundColor = darkColor
        UINavigationBar.appearance().barTintColor = lightColor
        UINavigationBar.appearance().backgroundColor = lightColor
        
        tabButtons.forEach { button in
            let buttonIndex = tabButtons.indexOf(button)!
            button.backgroundColor = buttonIndex == selectedTab.tabIndex ? darkColor : lightColor
        }
    }
    
}
