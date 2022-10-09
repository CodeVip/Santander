//
//  File.swift
//  
//
//  Created by Vipin Chaudhary on 01/09/22.
//

import Foundation
import UIKit
import WebKit

public class FrameworkClass
{
    var containerView = UIView()
    public var isLoaderEnable:Bool = false
    public var isLoggingEnabled:Bool = false
    public var localization:String = ""
    
    lazy var viewModel:SantanderViewModel! = {
        let service = HttpUtility()
        let viewModel = SantanderViewModel(service: service)
        return viewModel
    }()
    
    public init(isLoggingEnabled:Bool = false)
    {
     kUserDefults(isLoggingEnabled, key: "isLoggingEnabled")
    }
   
    public func Popup(view:UIViewController,errorMeaage:String){
        let anotherAlert = UIAlertController(title: "Error", message: errorMeaage, preferredStyle: .alert)
           let okAction = UIAlertAction(title: "OK", style: .default, handler: {action in
           })
           anotherAlert.addAction(okAction)
        view.present(anotherAlert, animated: true, completion: nil)
    }
    
    // MARK: Api call
    
    public func readCard(){
        let viewCont = ViewController()
        viewCont.beginReadSeesion()
        
    }
 public func APICll(baseUrl:String,body:NSMutableDictionary?,view:UIViewController,completion:@escaping (Bool,Int)->()){
    if isLoaderEnable {
        DPLoader.show(InView: view.view.self, "Loading")
    }
    // Call to the view model for api
     viewModel.calToFetchData(baseUrl: baseUrl,body:body)
    
     // suceess with data
    viewModel.callBackToView = {
       
        self.dismissLoader(view: view)
        
        switch self.viewModel.welData.data.status{
        case 1:
            print("")
            completion(true,1)
        case 2:
            print("")
            completion(true,2)
        case 3:
            print("")
            completion(true,3)
        case 4:
            print("")
            completion(true,4)
        default:
            print("g")
            completion(true,400)
        }
       // if let url = URL(string: self.viewModel.welData.support.url){
//        if let url = URL(string: "http://www.example.com"){
//              DispatchQueue.main.async {
//                 self.fullScreen(view: view, url:url,containerView:self.containerView)
//          }
//       }
      }
     
     /// failure with error
     viewModel.callBackToViewServerError = {
         completion(false,400)
         self.dismissLoader(view: view)
          DispatchQueue.main.async {
              self.Popup(view: view, errorMeaage: self.viewModel.errorToView.localizedDescription)
          }
     }
}

    func dismissLoader(view:UIViewController){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
         if self.isLoaderEnable {
           DPLoader.dismiss(InView: view.view)
          }
       }
    }
    
//    public func APICll(baseUrl:String,view:UIViewController,completion:@escaping (Bool)->()){
//        if isLoaderEnable {
//            DPLoader.show(InView: view.view.self, "Loading")
//        }
//
//        APICall.getInformation(url:URL(string:  baseUrl + APIName.getCardAuthorize)!,type: Welcome.self) { [self]  result in
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                if self.isLoaderEnable {
//                DPLoader.dismiss(InView: view.view)
//                }
//            }
//            switch result{
//            case .success(let data):
//                print(data.data.name)
//                print(data.support.url)
//                Log.d("\(data)")
//                if let url = URL(string: data.support.url){
//                    DispatchQueue.main.async {
//                        self.fullScreen(view: view, url:url,containerView:self.containerView)
//                    }
//                }
//                completion(true)
//            case .failure(let error):
//                print(error)
//                Log.e("\(error.localizedDescription)")
//                completion(false)
//                DispatchQueue.main.async {
//                    self.Popup(view: view, errorMeaage: error.localizedDescription)
//                }
//            }
//        }
//    }
}
