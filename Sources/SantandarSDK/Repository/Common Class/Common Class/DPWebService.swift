

import Foundation

import UIKit
import SystemConfiguration

protocol DPDownloadVideoDelegate:AnyObject {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64)
}


enum StatusCode: Int {
    case ok = 200
    case create = 201
    case accepted = 202
    case noContent = 204
    case badRequest = 400
    case unAuthorized = 401
    case forbidden = 403
    case noFound = 404
    case methodNotAllow = 405
    case userExist = 409
    case serverError = 500
    case unavailable = 503
    case requestTimeout = 408
}
public enum DPMethod : String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
    case COPY = "COPY"
    case HEAD = "HEAD"
    case OPTIONS = "OPTIONS"
    case LINK = "LINK"
    case UNLINK = "UNLINK"
    case PURGE = "PURGE"
    case LOCK = "LOCK"
    case UNLOCK = "UNLOCK"
}

class DPWebService: NSObject {
    fileprivate static let noInternet = DPValidation.dlkInternet
    fileprivate static let noServer = DPValidation.dlkServer
  
    /*
     1. View - if you pass view object than its show Indicater(loader)
     
     2. isUserInteractionEnabled if you pass true than view user inraction is enble if you pass false than view intraction disble true for (listing api) false for (login,signup, payment etc)
     
     3. api :- pass only last componant of api
     
     4. body :- parameter if not any parameter than pass nil
     
     5. returnFailedBlock :- it you pass false than error popup display ("no data found") no call back for status == false
     if you need to display data for failed staus than you must be pass true
     */

    class open func DPService (methodName:DPMethod, view:UIView?, isUserInteractionEnabled:Bool, returnFailedBlock:Bool,  api:String,message:String, body:NSMutableDictionary?,Handler complition:@escaping (_ JSON:NSDictionary,_ status:Int,_ message:String) -> Void) {
        
        if InternetCheck() == false {
            if returnFailedBlock == true {
                complition([:],StatusCode.serverError.rawValue,noInternet)
                return
            }
            UIAlertController.showAlertError(message:noInternet)
            return
        }
        var url = URL(string: api)
        debugPrint(url ?? "")
        
        let apiParameter = DPWebService.stringFromDictionary(apibody: body ?? [:])
        if (methodName == .GET) { //  || methodName == .DELETE)
            url = URL.init(string:"\(url!.absoluteString)\(apiParameter)".encodeUrl())
        }
        
        if url == nil {
            UIAlertController.showAlertError(message: "Please check URL its Just for Development")
            return
        }
        
        var request = NSMutableURLRequest(url: url!)
        let config = URLSessionConfiguration.default
        
        config.isDiscretionary          = true
        config.sessionSendsLaunchEvents = true
        let session = URLSession(configuration: config) //session.delegate = self
        request.httpMethod = methodName.rawValue
        request = DPWebService.header(request: request, apiName: api, body: body)
        let apibody = DPWebService.getBody(body: body, apiName: api)
        
            if methodName != .GET  { // && methodName != .DELETE
                let jsonData = try! JSONSerialization.data(withJSONObject: apibody, options: [])
                
                request.httpBody = jsonData
                debugPrint(NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String)
            }
        
