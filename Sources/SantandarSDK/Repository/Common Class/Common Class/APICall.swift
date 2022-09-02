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
//import RxSwift

extension NSManagedObject{
    
    func dictionaryWithValues() -> NSDictionary?{
        let allkeys = Array(self.entity.attributesByName.keys)
        return self.dictionaryWithValues(forKeys: allkeys) as NSDictionary
    }
}

struct APICall {
    public static func checkForSchoolRoleId(apiName: String, dictionary: NSMutableDictionary) -> NSMutableDictionary {
        if  apiName == APIName.authToken ||
                apiName == APIName.userRoles ||
                apiName == APIName.schoolSignUp ||
                apiName == APIName.getSchoolType ||
                apiName == APIName.forgotPassword ||
                apiName == APIName.getParentType ||
                apiName == APIName.joinASchool ||
                apiName == APIName.setPassword ||
                apiName == APIName.country ||
                apiName == APIName.state ||
                apiName == APIName.city {
            return dictionary
        }
        return dictionary
    }
    
    
  
    
    //MARK: Get Parent Type API
    public static func getParentType() {
        DPWebService.DPService(methodName: .GET, view: nil, isUserInteractionEnabled: false, returnFailedBlock: false, api: APIName.getParentType, message: "", body: nil) {(JSON, statusCode, message) in
            if statusCode == StatusCode.ok.rawValue {
                guard let parentTypeArray = JSON["response"] as? [NSDictionary] else {return}
              
            }
        }
    }
    
    //MARK: Auth Token API
    public static func authTokenDict(email: String, password: String) -> NSMutableDictionary {
        let body = NSMutableDictionary()
        body[DPKeysProject.username]  = email
        body[DPKeysProject.password]  = password
        return body
    }
    

    
    //MARK: Device Register API
    public static func deviceInfoDict() -> NSMutableDictionary {
        var deviceInfoDict = NSMutableDictionary()
        deviceInfoDict["deviceType"]  = 1 // 1 - ios, 2 - android, 3 - web
        deviceInfoDict["deviceToken"] = kUserDefults_(UserDefaultsKeyName.deviceToken) == nil ? Date().timeIntervalSince1970.description : kUserDefults_(UserDefaultsKeyName.deviceToken)
        deviceInfoDict["deviceOS"]    = UIDevice.current.systemVersion
        deviceInfoDict["deviceModel"] = UIDevice.current.modelName
        deviceInfoDict = APICall.checkForSchoolRoleId(apiName: APIName.registerDeviceInfo, dictionary: deviceInfoDict) // it will add schoolId and RoleId to dictionary
        return deviceInfoDict
    }

    
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
    
    //MARK: Classes API
    public static func getClasses(view: UIView? ,isIndicater: Bool = false, apiName: String, apiCallTimeKeyName: String, dictionary: NSMutableDictionary, complition:@escaping (Bool,Int,String,[NSDictionary]) -> Void) {
        
        DPWebService.DPService(methodName: .GET, view: view, isUserInteractionEnabled: false, returnFailedBlock: true, api: apiName, message: "", body: dictionary) { (JSON, statusCode, message) in
            
//            guard let responseCode = JSON[APIKeyName.code] as? Int else {
//                complition(false,statusCode,message,[[:]])
//                return
//            }
//            if let classArray = JSON["response"] as? [NSDictionary] {
//                kUserDefults(JSON[APIKeyName.lastUpdatedTime], key: apiCallTimeKeyName) // save api call time so next time this time stamp will be sent
//                complition(true,responseCode,message,classArray)
//                return
//            }
            complition(true,statusCode,message,JSON)
        }
    }
  
}
