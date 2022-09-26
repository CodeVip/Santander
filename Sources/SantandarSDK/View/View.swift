//
//  File.swift
//  
//
//  Created by Vipin Chaudhary on 04/09/22.
//

import Foundation
import UIKit
extension FrameworkClass{
   
    public func fullScreen(view:UIViewController, url:URL,containerView:UIView)  {
   // View creation
   containerView.frame = CGRect(x: 10, y: 40, width: view.view.frame.width-20, height: view.view.frame.height-80)
   containerView.backgroundColor = UIColor.gray
    containerView.layer.cornerRadius = 8
    // MARK: button
    let button = UIButton(frame: CGRect(x: 40, y: view.view.frame.height - 160, width: view.view.frame.width - 80, height: 50))
    button.backgroundColor = .blue
    button.layer.cornerRadius = 8
       // NSLocalizedString("Submit_button".localizableString(loc: "en"), comment: "")
        let text = NSLocalizedString("Submit_button".localizableString(loc: localization), tableName: "Localizable", bundle: .module, value: localization, comment: "")
 //  let text1 = NSLocalizedString(
        
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

  }
    
    //MARK: Button
    @objc func buttonAction(){
        containerView.removeFromSuperview()
    }
    
}
