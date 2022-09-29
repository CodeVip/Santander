

import Foundation

import UIKit
import SystemConfiguration

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
 public enum CustomError:Error{
  case invalidUrl 
  case inValidData
}

class HttpUtility: NSObject {
    
  
    func postService<T:Codable>(methodName:DPMethod,url:URL?,type:T.Type,body:NSMutableDictionary?,completion: @escaping (Result<T,Error>)->Void){
        guard let url = url else{
            Log.e("Failed:\(CustomError.invalidUrl)")
            completion(.failure(CustomError.invalidUrl))
            
            return
        }
        
        var request = NSMutableURLRequest(url:url)
        request.httpMethod = "POST"
        request = HttpUtility.header(request: request)
        let apibody = HttpUtility.getBody(body: body)
          if methodName != .GET  { // && methodName != .DELETE
                let jsonData = try! JSONSerialization.data(withJSONObject: apibody, options: [])
                
                request.httpBody = jsonData
                debugPrint(NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String)
           }
        let  url1 = URL.init(string:"\(url.absoluteString)\(String(describing: body!))".encodeUrl()) ?? url
        
        print(url1)
        URLSession.shared.dataTask(with: request as URLRequest  ) { data, _, error in
            guard let data = data else{
                if let error = error{
                    completion(.failure(error))
                    Log.e("Failed: \(error)")
                    
                }else{
                    completion(.failure(CustomError.inValidData))
                    Log.e("Failed: \(CustomError.inValidData)")
                }
                return
            }
            do{
                var backToString = String(data: data, encoding: String.Encoding.utf8) as String?
                print(backToString)
                let result = try JSONDecoder().decode(type, from: data)
                Log.d("Parsing done sucessfully:\(result)")
                completion(.success(result))

            }catch{
                completion(.failure(error))
                Log.e("Failed: \(error)")
            }
        }.resume()
    }
    
    
    
//    class open func getService<T:Codable>(url:URL?,body:NSMutableDictionary?,type:T.Type,completion: @escaping (Result<T,Error>)->Void){
//        guard var url = url else{
//            Log.e("Failed:\(CustomError.invalidUrl)")
//            completion(.failure(CustomError.invalidUrl))
//            
//            return
//        }
//        let apiParameter = HttpUtility.stringFromDictionary(apibody: body ?? [:])
//        url = URL.init(string:"\(url.absoluteString)\(apiParameter)".encodeUrl()) ?? url
//        URLSession.shared.dataTask(with: url) { data, _, error in
//            guard let data = data else{
//                if let error = error{
//                    completion(.failure(error))
//                    Log.e("Failed: \(error)")
//                    
//                }else{
//                    completion(.failure(CustomError.inValidData))
//                    Log.e("Failed: \(CustomError.inValidData)")
//                }
//                return
//            }
//            do{
//                let result = try JSONDecoder().decode(type, from: data)
//                Log.d("Parsing done sucessfully:\(result)")
//                completion(.success(result))
//
//            }catch{
//                completion(.failure(error))
//                Log.e("Failed: \(error)")
//            }
//        }.resume()
//    }
//    
    
    class func header(request: NSMutableURLRequest) -> NSMutableURLRequest {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    class func getBody(body:NSMutableDictionary?) -> NSMutableDictionary{
        
        var apibody:NSMutableDictionary!
        if body == nil {
            apibody = NSMutableDictionary()
        }else{
            apibody = body!.mutableCopy() as? NSMutableDictionary
        }
        //Put Extra Common parameter here
        return apibody
    }
    
//    class func stringFromDictionary(apibody:NSMutableDictionary) -> NSMutableString {
//
//        let  apiParameter = NSMutableString()
//        for key in apibody.allKeys {
//            if apiParameter.length != 0 {
//                apiParameter.append("&")
//            }
//            if apibody[key as! String]! is NSString {
//
//                let str = apibody.value(forKey: key as! String)! as! String
//                apibody[key as! String] = str.replacingOccurrences(of: "&", with: "%26")
//            }else  if apibody[key as! String]! is NSNumber {
//                apibody[key as! String] = "\(apibody.value(forKey: key as! String)!)"
//            }
//            apiParameter.append("\(key)=\(apibody[key as! String]!)")
//
//        }
//        return apiParameter
//    }

}

