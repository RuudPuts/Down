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
        case welcome
        case sickbeardCacheRefresh
    }
    
    var introType: IntroType!
    
    @IBOutlet weak var searchingContainer: UIView!
    @IBOutlet weak var startButton: UIButton!
    
    convenience init(introType: IntroType) {
        self.init(nibName: "DownWelcomeViewController", bundle: nil)
        
        self.introType = introType
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        window.statusBarBackgroundColor = .downRedColor()
//    }
    
    @IBAction func actionButtonPressed(_ sender: AnyObject) {
        startButton.isHidden = true
        searchingContainer.isHidden = false
        
        let portScanner = RPPortScanner()
        portScanner.delegate = self
        portScanner.scanPorts(SabNZBdService.defaultPorts + SickbeardService.defaultPorts + CouchPotatoService.defaultPorts)
    }
    
    // MARK - RPPortScannerDelegate
    
    func portScanner(_ portScanner: RPPortScanner, didFindPort port: Int, onIPAddress ipAddress: String) {
        let url = URL(string: "http://\(ipAddress):\(port)")
        
        guard let host = url else {
            return
        }
        
        switch port {
        case _ where SabNZBdService.defaultPorts.contains(port):
            SabNZBdConnector().validateHost(host, completion: { hostValid, apiKey in
                Log.i("Validated sabNZBd host \(host) - \(hostValid) - \(apiKey ?? "Api key not found")")
                
                if hostValid {
                    if Preferences.sabNZBdHost.length == 0 {
                        // No host set yet, save it all
                        Preferences.sabNZBdHost = host.absoluteString
                        Preferences.sabNZBdApiKey = apiKey ?? ""
                    }
                    else if Preferences.sabNZBdApiKey.length == 0, let apiKey = apiKey, apiKey.length > 0 {
                        // Host with valid API key found, replace
                        Preferences.sabNZBdHost = host.absoluteString
                        Preferences.sabNZBdApiKey = apiKey
                    }
                }
            })
            break
        case _ where SickbeardService.defaultPorts.contains(port):
            SickbeardConnector().validateHost(host, completion: { hostValid, apiKey in
                Log.i("Validated Sickbeard host \(host) - \(hostValid) - \(apiKey ?? "Api key not found")")
                
                if hostValid {
                    if Preferences.sickbeardHost.length == 0 {
                        // No host set yet, save it all
                        Preferences.sickbeardHost = host.absoluteString
                        Preferences.sickbeardApiKey = apiKey ?? ""
                    }
                    else if Preferences.sickbeardApiKey.length == 0, let apiKey = apiKey, apiKey.length > 0 {
                        // Host with valid API key found, replace
                        Preferences.sickbeardHost = host.absoluteString
                        Preferences.sickbeardApiKey = apiKey
                    }
                }
            })
            break
        case _ where CouchPotatoService.defaultPorts.contains(port):
//            CouchPotatoConnector().validateHost(host, completion: { hostValid, apiKey in
//                Log.i("Validated CouchPotato host \(host) - \(hostValid) - \(apiKey)")
//            })
            break
            
        default:
            break
        }
    }
    
    func portScannerDidFinish(_ portScanner: RPPortScanner!) {
        let settingsViewController = DownSettingsViewController(application: .SabNZBd)
        settingsViewController.delegate = self
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    // MARK: - DownSettingsViewController
    
    func settingsViewControllerDidTapActionButton(_ viewController: DownSettingsViewController) {
        if viewController.application == .SabNZBd {
            let settingsViewController = DownSettingsViewController(application: .Sickbeard)
            settingsViewController.delegate = self
            navigationController?.pushViewController(settingsViewController, animated: true)
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
