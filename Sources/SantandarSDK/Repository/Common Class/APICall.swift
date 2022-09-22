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

struct APICall {
//MARK: Classes API
public static func getInformation<T:Codable>(url:URL?,type:T.Type, completion: @escaping (Result<T,Error>)->Void){
    let http = HttpUtility()
    http.postService(methodName: .GET,url: url, type: type,body:[:]) {  result in
        switch result{
        case .success(let welcome):
           // print(welcome)
            completion(.success(welcome.self))
            
        case .failure(let error):
            completion(.failure(error))
            print(error)
        }
    }
  }
}
