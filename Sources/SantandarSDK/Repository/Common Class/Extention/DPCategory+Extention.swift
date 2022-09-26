

import Foundation
import UIKit


extension String{
    func encodeUrl() -> String{
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
    }
    
    func localizableString(loc:String)->String{
        let path = Bundle.path(forResource: loc, ofType: "lproj", inDirectory:"")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, bundle:bundle!,value: "", comment: "")
      
    }
}


