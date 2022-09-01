

import Foundation
import UIKit


public extension UIView {
    @objc class func fromNib(_ nibNameOrNil:String) ->  UIView {
        return  Bundle.main.loadNibNamed(nibNameOrNil, owner: self, options: nil)!.first as! UIView
    }
}

extension UIView{
    
    func ClearColorShaddow(_ alpha:Float){
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = (self.frame.size.height)/2
        self.layer.shadowPath = CGPath(rect: CGRect(x: 0,y: 0, width: self.frame.width,height: self.frame.height), transform: nil)
        self.layer.shadowOpacity = alpha
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        
    }
    
    @IBInspectable var PPCorneredius:CGFloat{
        
        get{
            return layer.cornerRadius
        }
        set{
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = newValue > 0
        }
    }
    @IBInspectable var PPBorderWidth:CGFloat{
        
        get{
            return layer.borderWidth
        }
        set{
            self.layer.borderWidth = newValue
            self.layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var PPBorderColor:UIColor{
        
        get{
            return self.PPBorderColor
        }
        set{
            self.layer.borderColor = newValue.cgColor
            
        }
    }
    @IBInspectable var PPRoundDynamic:Bool{
        
        get{
            return false
        }
        set{
            if newValue == true {
                
                self.perform(#selector(UIView.AfterDelay), with: nil, afterDelay: 0.0)
            }
            
        }
        
    }
    @objc func AfterDelay(){
        
        let  Height =  self.frame.size.height
        self.layer.cornerRadius = Height/2;
        self.layer.masksToBounds = true;
        
        
    }
    @IBInspectable var PPRound:Bool{
        get{
            return false
        }
        set{
            if newValue == true {
                self.layer.cornerRadius = self.frame.size.height/2;
                self.layer.masksToBounds = true;
            }
            
        }
    }
    @IBInspectable var PPShadow:Bool{
        get{
            return false
        }
        set{
            if newValue == true {
                self.layer.masksToBounds = false
                self.layer.shadowColor = UIColor.black.cgColor
                self.layer.shadowOffset = CGSize(width: 1.0, height: 0.0)
                self.layer.shadowOpacity = 0.3;
                
            }
            
        }
        
    }
    
    
    
    func roundMake() {
        self.layer.cornerRadius = self.frame.size.height/2;
        self.layer.masksToBounds = true;
    }
    
}

extension UILabel{
    
    @IBInspectable var FontAutomatic:Bool{
        get{
            return true
        }
        set{
            
            if newValue == true {
                
                let  height = (self.frame.size.height*SCREEN_HEIGHT)/568;
                self.font = UIFont(name:self.font.fontName, size:(height*self.font.pointSize)/self.frame.size.height )
            }
            
        }
        
    }
    
}
extension UITextView {
    
    @IBInspectable var FontAutomatic:Bool{
        get{
            return true
        }
        set{
            
            if newValue == true {
                
                let  height = (self.frame.size.height*SCREEN_HEIGHT)/568;
                self.font = UIFont(name:self.font!.fontName, size:(height*self.font!.pointSize)/self.frame.size.height )
            }
            
        }
        
    }
    
    @IBInspectable var Pedding:Bool{
        get{
            return true
        }
        set{
            
            if newValue == true {
                
                let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.frame.height))
                self.addSubview(paddingView)
            }
            
        }
        
    }
    
}

@IBDesignable class UITextViewFixed: UITextView {
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    func setup() {
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
    }
}
extension UITextField {
    @IBInspectable var FontAutomatic:Bool{
        get{
            return true
        }
        set{
            if newValue == true {
                
                let  height = (self.frame.size.height*SCREEN_HEIGHT)/568;
                self.font = UIFont(name:self.font!.fontName, size:(height*self.font!.pointSize)/self.frame.size.height )
            }
        }
    }
    func setBottomBorder(_ color:UIColor, height: CGFloat, paddingXAxis: CGFloat) {
        var view = self.viewWithTag(2525)
        if view == nil {
            DispatchQueue.main.async {
                view = UIView(frame:CGRect(x: paddingXAxis, y: self.frame.size.height - height, width:  self.frame.size.width - paddingXAxis, height: height))
                view?.backgroundColor = color
                view?.tag = 2525
                self .addSubview(view!)
            }
        }
    }
    func removeAddBottomBorder(_ color:UIColor, height: CGFloat, paddingXAxis: CGFloat) {
        var view = self.viewWithTag(2525)
        if view?.tag == 2525 {
            view?.removeFromSuperview()
        }
        DispatchQueue.main.async {
            view = UIView(frame:CGRect(x: paddingXAxis, y: self.frame.size.height - height, width:  self.frame.size.width - paddingXAxis, height: height))
            view?.backgroundColor = color
            view?.tag = 2525
            self .addSubview(view!)
        }
    }
    @IBInspectable var Pedding:Bool{
        get{
            return true
        }
        set{
            
            if newValue == true {
                
                let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
                self.leftView = paddingView
                self.leftViewMode = UITextField.ViewMode.always
                
            }
            
        }
        
    }
    
