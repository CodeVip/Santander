
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
    if  let data = defults.value(forKey: key) as? Data {
        return NSKeyedUnarchiver.unarchiveObject(with: data)
    }
    return defults.value(forKey: key)
}
@discardableResult
func klocallized(_ title:String)-> String {
    return NSLocalizedString(title, comment: "")
}

func numberOfDaysInTwoDates(smallerDate: Date, biggerDate: Date) -> Int {
    let calendar = Calendar.current
    let date1 = calendar.startOfDay(for: smallerDate)
    let date2 = calendar.startOfDay(for: biggerDate)
    let components = calendar.dateComponents([.day], from: date1, to: date2)
    debugPrint(components)
    return components.day ?? 0
}


func minutesToHoursMinutes (minutes : Int64) -> (hours : Int64 , leftMinutes : Int64) {
    return (Int64(minutes / 60), (Int64(minutes % 60)))
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

public struct DPConstant{
    public static func returnJsonString(param:Any) -> String {
        let jsonData = try! JSONSerialization.data(withJSONObject: param, options: [])
        return NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
    }
    
    public static func readJson(fileName:String) -> NSDictionary?{
        do {
            let file = Bundle.main.url(forResource: fileName, withExtension: "json")!
            let data = try Data(contentsOf: file)
            return try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            
        } catch {
            return nil
            
        }
    }

    public static func backView() -> UIView{
        let blackView = UIView.init(frame: UIScreen.main.bounds)
        blackView.backgroundColor = UIColor.black
        return blackView
    }
    public static func imageFrom(view: UIView = DPConstant.backView()) -> UIImage {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}

public struct DPValidation {
    
    public static let dlkInternet         = "Please check your internet connection and try again"
    public static let dlkServer           = "Server is not responding. Please try again later"

}

struct APIName {
    static var getCardAuthorize           = "products/3"
   
}

struct APIKeyName {
    static var lastUpdatedTime            = "lastUpdatedTime"
    static var apiParams                  = "apiParams"
    static var apiName                    = "apiName"
    static var message                    = "message"
    static var code                       = "code"
    static var file                       = "file"
}

struct APICallTimeKeyName {
    static var getClasses                 = "getClasses"
    static var getStaffs                  = "getStaff"
  
}

public struct DPKeysProject {

    static let apiDateFormate             = "yyyy-MM-dd'T'HH:mm:ss"
    static let isRefreshRoom              = "isRefreshRoom"
}

struct DPDateFormatter {
    public static let dateFormatServer    =  DPKeysProject.apiDateFormate
    public static let MonthYear             = "MM-yyyy"
    public static let AuthorizeDate         = "yyyy-MM-dd"
    public static let DemoDate              = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    public static let activityFormat        = "MM/dd/yyyy h:mm a"
    public static let dailyActivityFormat   = "MM/dd/yyyy"
}
