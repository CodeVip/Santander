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
    var containerView = UIView()
   public var isLoaderEnable:Bool = false
    
    public init()
    {
    }
   
    public func Popup(view:UIViewController,errorMeaage:String){
        let anotherAlert = UIAlertController(title: "Error", message: errorMeaage, preferredStyle: .alert)
           let okAction = UIAlertAction(title: "OK", style: .default, handler: {action in
//                  let nextAlert = UIAlertController(title: "Second one", message: "The Previous one is dismissed", preferredStyle: .alert)
//               let okAction1 = UIAlertAction(title: "OK", style: .default, handler: {action in
//
//               })
//               nextAlert.addAction(okAction1)
//               view.present(nextAlert, animated: true, completion: nil)
           })
           anotherAlert.addAction(okAction)
        view.present(anotherAlert, animated: true, completion: nil)
    }
    
    // MARK: Api call
    
    public func APICll(baseUrl:String,view:UIViewController,completion:@escaping (Bool)->()){
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
                        self.fullScreen(view: view, url:url,containerView:self.containerView)
                    }
               
                }
                completion(true)
            case .failure(let error):
                print(error)
               completion(false)
                DispatchQueue.main.async {
                    self.Popup(view: view, errorMeaage: error.localizedDescription)
                }
                
            }
        }
    }
}
