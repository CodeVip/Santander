//
//  File.swift
//  
//
//  Created by Vipin Chaudhary on 01/09/22.
//

import Foundation
import UIKit
import WebKit
import CoreNFC

public class FrameworkClass:NSObject
{
    let viewModel1 = ViewModel()
    var containerView = UIView()
    public var isLoaderEnable:Bool = false
    public var isLoggingEnabled:Bool = false
    public var localization:String = ""
    public var isWebview:Bool = false
    public var webViewURL:String = ""
    var session: NFCNDEFReaderSession?
  public  var callback: ((_ id: Int64) -> Void)?
      // var productStore = ProductStore.shared
   var view1:UIViewController?
    
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
    
    public func readCard(view:UIViewController){
//        let viewCont = ViewController()
//        viewCont.beginReadSeesion()
        
        guard session == nil else {
                   return
               }
               session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
               session?.alertMessage = "Hold your iPhone near the item to learn more about it."
               session?.begin()
        view1 = view
        
    }
    
    
 public func APICll(baseUrl:String,body:NSMutableDictionary?,view:UIViewController,completion:@escaping (Bool,Int)->()){
    if isLoaderEnable {
        DPLoader.show(InView: view.view.self, "Loading")
    }
    // Call to the view model for api
     viewModel.calToFetchData(baseUrl: baseUrl,body:body)
    
     // suceess with data
    viewModel.callBackToView = {
       
    
        if self.isWebview{
            if let url = URL(string: self.webViewURL + self.viewModel.welData.data.web_url){
                
                    DispatchQueue.main.async {
                        self.fullScreen(view: view, url:url,containerView:self.containerView)
                    }
                
            }
            
        }else{
            
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
        }

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
    
    
 public func CardActivation(baseUrl:String,body:NSMutableDictionary?,view:UIViewController,completion:@escaping (Bool,String)->()){
    if isLoaderEnable {
        DPLoader.show(InView: view.view.self, "Loading")
    }
    // Call to the view model for api
     viewModel.calToActivateCard(baseUrl: baseUrl,body:body)
    
     // suceess with data
     viewModel.callBackForCardStatusToView = {
       
        self.dismissLoader(view: view)
         completion(true, self.viewModel.CardStat.message)
        
      }
     
     /// failure with error
     viewModel.callBackToViewServerError = {
         completion(false,"Error")
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

extension FrameworkClass:NFCNDEFReaderSessionDelegate{
    public func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        
    }
    
    /// - Tag: processingTagData
//    public func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
//        
//        guard
//            let ndefMessage = messages.first,
//            let record = ndefMessage.records.first,
//            record.typeNameFormat == .absoluteURI || record.typeNameFormat == .nfcWellKnown,
//            let payloadText = String(data: record.payload, encoding: .utf8),
//            let sku = payloadText.split(separator: "/").last else {
//            return
//        }
//        
//        
//        self.session = nil
//        
////        guard let product = productStore.product(withID: String(sku)) else {
////            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
////                let alertController = UIAlertController(title: "Info", message: "SKU Not found in catalog",preferredStyle: .alert)
////                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
////                // view1!.view.present(alertController, animated: true, completion: nil)
////            }
////            return
////        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
//            //  self?.presentProductViewController(product: product)
//        }
//    }
    
    
    @available(iOS 13.0, *)
    public func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        let str: String = viewModel1.theActualData
        if tags.count > 1 {
            let retryInterval = DispatchTimeInterval.microseconds(500)
            session.alertMessage = "More than one tag found, Please remove them and try again"
            DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval) {
                session.restartPolling()
            }
            return
        }
        let tag = tags.first!
        session.connect(to: tag) { error in
            if nil != error {
                session.alertMessage = "Unable to connect tag"
                session.invalidate()
                return
            }
            tag.queryNDEFStatus { nfcStatus, capacity, error in
                guard error == nil else {
                    session.alertMessage = "Unable to query NDEF Status of tag"
                    session.invalidate()
                    return
                }
                switch nfcStatus {
                case .notSupported:
                    session.alertMessage = "tag is not NDEF Complain"
                    session.invalidate()
                case .readOnly:
                    session.alertMessage = "This tag is locked"
                    session.invalidate()
                case .readWrite:
                    if self.viewModel1.isReadTag || self.viewModel1.isActivateCard {
                        tag.readNDEF { message, error in
                            if nil != error {
                                session.alertMessage = "Read NDEF Message failed"
                            } else {
                                guard let msg = message else { return }
                                session.alertMessage = "Nice, This tag has been read"
                                for recordIndex in 0 ..< msg.records.count {
                                    let record = msg.records[recordIndex]
                                    if let identifire = record.identifier.toStr() {
                                        print(identifire)
                                    }
                                    if let type = record.type.toStr() {
                                        print(type)
                                    }
                                    if let payload = record.payload.toStr() {
                                        let arr = payload.split(separator: "?")
                                        for item in arr {
                                            if item.contains("cardId") {
                                                if !self.viewModel1.isActivateCard {
                                                    let arr = item.split(separator: "=")
                                                    self.viewModel1.cardid = String(arr[1])
                                                    
                                                    self.callback?(Int64(arr[1]) ?? 10)
//                                                    self.viewModel1.checkforTheActivation(completion: { [self] (data, err) in
//                                                        if err == nil {
//                                                           // self.alertMessage(title: "", subtitle: self.viewModel1.parsersponseData(data!))
//                                                        } else {
//                                                            //self.alertMessage(title: "Opps", subtitle: err!.localizedDescription)
//                                                        }
//                                                    })
                                                } else {
                                                   // self.alertMessage(title: "Card Data", subtitle: String(item))
                                                }
                                                break
                                            }
                                        }
                                    }
                                }
                            }
                            session.invalidate()
                        }
                    } else {
                        guard var urlComponent = URLComponents(string: "https://neobank.ntldigital.com") else {
                            print("Won't be able to convert string to URL")
                            return
                        }
                        urlComponent.queryItems = [URLQueryItem(name: "cardId", value: str)]
                        let record = NFCNDEFPayload.wellKnownTypeURIPayload(url: urlComponent.url!)!
                        
                        
                        
                        let payload =  NFCNDEFPayload(
                                                     format: .nfcExternal,
                                                     type: "M".data(using: .utf8)!,
                                                     identifier: "".data(using: .utf8)!,
                                                     payload: "https://neobank.ntldigital.com?cardId=1234".data(using: .utf8)!
                                                 )
                        
                        let payload1 =  NFCNDEFPayload(
                                                     format: .media,
                                                     type: "M".data(using: .utf8)!,
                                                     identifier: "".data(using: .utf8)!,
                                                     payload: "https://neobank.ntldigital.com?cardId=1234".data(using: .utf8)!
                                                 )
                        
                        
//                        tag.writeNDEF(.init(records: [payload, payload1, record])) { error in
//                            if nil != error {
//                                session.alertMessage = "Write NDEF Message failed"
//                            } else {
//                                session.alertMessage = "Nice, This tag has been activated"
//                                print("Well Done, tag value updated...")
//                            }
//                            session.invalidate()
//                        }
//                        let uriPayloadFromURL = NFCNDEFPayload.wellKnownTypeURIPayload(
//                                   url: urlComponent.url!
//                                )!
//
//                        tag.writeNDEF(.init(records: [payload,payload1,uriPayloadFromURL])) { error in
//                            if nil != error {
//                                session.alertMessage = "Write NDEF Message failed"
//                            } else {
//                                session.alertMessage = "Nice, This tag has been activated"
//                                 print("Well Done, tag value updated...")
//                            }
//                            session.invalidate()
//                        }
                        
                        let messge = NFCNDEFMessage.init(records: [record])
                        tag.writeNDEF(messge) { error in
                            if error != nil {
                                session.invalidate(errorMessage: "Failed to write message.")
                            } else {
                                session.alertMessage = "Successfully configured tag."
                                session.invalidate()
                            }
                        }

                    }
                default:
                    session.alertMessage = "unknown error"
                }
            }
        }
    }
    
    /// - Tag: endScanning
    public func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        // Check the invalidation reason from the returned error.
        if let readerError = error as? NFCReaderError {
            // Show an alert when the invalidation reason is not because of a success read
            // during a single tag read mode, or user canceled a multi-tag read mode session
            // from the UI or programmatically using the invalidate method call.
            if (readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead)
                && (readerError.code != .readerSessionInvalidationErrorUserCanceled) {
                let alertController = UIAlertController(
                    title: "Session Invalidated",
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                DispatchQueue.main.async {
                    //  self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
        // A new session instance is required to read new tags.
        self.session = nil
    }
}
