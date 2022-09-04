//
//  File.swift
//  
//
//  Created by Mohit Sharma on 04/09/22.
//

import Foundation
import UIKit
public class webView{
    var containerView = UIView()
    public func fullScreen(view:UIViewController, url:URL,containerView:UIView)  {
   
   containerView.frame = CGRect(x: 10, y: 40, width: view.view.frame.width-20, height: view.view.frame.height-80)
   containerView.backgroundColor = UIColor.gray
    containerView.layer.cornerRadius = 8
    // MARK: button
    let button = UIButton(frame: CGRect(x: 40, y: view.view.frame.height - 160, width: view.view.frame.width - 80, height: 50))
    button.backgroundColor = .blue
    button.layer.cornerRadius = 8
    button.setTitle("Submit button", for: .normal)
    
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
 
    let webV:UIWebView = UIWebView(frame: CGRect(x: 10, y: 10, width: containerView.frame.width - 20, height: view.view.frame.height-200))
    webV.backgroundColor = .clear
    webV.layer.cornerRadius = 8
    webV.loadRequest(URLRequest(url: url))
    
    containerView.addSubview(webV)
    containerView.addSubview(button)
    view.view.addSubview(containerView)

  }
    
   @objc func buttonAction(){
       containerView.removeFromSuperview()
   }
    
}