    @discardableResult
    func leftButton(image: UIImage?, width: CGFloat = 0, height: CGFloat = 0) -> UIButton {
        
        let btn = UIButton.init(type: .custom)
        //btn.setImage(UIImage.init(named: imageName), for: .normal)
        btn.setImage(image, for: .normal)
        btn.frame = CGRect.init(x: 0, y: 0, width: width, height:  height)
        self.leftView = btn;
        self.leftViewMode = .always
        return btn
        
    }
    @discardableResult
    func rightButton(image: UIImage?, width: CGFloat = 0, height: CGFloat = 0) -> UIButton {
        
        let widthNew = (width == 0) ? self.frame.size.width : width
        let heightNew = (height == 0) ? self.frame.size.height : height
        
        let btn = UIButton.init(type: .custom)
        btn.setImage(image, for: .normal)
        btn.isUserInteractionEnabled = false
//        btn.isUserInteractionEnabled = true
        btn.frame = CGRect.init(x:  (self.frame.size.width - self.frame.size.height), y: 0, width:widthNew, height:  heightNew)
        self.rightView = btn;
        self.rightViewMode = .always
        return btn
    }
//    func rightButton(image:UIImage?,width:CGFloat = 0) -> UIButton{
//
//        let widthNew = (width == 0) ? self.frame.size.height : width
//
//        let btn = UIButton.init(type: .custom)
//        btn.setImage(image, for: .normal)
//        btn.isUserInteractionEnabled = false
//        btn.frame = CGRect.init(x:  (self.frame.size.width - self.frame.size.height), y: 0, width:widthNew, height:  self.frame.size.height)
//        self.rightView = btn;
//        self.rightViewMode = .always
//        return btn
//
//    }
    func removeRightViewImage(){
        self.rightView = nil;
        self.rightViewMode = .always
        
    }
    func leftpedding(){
        
        let btn = UIButton.init(type: .custom)
        btn.setImage(nil, for: .normal)
        btn.frame = CGRect.init(x: 0, y: 0, width:10, height:  self.frame.size.height)
        self.leftView = btn;
        self.leftViewMode = .always
        
        
    }
    
    
    
}
extension UIButton{
    
    @IBInspectable var FontAutomatic:Bool{
        get{
            return true
        }
        set{
            
            if newValue == true {
                
                let  height = (self.frame.size.height*SCREEN_HEIGHT)/568;
                self.titleLabel!.font = UIFont(name:self.titleLabel!.font!.fontName, size:(height*self.titleLabel!.font!.pointSize)/self.frame.size.height )!
            }
            
        }
        
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

    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
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
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [kCTFontAttributeName as NSAttributedString.Key: font], context: nil)
        return boundingBox.height
    }
    
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
   static func random(length:Int)->String{
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""
        
        while randomString.utf8.count < length{
            let randomLetter = letters.randomElement()
            randomString += randomLetter?.description ?? ""
        }
        return randomString
    }
}
extension UIScrollView{
    
    func AumaticScroller() {
        
        var contentRect = CGRect.zero
        for view in self.subviews{
            contentRect = contentRect.union(view.frame);
        }
        
        self.contentSize = contentRect.size;
    }
}

extension UIImage {
    
    func PPresizeImage(_ newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    class func circleImage(diameter: CGFloat, color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
        
        let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        ctx.setFillColor(color.cgColor)
        ctx.fillEllipse(in: rect)
        
        ctx.restoreGState()
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return img
    }
    
    class func textOnImage(text: String, textHeight: CGFloat, image: UIImage, imageViewWidth: CGFloat, imageViewHeight: CGFloat, font: UIFont, textColor: UIColor) -> UIImage {

        let scale = UIScreen.main.scale
        let size = CGSize(width: imageViewWidth, height: imageViewHeight)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let widthOfString = text.widthOfString(usingFont: font)
        
        let textFontAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: textColor,
            ] as [NSAttributedString.Key : Any]
        image.draw(in: CGRect(x: 0, y: 0, width: imageViewWidth, height: imageViewHeight))
        
        let rect = CGRect(x: (imageViewWidth - widthOfString) / 2, y: (imageViewHeight - textHeight) / 2, width: widthOfString, height: textHeight)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

extension UIImageView {
    
    public func setImageWithStatus(_ url:String?, _ placeholderImage:UIImage = UIImage.init(named: "bg")!, complition:@escaping (Bool, UIImage) -> Void) {
        
//        self.kf.setImage(with: URL.init(string: url ?? ""), placeholder: placeholderImage, options: [.transition(.fade(1))], progressBlock: nil) { result in
//            switch result {
//            case .success(let value):
//                complition (true, value.image)
//                debugPrint("Image: \(value.image). Got from: \(value.cacheType)")
//            case .failure( _):
//                complition (false, UIImage())
//               debugPrint("Error:")
//            }
//        }
    }
    
    public func setImage(_ url:String?, _ placeholderImage:UIImage = UIImage.init(named: "bg")!) {
        //self.kf.setImage(with: URL.init(string: url ?? ""), placeholder: placeholderImage)
    }
    
    public func setAlpha (_ alpha: CGFloat) {
        UIView.animate(withDuration: 0.5) {
            self.alpha = alpha
        }
    }
    
    public func setDefaultImage(name: String, fontHeight: CGFloat, textColor: UIColor? = UIColor.white) {
        
        self.backgroundColor = UIColor.clear
//        self.image = UIImage.circleImage(diameter: self.frame.size.height / 2, color: colorForAlphabets(UserModel.dpUser.userProfileCharacter(name: name.uppercased().replacingOccurrences(of: " ", with: ""))))
    
//        self.image = UIImage.textOnImage(text: UserModel.dpUser.userProfileCharacter(name: name.uppercased()), textHeight: fontHeight + 5, image: self.image!, imageViewWidth: self.frame.size.width, imageViewHeight: self.frame.size.height, font: UIFont.regularFont(fontHeight), textColor: textColor!)
    }

}
extension UIViewController {
    
    @IBAction func backPress(_ sender:UIButton?) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func hideParentView() {
        
        self.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
            
         
        }
    }
    
  
    
    @objc func panGestureForViewAnimation(_ recognizer: UIPanGestureRecognizer, partialView: CGFloat) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        
        let y = self.view.frame.minY
        if (y + translation.y >= 0) && (y + translation.y <= partialView) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            duration = duration >= 0 ? 0.6 : duration
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    if self.view.frame.minY == partialView { // set to disappear
                        self.hideParentView()
                    }
                    else { // set to middle
                        self.view.frame = CGRect(x: 0, y: partialView, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    }
                    
                } else { // set to top
                    self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                }
                
            }, completion: { _ in
                if ( velocity.y < 0 ) {
                }
            })
        }
    }
    
}
extension UIFont{
    
