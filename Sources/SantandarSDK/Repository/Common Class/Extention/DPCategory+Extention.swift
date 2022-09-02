

import Foundation
import UIKit


public extension UIView {
    @objc class func fromNib(_ nibNameOrNil:String) ->  UIView {
        return  Bundle.main.loadNibNamed(nibNameOrNil, owner: self, options: nil)!.first as! UIView
    }
}

extension String{
    
    func encodeUrl() -> String{
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }

    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func isValidName() -> Bool {
        
        if self.count > 0 {
            return true
        }
        return false
        
    }
    
    func isValidPassWord() -> Bool {
        
        if self.count > 1 {
            return true
        }
        return false
        
    }
    
    func isValidFullname() -> Bool {
        
        let emailRegEx = "^[A-Za-z]+(?:\\s[A-Za-z]+)"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
        
    }
    
    func isValidZipcode() -> Bool {
        
        if self.count == 5 || self.count == 6 {
            return true
        }
        return false
        
    }
    
    func isValidMobile() -> Bool {
        
        if self.count == 10 {
            return true
        }
        return false
    }
    
}

@objc extension UIAlertController {
    
    @objc class func showAlertError(message:String){
        if let activeVc = UIApplication.shared.keyWindow?.rootViewController {
        let alertController = UIAlertController(title: message, message:nil , preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        activeVc.present(alertController, animated: true, completion: nil)
        }
    }
    
    class func showAlert(message:String,complition:@escaping ()-> Void){
         let activeVc = UIApplication.shared.keyWindow?.rootViewController
        let alertController = UIAlertController(title: message, message:nil , preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            complition()
        })
        alertController.addAction(defaultAction)
        activeVc!.present(alertController, animated: true, completion: nil)
       
    }
    
    class func showAlertNew(message:String,View:UIViewController,complition:@escaping ()-> Void){
          
          let alertController = UIAlertController(title: message, message:nil , preferredStyle: .alert)
          let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
              complition()
          })
          alertController.addAction(defaultAction)
          View.present(alertController, animated: true, completion: nil)
      }
    
    class func showAlertWithTitle(title : String,message:String){
        if let activeVc = UIApplication.shared.keyWindow?.rootViewController{
        let alertController = UIAlertController(title: title, message:message , preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        activeVc.present(alertController, animated: true, completion: nil)
        }
    }
    
    class func showAlert(message:String = "No",destructiveTitle:String,complition:@escaping ()-> Void){
        if let activeVc = UIApplication.shared.keyWindow?.rootViewController{
        let alertController = UIAlertController(title: message, message:nil , preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "No", style: .default, handler: nil)
        let destructive = UIAlertAction(title: destructiveTitle, style: .destructive, handler: { (action) in
            complition()
        })
        alertController.addAction(defaultAction)
        alertController.addAction(destructive)
        activeVc.present(alertController, animated: true, completion: nil)
        }
    }
    
    class func showAlert(message: String, cameraTitle: String, galleryTitle: String, cameraComplition:@escaping ()-> Void, galleryComplition:@escaping ()-> Void) {
         let activeVc = UIApplication.shared.keyWindow?.rootViewController
        let alertController = UIAlertController(title: message, message:nil , preferredStyle: .alert)
        let cancelAction   = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let cameraAction   = UIAlertAction(title: cameraTitle, style: .default, handler: { (action) in
            cameraComplition()
        })
        let galleryAction     = UIAlertAction(title: galleryTitle, style: .default, handler: { (action) in
            galleryComplition()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        
        switch UIDevice.current.userInterfaceIdiom {
        default:
            break
        }
         activeVc!.present(alertController, animated: true, completion: nil)
    }
}

extension Dictionary {
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [])
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
}
