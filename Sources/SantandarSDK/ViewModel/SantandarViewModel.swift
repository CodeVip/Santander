//
//  File.swift
//  
//
//  Created by Vipin Chaudhary on 19/09/22.
//

import Foundation

class SantanderViewModel{

var service:HttpUtility!

private(set)  var welData:Welcome! {
  didSet{
      self.callBackToView()
  }
}
    
private(set) var errorToView:Error!{
        didSet{
            self.callBackToViewServerError()
    }
}

init(service: HttpUtility!) {
    self.service = service
}
    
var callBackToView:()->() = {}
var callBackToViewServerError: ()->() = {}
    
func calToFetchData(baseUrl:String) {
    service.postService(methodName: .GET, url: URL(string:  baseUrl + APIName.getCardAuthorize)!, type: Welcome.self, body: [:]){ result in
        switch result{
        case .success(let data):
            Log.d("\(data)")
            self.welData = data
        case .failure(let error):
            Log.e("\(error.localizedDescription)")
            self.errorToView = error
           
        }
    }
  }
}
