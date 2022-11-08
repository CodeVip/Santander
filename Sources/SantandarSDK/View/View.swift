//
//  File.swift
//  
//
//  Created by Vipin Chaudhary on 04/09/22.
//

import Foundation
import UIKit
import WebKit
extension FrameworkClass:WKScriptMessageHandler{
   
    public func fullScreen(view:UIViewController, url:URL,containerView:UIView)  {
   // View creation
   containerView.frame = CGRect(x: 5, y: 5, width: view.view.frame.width-10, height: view.view.frame.height-10)
   containerView.backgroundColor = UIColor.gray
    containerView.layer.cornerRadius = 8
    // MARK: button
    let button = UIButton(frame: CGRect(x: 40, y: view.view.frame.height - 160, width: view.view.frame.width - 80, height: 50))
    button.backgroundColor = .blue
    button.layer.cornerRadius = 8
       // NSLocalizedString("Submit_button".localizableString(loc: "en"), comment: "")
        let text = "Submit_button".localizableString(loc: localization)
        
    button.setTitle(text, for: .normal)
    button.addTarget(self, action: #selector(FrameworkClass().buttonAction), for: .touchUpInside)
 
    /// webview 
    let webV:UIWebView = UIWebView(frame: CGRect(x: 10, y: 10, width: containerView.frame.width - 20, height: view.view.frame.height-200))
    webV.backgroundColor = .clear
    webV.layer.cornerRadius = 8
    webV.loadRequest(URLRequest(url: url))
    
    containerView.addSubview(webV)
    containerView.addSubview(button)
    view.view.addSubview(containerView)
        
        let config = WKWebViewConfiguration()
           config.userContentController = WKUserContentController()
           config.userContentController.add(self, name: "backHomePage")

           let webView = WKWebView(frame: CGRect(x: 10, y: 10, width: containerView.frame.width - 20, height: view.view.frame.height-200))

          // view.addSubview(webView)

//           webView.load(URLRequest(url: url))
//        containerView.addSubview(webView)
//        containerView.addSubview(button)
//        view.view.addSubview(containerView)

  }
    
    //MARK: Button
    @objc func buttonAction(){
        containerView.removeFromSuperview()
    }
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
       print(message.body)
     }
}
