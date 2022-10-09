//
//  ViewController.swift
//  SantanderNFC
//
//  Created by admin on 01/03/22.
//

import UIKit
import CoreNFC

public class ViewController :NSObject{
    
    let viewModel = ViewModel()
    
   
    let  pickerView: UIPickerView = UIPickerView()
    
  
  
    private func setUpPickerView() {
     
        pickerView.reloadAllComponents()
    }
    
    @IBAction func btnClicked(_ sender: Any) {
        viewModel.isReadTag = true
        beginReadSeesion()
    }
    
    public func beginReadSeesion() {
        guard  NFCNDEFReaderSession.readingAvailable else {
            let alert = UIAlertController(title: "Scanning Not Supported",
                                          message: "This device does not support scaning",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            //present(alert, animated: true, completion: nil)
            return
        }
        viewModel.session = NFCNDEFReaderSession(delegate: self,
                                                 queue: nil,
                                                 invalidateAfterFirstRead: true)
        viewModel.session?.alertMessage = "Hold your tag near to phone"
        viewModel.session?.begin()
    }
    
    @IBAction func btnWriteTagClicked(_ sender: Any) {
//        viewModel.isReadTag = false
//        if let text = txtFld.text, !text.isEmpty {
//            viewModel.theActualData = text
//        } else {
//            viewModel.theActualData = "https:\\www.youtube.com"
//        }
//        viewModel.session = NFCNDEFReaderSession(delegate: self,
//                                       queue: nil,
//                                       invalidateAfterFirstRead: false)
//        viewModel.session?.alertMessage = " Hold your tag near to phone"
//        viewModel.session?.begin()
    }
    
     func btnActivateCardClicked() {
        // Get the clint id from user default --
        guard let clientId  = UserDefaults.standard.string(forKey: "ClientID") else {
            alertMessage(title: "Oops", subtitle: "Please select an user")
            return
        }
        viewModel.clientId = clientId
        viewModel.isActivateCard = true
        beginReadSeesion()
    }
}

extension ViewController: NFCNDEFReaderSessionDelegate {
    
    @available(iOS 13.0, *)
    public func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        let str: String = viewModel.theActualData
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
                    if self.viewModel.isReadTag || self.viewModel.isActivateCard {
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
                                                if !self.viewModel.isActivateCard {
                                                    let arr = item.split(separator: "=")
                                                    self.viewModel.cardid = String(arr[1])
                                                    self.viewModel.checkforTheActivation(completion: { [self] (data, err) in
                                                        if err == nil {
                                                            self.alertMessage(title: "", subtitle: self.viewModel.parsersponseData(data!))
                                                        } else {
                                                            self.alertMessage(title: "Opps", subtitle: err!.localizedDescription)
                                                        }
                                                    })
                                                } else {
                                                    self.alertMessage(title: "Card Data", subtitle: String(item))
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
    
    public func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        print("didDetectNDEFs")
        
    }
    
    public func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        if let readerError = error as? NFCReaderError {
            if (readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead) && (readerError.code != .readerSessionInvalidationErrorUserCanceled) {
                print("display alert")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Sesstion error",
                                                  message: error.localizedDescription,
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                   // self.present(alert, animated: true, completion: nil)
                }
               
            }
        }
    }
    
    func alertMessage(title: String, subtitle: String ) {
        DispatchQueue.main.async {
            let alert = UIAlertController.init(title: title, message: subtitle, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
           // self.present(alert, animated: true, completion: nil)
        }
    }

}




extension Data {
    func toStr() -> String? {
        return String(data: self, encoding: .utf8) as String?
    }
}




func login(_ userName: String, password: String) {
     // network call  {
      // if  sccess {
           // move to home page
      //}
  
      // failour {
      // display alert to end user
      // retry
//}
//}
}

