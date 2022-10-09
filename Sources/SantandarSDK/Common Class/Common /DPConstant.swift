
import Foundation
import UIKit
import AVFoundation


let awsPoolId = "Pool Id"

public func kUserDefults(_ value: Any?, key: String, isArchive: Bool = false ) {
    let defults = UserDefaults.standard
    if  value != nil {
        let data = NSKeyedArchiver.archivedData(withRootObject: value!)
        defults.setValue(data, forKey: key )
    }else {
        defults.removeObject(forKey: key)
    }
    defults.synchronize()
}
public func kUserDefults_( _ key : String) -> Any? {
    let defults = UserDefaults.standard
//    if  let data = defults.value(forKey: key) as? data {
//        return NSKeyedUnarchiver.unarchiveObject(with: data)
//    }
    return defults.value(forKey: key)
}

func verifyWebsiteUrl (urlString: String?) -> Bool {
    //Check for nil
    if let urlString = urlString {
        // create NSURL instance
        if let url = NSURL(string: urlString) {
            // check if your application can open the NSURL instance
            return UIApplication.shared.canOpenURL(url as URL)
        }
    }
    return false
}

func isValidUrl(url: String?) -> Bool {
    if url != nil {
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: url)
        return result
    }
    return false
}

struct APIName {
    static var getCardAuthorize           = "card_status"
    static var  activate_card             = "activate_card"
   
}