    /*Poppins-BlackItalic
    Poppins-ExtraLight
    Poppins-ExtraLightItalic
    Poppins-ExtraBold
    Poppins-Bold
    Poppins-Light
    Poppins-ExtraBoldItalic
    Poppins-Italic
    Poppins-ThinItalic
    Poppins-LightItalic
    Poppins-Black
    Poppins-Medium
    Poppins-BoldItalic
    Poppins-SemiBold
    Poppins-Regular
    Poppins-Thin
    Poppins-SemiBoldItalic
    Poppins-MediumItalic*/
    /*
    static public func regularFont(_ size:CGFloat = 16) -> UIFont {
        return UIFont.init(name: "Nunito-Regular", size: size)!
    }
    
    static public func mediumFont(_ size:CGFloat = 16) -> UIFont {
        return UIFont.init(name: "Nunito-SemiBold", size: size)!
    }
    
    static public func lightFont(_ size:CGFloat = 16) -> UIFont {
        return UIFont.init(name: "Poppins-Light", size: size)!
    }
    static public func boldFont(_ size:CGFloat = 16) -> UIFont {
        return UIFont.init(name: "Nunito-Bold", size: size)!
    }*/
    
    static public func regularFont(_ size:CGFloat = 16) -> UIFont {
        return UIFont.init(name: "Roboto-Light", size: size)!
    }
    
    static public func mediumFont(_ size:CGFloat = 16) -> UIFont {
        return UIFont.init(name: "Roboto-Regular", size: size)!
    }
    
    static public func lightFont(_ size:CGFloat = 16) -> UIFont {
        return UIFont.init(name: "Roboto-Thin", size: size)!
    }
    static public func boldFont(_ size:CGFloat = 16) -> UIFont {
        return UIFont.init(name: "Roboto-Medium", size: size)!
    }
}


// An attributed string extension to achieve colors on text.
extension NSMutableAttributedString {
    
    func setColor(color: UIColor, forText stringValue: String, font: UIFont) {
        let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        self.addAttribute(NSAttributedString.Key.font, value: font, range: range)
    }
}

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}

extension Array {
    func unique<T:Hashable>(by: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(by(value)) {
                set.insert(by(value))
                arrayOrdered.append(value)
            }
        }
        return arrayOrdered
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
    
    @objc class func showAlertErrorNew(message:String,view:UIViewController){

        
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

extension UIActivityIndicatorView {
    func makeLargeGray() {
        style = .whiteLarge
        color = .gray
    }
}


extension URLRequest {
    
    /**
     Returns a cURL command representation of this URL request.
     */
    public var curlString: String {
        guard let url = url else { return "" }
        var baseCommand = "curl \(url.absoluteString)"
        
        if httpMethod == "HEAD" {
            baseCommand += " --head"
        }
        
        var command = [baseCommand]
        
        if let method = httpMethod, method != "GET" && method != "HEAD" {
            command.append("-X \(method)")
        }
        
        if let headers = allHTTPHeaderFields {
            for (key, value) in headers where key != "Cookie" {
                command.append("-H '\(key): \(value)'")
            }
        }
        
        if let data = httpBody, let body = String(data: data, encoding: .utf8) {
            command.append("-d '\(body)'")
        }
        
        return command.joined(separator: " \\\n\t")
    }
    
    init?(curlString: String) {
        return nil
    }
    
}

extension Array {
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
