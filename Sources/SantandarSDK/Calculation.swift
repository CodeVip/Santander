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
    var isLoaderEnable:Bool = false
    var containerView = UIView()
    public init()
    {
    }
   
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
    
    public func fullScreen(view:UIViewController, url:URL,containerView:UIView)  {
   
   containerView.frame = CGRect(x: 10, y: 40, width: view.view.frame.width-20, height: view.view.frame.height-80)
   containerView.backgroundColor = UIColor.gray
    containerView.layer.cornerRadius = 8
    // MARK: button
    let button = UIButton(frame: CGRect(x: 40, y: view.view.frame.height - 160, width: view.view.frame.width - 80, height: 50))
    button.backgroundColor = .blue
    button.layer.cornerRadius = 8
    button.setTitle("Submit button", for: .normal)
    
        button.addTarget(self, action: #selector(FrameworkClass().buttonAction), for: .touchUpInside)
 
    let webV:UIWebView = UIWebView(frame: CGRect(x: 10, y: 10, width: containerView.frame.width - 20, height: view.view.frame.height-200))
    webV.backgroundColor = .red
    webV.layer.cornerRadius = 8
    webV.loadRequest(URLRequest(url: url))
    
    containerView.addSubview(webV)
    containerView.addSubview(button)
    view.view.addSubview(containerView)

  }
    
   @objc func buttonAction(){
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
        if isLoaderEnable {
            DPLoader.show(InView: view.view.self, "Loading")
        }

        APICall.getInformation(url:URL(string:  baseUrl + APIName.getCardAuthorize)!,type: Welcome.self) { [self]  result in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if self.isLoaderEnable {
                DPLoader.dismiss(InView: view.view)
                }
            }
            switch result{
            case .success(let data):
                print(data.data.name)
                print(data.support.url)
                if let url = URL(string: data.support.url){
                    DispatchQueue.main.async {
                        self.fullScreen(view: view, url:url, containerView: self.containerView)
                    }
               
                }
            case .failure(let error):
                print(error)
                
            }
        }
       
//        APICall.getCardInfo(view: nil, apiName: baseUrl + APIName.getCardAuthorize, apiCallTimeKeyName: "", dictionary: [:]) { isSucess, responseCode, message, response in
//            print("Response loader")
//            DPLoader.dismiss(InView: view.view)
//            if isSucess {
//
//            }else{
//
//            }
//        }
    }
    
}
