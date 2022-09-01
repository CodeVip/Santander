

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
        
        let baseURL =  DPConfigClass.sharedInstance.baseURL
        var url = URL(string:api)
//        if api == "v2/credit_card/create"{
//            url = URL(string: "https://stage.wepayapi.com/" + api)
//        }else{
//            url = URL(string: baseURL + api)
//        }
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
        
        
        if view != nil  {
            DPLoader.show(InView:view, message)
        }else {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
        }
        debugPrint("\n\n ==========\n CURL REQUEST  ==== \n \((request as URLRequest).curlString)  \n =========== \n")
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            DispatchQueue.main.async {
                if view != nil  {
                    DPLoader.dismiss(InView:view)
                }else {
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                }
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
        if apiname ==  APIName.getSchoolType  ||
            apiname == APIName.getParentType ||
            apiname == APIName.getClasses ||
            apiname == APIName.getStaffs ||
            apiname == APIName.getStudents ||
            apiname == APIName.getParents  ||
            apiname == APIName.moduleMenuMobile  ||
            apiname == APIName.staffDashboard    ||
            apiname == APIName.getAdminDashBoardMobile   ||
            apiname == APIName.parentDashboard  ||
            apiname == APIName.country  ||
            apiname == APIName.state  ||
            apiname == APIName.city  ||
            apiname == APIName.getLanguages ||
            apiname == APIName.getAdminDashBoardMobile ||
            apiname == APIName.parentDashboard ||
            apiname == APIName.staffDashboard ||
            apiname == APIName.appUpdateVersion
        {
            return false
        }
        return true
    }
    
    public class  func multiPart(request:NSMutableURLRequest,apibody:NSMutableDictionary) -> NSMutableURLRequest {
        let boundary = "---------------------------14737809831466499882746641449"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let body = NSMutableData()
        debugPrint(apibody.allKeys)
        for key in apibody.allKeys {
            if apibody[key as! String]!  is NSString {
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition:form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append("\(apibody[key as! String]!)\r\n".data(using: String.Encoding.utf8)!)
                
            }
            else if apibody[key as! String]!  is NSNumber {
                
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition:form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append("\(apibody[key as! String]!)\r\n".data(using: String.Encoding.utf8)!)
                
            }
            else if apibody[key as! String]! is UIImage {
                
                let image = apibody[key as! String] as! UIImage
                let imageData = image.jpegData(compressionQuality: 0.1)
                //let imageData = UIImageJPEGRepresentation(apibody[key as! String] as! UIImage, 0.3)
                if imageData == nil {
                    break;
                }
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition:form-data; name=\"\(key)\"; filename=\"a.jpg\"\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Type: \("image/jpeg")\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append(imageData!)
                body.append("\r\n".data(using: String.Encoding.utf8)!)
            }else if apibody[key as! String]! is [UIImage] {
                for image in (apibody[key as! String] as! [UIImage]) {
                    let imageData = image.jpegData(compressionQuality: 0.1)
                    if imageData == nil {
                        break;
                    }
                    body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                    body.append("Content-Disposition:form-data; name=\"\(key)\"; filename=\"a.jpg\"\r\n".data(using: String.Encoding.utf8)!)
                    body.append("Content-Type: \("image/jpeg")\r\n\r\n".data(using: String.Encoding.utf8)!)
                    body.append(imageData!)
                    body.append("\r\n".data(using: String.Encoding.utf8)!)
                }
            }
            
            else if apibody[key as! String]! is NSData {
                if key as! String == APIKeyName.file { // image upload
                    
                }
                let imageData = apibody[key as! String] as! NSData
                
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition:form-data; name=\"\(key)\"; filename=\"a.png\"\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Type: \("image/png")\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append(imageData as Data)
                body.append("\r\n".data(using: String.Encoding.utf8)!)
            }else if ((key as! String).contains(".roleId") == true) && (apibody[key as! String]! as? [String] != nil ){
                let values = apibody[key as! String] as! [String]
                for value in values {
                    body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                    body.append("Content-Disposition:form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                    body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
                }
            }else if ((key as! String).contains(".roleId") == true) && (apibody[key as! String]! as? [Int] != nil ){
                let values = apibody[key as! String] as! [Int]
                for value in values {
                    body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                    body.append("Content-Disposition:form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                    body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
                }
            } else if let media = apibody[key as! String] as? [[String:Any]] {
                //communication passed from chat(image and documents)
                for object in media {
                    if let fileData = object["mediaData"] as? Data {
                        
//                        if let mimeType = Swime.mimeType(data: fileData) {
//                            
//                            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
//                            body.append("Content-Disposition:form-data; name=\"\(key)\"; filename=\"\(object["mediaName"] as! String).\(object["mediaExt"] as! String)\"\r\n".data(using: String.Encoding.utf8)!)
//                            body.append("Content-Type: \(mimeType.mime)\r\n\r\n".data(using: String.Encoding.utf8)!)
//                            body.append(fileData)
//                            body.append("\r\n".data(using: String.Encoding.utf8)!)
//                        }
                        
                    }
                }
            }
        }
        
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        request.httpBody = body as Data
        return request
        
    }
    
    class func header(request: NSMutableURLRequest, apiName: String, body: NSMutableDictionary? = nil) -> NSMutableURLRequest {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if apiName != APIName.authToken && apiName != APIName.getSchoolType && apiName != APIName.schoolSignUp && apiName != APIName.forgotPassword && apiName != APIName.setPassword && apiName != APIName.joinASchool && apiName != APIName.appUpdateVersion {
            let username = kUserDefults_(DPKeysProject.username) as? String
            let password = kUserDefults_(DPKeysProject.password) as? String
            let loginString = String(format: "%@:%@", username ?? "", password ?? "")
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64AuthTokenString = loginData.base64EncodedString()
            request.setValue("Basic \(base64AuthTokenString)", forHTTPHeaderField: "Authorization")
        }
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
    
      class func checkMultipart(_ apibody:NSMutableDictionary) -> Bool {
        
        for key in apibody.allValues
        {
            if key is UIImage || key is URL || key is NSData || key is Data {
                return true
            }
        }
        return false
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
            
            //loader.lblMessage.text = message
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







