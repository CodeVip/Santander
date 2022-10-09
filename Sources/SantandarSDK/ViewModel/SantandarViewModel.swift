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
    
  private(set)  var CardStat:CardStatus! {
      didSet{
          self.callBackForCardStatusToView()
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
    
var callBackForCardStatusToView:()->() = {}
var callBackForCardStatusToServerError: ()->() = {}
    
func calToFetchData(baseUrl:String,body:NSMutableDictionary?) {
    service.postService(methodName: .POST, url: URL(string:  baseUrl + APIName.getCardAuthorize)!, type: Welcome.self, body: body){ result in
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
    
    func calToActivateCard(baseUrl:String,body:NSMutableDictionary?) {
        service.postService(methodName: .POST, url: URL(string:  baseUrl + APIName.activate_card)!, type: CardStatus.self, body: body){ result in
            switch result{
            case .success(let data):
                Log.d("\(data)")
                self.CardStat = data
            case .failure(let error):
                Log.e("\(error.localizedDescription)")
                self.errorToView = error
               
            }
        }
      }

}
