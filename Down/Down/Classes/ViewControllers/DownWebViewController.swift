//
//  DownWebViewController.swift
//  Down
//
//  Created by Ruud Puts on 08/02/17.
//  Copyright © 2017 Ruud Puts. All rights reserved.
//

import UIKit
import WebKit

class DownWebViewController: DownViewController {
    
    var url: URL?
    var webView = WKWebView()
    
    var rightBarButton: UIBarButtonItem = UIBarButtonItem()
    var rightBarButtonTitle: String?
    var rightButtonTouchHandler: ((Void) -> (Void))?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebview()
        setRightBarButton(spinning: webView.isLoading)
    }
    
    func loadWebview() {
        view = webView
        webView.scrollView.backgroundColor = .downDarkGrayColor()
        webView.navigationDelegate = self
        
        if let url = url {
            webView.load(URLRequest(url: url))
        }
    }
    
    func loadBarButtonItem() {
        navigationItem.rightBarButtonItem = rightBarButton
        rightBarButton.title = rightBarButtonTitle
        
        rightBarButton.target = self
        rightBarButton.action = #selector(rightBarButtonTapped)
    }
    
    func rightBarButtonTapped() {
        guard let touchHandler = rightButtonTouchHandler else {
            return
        }
        
        touchHandler()
    }
    
    func setRightBarButton(spinning: Bool) {
        if spinning {
            let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            spinner.startAnimating()
            rightBarButton.customView = spinner
        }
        else {
            rightBarButton = UIBarButtonItem()
        }
        rightBarButton.isEnabled = !spinning
        loadBarButtonItem()
    }
}

extension DownWebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        NSLog("didStartProvisionalNavigation \(navigation)")
        setRightBarButton(spinning: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        NSLog("didFinish \(navigation)")
        setRightBarButton(spinning: false)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        NSLog("didFail \(navigation) - \(error)")
        setRightBarButton(spinning: false)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        NSLog("didFailProvisionalNavigation \(navigation) - \(error)")
        setRightBarButton(spinning: false)
    }
    
}
