//
//  SyncAPI.swift
//  PDC
//
//  Created by Vipin Chaudhary on 25/07/20.
//  Copyright © 2020 Vipin Chaudhary. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension NSManagedObject{
    
    func dictionaryWithValues() -> NSDictionary?{
        let allkeys = Array(self.entity.attributesByName.keys)
        return self.dictionaryWithValues(forKeys: allkeys) as NSDictionary
    }
}

struct APICall {
    public static func addEditClass(view: UIView?,isIndicater: Bool = false, apiName: String, apiCallTimeKeyName: String? = nil, dictionary: NSMutableDictionary, complition:@escaping (Bool,Int,String,NSDictionary) -> Void) {
        DPWebService.DPService(methodName: .POST, view: view, isUserInteractionEnabled: false, returnFailedBlock: true, api: apiName, message: "", body: dictionary) { (JSON, statusCode, message) in
            
            guard let responseCode = JSON[APIKeyName.code] as? Int else {
                complition(false,statusCode,message,[:])
                return
            }
            
            if let classDataModel = JSON["response"] as? NSDictionary {
                complition(true,responseCode,message,classDataModel)
                return
            }
            
            complition(false,responseCode,message,[:])
            return
        }
    }
    
    public static func getInformation<T:Codable>(url:URL,type:T.Type, completion: @escaping (Result<T,Error>)->Void){
        DPWebService.requestService(methodName: .GET,url: url, type: type,body:[:]) {  result in
            switch result{
            case .success(let welcome):
               // print(welcome)
                completion(.success(welcome.self as! T))
                
                
            case .failure(let error):
                completion(.failure(error))
                print(error)
            }
        }
    }
    //MARK: Classes API
    public static func getCardInfo(view: UIView? ,isIndicater: Bool = false, apiName: String, apiCallTimeKeyName: String, dictionary: NSMutableDictionary, complition:@escaping (Bool,Int,String,[NSDictionary]) -> Void) {
        
        DPWebService.DPService(methodName: .GET, view: view, isUserInteractionEnabled: false, returnFailedBlock: true, api: apiName, message: "", body: dictionary) { (JSON, statusCode, message) in
            
//            guard let responseCode = JSON[APIKeyName.code] as? Int else {
//                complition(false,statusCode,message,[[:]])
//                return
//            }
            if let classArray = JSON as? [NSDictionary] {
                complition(true,statusCode,message,classArray)
                return
            }
            complition(false,statusCode,message,[[:]])
        }
    }
}
