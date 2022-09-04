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
   public var isLoaderEnable:Bool = false
    
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
                        webView().fullScreen(view: view, url:url)
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