       // debugPrint("\n\n ==========\n CURL REQUEST  ==== \n \((request as URLRequest).curlString)  \n =========== \n")
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            DispatchQueue.main.async {
                if data != nil {
                    let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    debugPrint("\n\n ==========\n Response - \(api)  : \n  \(strData!)  \n =========== \n")
                    do {
                        if let JSON = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            debugPrint("hello")
                            var message = "No message from Server side"
                            if let msg  = JSON["message"] as? String {
                                message = msg
                            }
                            
                            if JSON["status"] as? Int64 ?? 0 == StatusCode.unAuthorized.rawValue {
                                UIAlertController.showAlert(message: message, complition: {
                                })
                                return
                            }
                            
                            guard let httpResponse = response as? HTTPURLResponse else{return}
                            if httpResponse.statusCode == StatusCode.ok.rawValue{
                                if returnFailedBlock == false{
                                    if let isError = JSON["isError"] as? Bool{
                                        if isError{
                                            UIAlertController.showAlertError(message: message)
                                            return
                                        }
                                    }
                                }
                                complition(JSON,httpResponse.statusCode,message)
                                
                            }else{
                                
                                if returnFailedBlock == true {
                                    complition(JSON,StatusCode.serverError.rawValue,message)
                                    return
                                }else{
                                    if self.isErrorMessageDisplay(apiname: api) == true {
                                        UIAlertController.showAlertError(message: message)
                                    }
                                }
                            }
                        }
                    } catch {
                        if returnFailedBlock == true {
                            complition([:],StatusCode.serverError.rawValue,"Please contact to admin")
                            return
                        }
                        if self.isErrorMessageDisplay(apiname: api) == true {
                            UIAlertController.showAlertError(message:"Please contact to admin")
                        }
                    }
                } else {
                    if returnFailedBlock == true {
                        complition([:],StatusCode.serverError.rawValue,noServer)
                        return
                    }
                    if self.isErrorMessageDisplay(apiname: api) == true {
                        UIAlertController.showAlertError(message: noServer)
                    }
                }
            }
        })
        task.resume()
    }
    
    public static func isErrorMessageDisplay(apiname: String) -> Bool {
        if apiname ==  APIName.getCardAuthorize
        {
            return false
        }
        return true
    }
    
    class func header(request: NSMutableURLRequest, apiName: String, body: NSMutableDictionary? = nil) -> NSMutableURLRequest {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    class func getBody(body:NSMutableDictionary?, apiName: String) -> NSMutableDictionary{
        
        var apibody:NSMutableDictionary!
        if body == nil {
            apibody = NSMutableDictionary()
        }else{
            apibody = body!.mutableCopy() as? NSMutableDictionary
        }
        //Put Extra Common parameter here
        return apibody
    }
    
    class func stringFromDictionary(apibody:NSMutableDictionary) -> NSMutableString {
        
        let  apiParameter = NSMutableString()
        for key in apibody.allKeys {
            if apiParameter.length != 0 {
                apiParameter.append("&")
            }
            if apibody[key as! String]! is NSString {
                
                let str = apibody.value(forKey: key as! String)! as! String
                apibody[key as! String] = str.replacingOccurrences(of: "&", with: "%26")
            }else  if apibody[key as! String]! is NSNumber {
                apibody[key as! String] = "\(apibody.value(forKey: key as! String)!)"
            }
            apiParameter.append("\(key)=\(apibody[key as! String]!)")
            
        }
        return apiParameter
    }

    public class func showAlert(_ JSON:NSDictionary)  {
        
        var message = "No message from Server side"
        if let msg  = JSON["message"] as? String{
            message = msg
        }
        UIAlertController.showAlertError(message:message)
    }
}



//MARK: - FunctionDefination -
func InternetCheck () -> Bool {
    let reachability =  Reachability()
    let networkStatus  = reachability?.currentReachabilityStatus
    if networkStatus == .notReachable {
        return false
    }
    return true
}


//MARK:  - DPLoader Class -

class DPLoader : UIView {
    let blackView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        let activityIndicater = UIActivityIndicatorView()
        activityIndicater.style = .whiteLarge
        activityIndicater.color = UIColor.white
        activityIndicater.startAnimating()
        self.blackView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicater.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(blackView)
        blackView.addSubview(activityIndicater)
        blackView.backgroundColor = UIColor.black
        blackView.layer.cornerRadius = 4
        blackView.layer.masksToBounds = true
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
        self.addConstraint(NSLayoutConstraint.init(item: blackView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: blackView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
        blackView.addConstraint(NSLayoutConstraint.init(item: blackView, attribute: .height, relatedBy: .greaterThanOrEqual, toItem:nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 120))
        blackView.addConstraint(NSLayoutConstraint.init(item: blackView, attribute: .width, relatedBy: .greaterThanOrEqual, toItem:nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 120))
        blackView.addConstraint(NSLayoutConstraint.init(item: blackView, attribute: .height, relatedBy: .lessThanOrEqual, toItem:nil, attribute: .notAnAttribute, multiplier: 1.0, constant: UIScreen.main.bounds.width - 40))
        blackView.addConstraint(NSLayoutConstraint.init(item: blackView, attribute: .width, relatedBy: .lessThanOrEqual, toItem:nil, attribute: .notAnAttribute, multiplier: 1.0, constant: UIScreen.main.bounds.size.width - 40))
        blackView.addConstraint(NSLayoutConstraint.init(item: activityIndicater, attribute: .centerX, relatedBy: .equal, toItem: blackView, attribute: .centerX, multiplier: 1.0, constant: 0))
        blackView.addConstraint(NSLayoutConstraint.init(item: activityIndicater, attribute: .centerY, relatedBy: .equal, toItem: blackView, attribute: .centerY, multiplier: 1.0, constant: 0))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func show(InView:UIView?, _ message:String){
        
        DispatchQueue.main.async(execute: {
            if InView == nil{
                return
            }
            guard let loader = InView?.viewWithTag(1322) as? DPLoader else {
                
                let rect = CGRect.init(x: 0, y: 0, width: InView!.frame.width, height: InView!.frame.height )
                let loader = DPLoader.init(frame:rect)
                loader.tag = 1322
                InView?.addSubview(loader)
                return
            }
            
            loader.lblMessage.text = message
            loader.tag = 1322
            InView?.addSubview(loader)
        })
    }
    class func dismiss(InView:UIView?) {
        DispatchQueue.main.async {
            guard let loader = InView?.viewWithTag(1322) as? DPLoader else {return}
            loader.removeFromSuperview()
        }
        
    }
}







