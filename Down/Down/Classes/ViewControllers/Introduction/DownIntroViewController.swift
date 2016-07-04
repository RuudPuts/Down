//
//  DownIntroViewController.swift
//  Down
//
//  Created by Ruud Puts on 21/12/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import DownKit

class DownIntroViewController: DownViewController, DownSettingsViewControllerDelegate, RPPortScannerDelegate {
    
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
        let portScanner = RPPortScanner()
        portScanner.delegate = self
        portScanner.scanPorts([SabNZBdService.defaultPort, SickbeardService.defaultPort, CouchPotatoService.defaultPort])
    }
    
    // MARK - RPPortScannerDelegate
    
    func portScanner(portScanner: RPPortScanner!, didFindPort port: Int, onIPAddress ipAddress: String!) {
        let host = "http://\(ipAddress):\(port)"
        switch port {
        case SabNZBdService.defaultPort:
            SabNZBdConnector().validateHost(host, completion: { hostValid, apiKey in
                NSLog("Validated sabNZBd host \(host) - \(hostValid) - \(apiKey)")
                
                if hostValid {
                    if PreferenceManager.sabNZBdHost.length == 0 {
                        // No host set yet, save it all
                        PreferenceManager.sabNZBdHost = host
                        PreferenceManager.sabNZBdApiKey = apiKey ?? ""
                    }
                    else if PreferenceManager.sabNZBdApiKey.length == 0 && apiKey?.length > 0 {
                        // Host with valid API key found, replace
                        PreferenceManager.sabNZBdHost = host
                        PreferenceManager.sabNZBdApiKey = apiKey!
                    }
                }
            })
            break
        case SickbeardService.defaultPort:
            SickbeardConnector().validateHost(host, completion: { hostValid, apiKey in
                NSLog("Validated Sickbeard host \(host) - \(hostValid) - \(apiKey)")
                
                if hostValid {
                    if PreferenceManager.sickbeardHost.length == 0 {
                        // No host set yet, save it all
                        PreferenceManager.sickbeardHost = host
                        PreferenceManager.sickbeardApiKey = apiKey ?? ""
                    }
                    else if PreferenceManager.sickbeardApiKey.length == 0 && apiKey?.length > 0 {
                        // Host with valid API key found, replace
                        PreferenceManager.sickbeardHost = host
                        PreferenceManager.sickbeardApiKey = apiKey!
                    }
                }
            })
            break
        case CouchPotatoService.defaultPort:
//            CouchPotatoConnector().validateHost(host, completion: { hostValid, apiKey in
//                NSLog("Validated CouchPotato host \(host) - \(hostValid) - \(apiKey)")
//            })
            break
            
        default:
            break
        }
    }
    
    func portScannerDidFinish(portScanner: RPPortScanner!) {
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