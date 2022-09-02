//
//  File.swift
//  
//
//  Created by Mohit Sharma on 01/09/22.
//

import Foundation
import UIKit
import WebKit
public class FrameworkClass
{
    public init()
    {
    }
    var containerView = UIView()
    public func Popup(view:UIViewController){
        let anotherAlert = UIAlertController(title: "New One", message: "The Previous one is dismissed", preferredStyle: .alert)
           let okAction = UIAlertAction(title: "OK", style: .default, handler: {action in
                  let nextAlert = UIAlertController(title: "Second one", message: "The Previous one is dismissed", preferredStyle: .alert)
               let okAction1 = UIAlertAction(title: "OK", style: .default, handler: {action in

               })
               nextAlert.addAction(okAction1)
               view.present(nextAlert, animated: true, completion: nil)
           })
           anotherAlert.addAction(okAction)
        view.present(anotherAlert, animated: true, completion: nil)
    }
    
    public func fullScreen(view:UIViewController)  {
       
        containerView.frame = CGRect(x: 10, y: 10, width: view.view.frame.width-20, height: view.view.frame.height-20)
        containerView.backgroundColor = UIColor.gray
        let button = UIButton(frame: CGRect(x:  50, y: 50, width: Int(view.view.frame.width) - 100, height: 50))
        button.backgroundColor = .blue
        button.setTitle("dismiss", for: .normal)
        button.addTarget(view, action: #selector(dismiss), for: .touchUpInside)
        let  webView = WKWebView()
       // webView.navigationDelegate = self
        containerView = webView

        let url = URL(string: "https://www.earthhero.org")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        containerView.addSubview(webView)
        containerView.addSubview(button)
        view.view.addSubview(containerView)

    }
    @objc func dismiss(){
        containerView.removeFromSuperview()
    }
    public func addDouble( left:Double, right:Double ) -> Double
    {
        let sum = left + right
        
        #if DEBUG
            print("\(left) + \(right) = \(sum)")
        #endif
        
        return sum
    }
    
    public func add( left:Int, right:Int ) -> Int
    {
        let sum = left + right
        
        #if DEBUG
            print("\(left) + \(right) = \(sum)")
        #endif
        
        return sum
    }
    
    public func subtract( left:Int, right:Int ) -> Int
    {
        let remainder = left - right
        
        #if DEBUG
            print("\(left) - \(right) = \(remainder)")
        #endif
        
        return remainder
    }
    
    public func multiply( left:Int, right:Int ) -> Int
    {
        let multiple = left * right
        
        #if DEBUG
            print("\(left) * \(right) = \(multiple)")
        #endif
        
        return multiple
    }
 
    
    // MARK: Api call
    
    public func APICll(baseUrl:String,view:UIViewController){
        DPLoader.show(InView: view.view.self, "Loading")
       
        APICall.getCardInfo(view: nil, apiName: baseUrl + APIName.getCardAuthorize, apiCallTimeKeyName: "", dictionary: [:]) { isSucess, responseCode, message, response in
            print("Response loader")
            DPLoader.dismiss(InView: view.view)
            if isSucess {
                
            }else{
                
            }
        }
    }
    
}
