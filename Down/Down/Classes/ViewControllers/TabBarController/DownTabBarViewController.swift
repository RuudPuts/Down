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
    var selectedTabIndex = 0
    
    enum TabBarSegues: String {
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
            performSegueWithIdentifier(TabBarSegues.SabNZBd.rawValue, sender: tabButtons.first)
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
        let color: UIColor
        
        switch selectedTabIndex {
        case 0:
            color = .downSabNZBdDarkColor()
            break
        case 1:
            color = .downSickbeardDarkColor()
            break
        case 2:
            color = .downCouchPotatoDarkColor()
            break
        default:
            color = .blackColor()
            break
        }
        
        return color
    }
    
    var deselectedTabColor: UIColor {
        let color: UIColor
        
        switch selectedTabIndex {
        case 0:
            color = .downSabNZBdColor()
            break
        case 1:
            color = .downSickbeardColor()
            break
        case 2:
            color = .downCouchPotatoColor()
            break
        default:
            color = .blackColor()
            break
        }
        
        return color
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SabNZBdTab" {
            
        }
        else if segue.identifier == "SickbeardTab" {
            
        }
        else if segue.identifier == "CouchPotatoTab" {
            
        }
    }
    
    private func applyAppearance() {
        UINavigationBar.appearance().barStyle = .Default
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.downLightGreyColor()]
        UINavigationBar.appearance().tintColor = UIColor.downDarkGreyColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.downDarkGreyColor()], forState: .Normal)
        
        var darkColor = UIColor.clearColor()
        var lightColor = UIColor.clearColor()
        switch selectedTabIndex {
        case 0:
            darkColor = UIColor.downSabNZBdColor()
            lightColor = UIColor.downSabNZBdDarkColor()
            break
        case 1:
            darkColor = UIColor.downSickbeardColor()
            lightColor = UIColor.downSickbeardDarkColor()
            break
        case 2:
            darkColor = UIColor.downCouchPotatoColor()
            lightColor = UIColor.downCouchPotatoDarkColor()
            break
        default:
            break
        }
        
        window.statusBarBackgroundColor = darkColor
        UINavigationBar.appearance().barTintColor = lightColor
        UINavigationBar.appearance().backgroundColor = lightColor
    }
    
}
