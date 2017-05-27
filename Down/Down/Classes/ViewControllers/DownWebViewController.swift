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
    
    var rightBarButton = DownBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebview()
        
        rightBarButton.isSpinning = webView.isLoading
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func loadWebview() {
        view = webView
        webView.scrollView.backgroundColor = .downDarkGrayColor()
        webView.navigationDelegate = self
        
        if let url = url {
            webView.load(URLRequest(url: url))
        }
    }
}

extension DownWebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        rightBarButton.isSpinning = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        rightBarButton.isSpinning = false
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        rightBarButton.isSpinning = false
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        rightBarButton.isSpinning = false
    }
    
}
