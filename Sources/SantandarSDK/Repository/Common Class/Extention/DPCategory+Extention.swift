

import Foundation
import UIKit


extension String{
    func encodeUrl() -> String{
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
    }
}

