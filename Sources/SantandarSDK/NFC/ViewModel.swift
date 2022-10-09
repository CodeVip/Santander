//
//  ViewModel.swift
//  SantanderNFC
//
//  Created by admin on 07/03/22.
//

import UIKit
import CoreNFC
//import Alamofire

class ViewModel: NSObject {
    
    var session: NFCNDEFReaderSession?
    var theActualData = ""
    var isReadTag = true
    var isActivateCard = false
    var cardid = ""
    var clientId = ""
    var clientsData: [Model] = [Model(name: "BG Activate", clientId: "CL26866"),
                                Model(name: "Activate", clientId: "CL21014"),
                                Model(name: "NOT Issued", clientId: "CL2210900"),
                                Model(name: "Blocked", clientId: "CL16753")]
    
    typealias CompletionHandler = (_ data: Data?, _ error : Error?) -> Void
    
    func checkforTheActivation(completion : @escaping CompletionHandler) {
        isActivateCard = false
        print("cardid -\(cardid) \n clientId - \(clientId)")
        let validation = ValidationParam(CardId: cardid, ClientId: clientId)
//        AF.request("https://us-central1-digital-interactive-coc.cloudfunctions.net/santander-mobile/validateClient",
//                   method: .post,
//                   parameters: validation,
//                   encoder: JSONParameterEncoder.default).response { response in
//            debugPrint(response)
//            switch response.result {
//            case   .success(let data):
//                completion(data, nil)
//            case let  .failure(err):
//                completion(nil, err)
//            }
//        }
    }
    
    func parsersponseData(_ data: Data) -> String {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            let result = json["result"] as? String ?? ""
            return result
        } catch let error as NSError {
            return error.localizedDescription
        }
    }
}

struct ValidationParam: Encodable {
    let CardId: String
    let ClientId: String
}

struct Model {
    let name: String
    let clientId: String
}
