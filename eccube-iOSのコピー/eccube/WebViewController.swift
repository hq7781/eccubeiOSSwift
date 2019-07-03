//
//  WebViewController.swift
//  eccube
//
//  Created by 洪 権 on 2019/07/02.
//  Copyright © 2019 hq7781@gmail.com. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    var initialPath: String?
    var webView : WKWebView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUIView()
    }
    func setUIView() {
        var url: URL?
        if let path = self.initialPath, path.count > 0 {
            url = URL(string: Config.baseUrl)
        }
        self.webView.configuration.preferences.setValue(true, forKey:
            "allowFileAccessFromFileURLs")
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.webView.frame = self.view.bounds
        self.view.addSubview(self.webView)
        self.webView.load(URLRequest(url:url ?? URL(string: Config.baseUrl)!))
    }
}

//

// MARK - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(WKNavigationActionPolicy.allow)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(WKNavigationResponsePolicy.allow)
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.setEccubeJs()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }

    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("webView didReceive challenge")
        guard let hostname = webView.url?.host else {
            return
        }
        
        let authenticationMethod = challenge.protectionSpace.authenticationMethod
        if authenticationMethod == NSURLAuthenticationMethodDefault || authenticationMethod == NSURLAuthenticationMethodHTTPBasic || authenticationMethod == NSURLAuthenticationMethodHTTPDigest {
            let av = UIAlertController(title: webView.title, message: String(format: "AUTH_CHALLENGE_REQUIRE_PASSWORD", hostname), preferredStyle: .alert)
            av.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "USER_ID" //.localized
            })
            av.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "PASSWORD" //.localized
                textField.isSecureTextEntry = true
            })
            
            av.addAction(UIAlertAction(title: "OK", //.localized,
                                       style: .default, handler: { (action) in
                guard let userId = av.textFields?.first?.text else{
                    return
                }
                guard let password = av.textFields?.last?.text else {
                    return
                }
                let credential = URLCredential(user: userId, password: password, persistence: .none)
                completionHandler(.useCredential,credential)
            }))
            av.addAction(UIAlertAction(title: "CANCEL", //.localized,
                                       style: .cancel, handler: { _ in
                completionHandler(.cancelAuthenticationChallenge, nil);
            }))
            self.parent?.present(av, animated: true, completion: nil)
        }else if authenticationMethod == NSURLAuthenticationMethodServerTrust{
            // needs this handling on iOS 9
            completionHandler(.performDefaultHandling, nil);
        }else{
            completionHandler(.cancelAuthenticationChallenge, nil);
        }
    }

    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print("webViewWebContentProcessDidTerminate")
    }
}
// MARK - WKUIDelegate
extension WebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        return nil
    }

    func webViewDidClose(_ webView: WKWebView) {
        
    }

    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
    }

    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
    }

    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
    }
    
    func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
        return false
    }
    
    func webView(_ webView: WKWebView, previewingViewControllerForElement elementInfo: WKPreviewElementInfo, defaultActions previewActions: [WKPreviewActionItem]) -> UIViewController? {
        return nil
    }

    func webView(_ webView: WKWebView, commitPreviewingViewController previewingViewController: UIViewController){
        
    }
}

// MARK - for eccube
extension WebViewController {
    private func setEccubeJs() {
    
    }
}
