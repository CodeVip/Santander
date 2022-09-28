//
//  File.swift
//  
//
//  Created by Vipin Chaudhary on 20/09/22.
//

import Foundation
import UIKit

//MARK:  - DPLoader Class -

class DPLoader : UIView {
    let blackView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        let activityIndicater = UIActivityIndicatorView()
        activityIndicater.style = .whiteLarge
        activityIndicater.color = UIColor.white
        activityIndicater.startAnimating()
        self.blackView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicater.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(blackView)
        blackView.addSubview(activityIndicater)
        blackView.backgroundColor = UIColor.black
        blackView.layer.cornerRadius = 4
        blackView.layer.masksToBounds = true
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
        self.addConstraint(NSLayoutConstraint.init(item: blackView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: blackView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
        blackView.addConstraint(NSLayoutConstraint.init(item: blackView, attribute: .height, relatedBy: .greaterThanOrEqual, toItem:nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 120))
        blackView.addConstraint(NSLayoutConstraint.init(item: blackView, attribute: .width, relatedBy: .greaterThanOrEqual, toItem:nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 120))
        blackView.addConstraint(NSLayoutConstraint.init(item: blackView, attribute: .height, relatedBy: .lessThanOrEqual, toItem:nil, attribute: .notAnAttribute, multiplier: 1.0, constant: UIScreen.main.bounds.width - 40))
        blackView.addConstraint(NSLayoutConstraint.init(item: blackView, attribute: .width, relatedBy: .lessThanOrEqual, toItem:nil, attribute: .notAnAttribute, multiplier: 1.0, constant: UIScreen.main.bounds.size.width - 40))
        blackView.addConstraint(NSLayoutConstraint.init(item: activityIndicater, attribute: .centerX, relatedBy: .equal, toItem: blackView, attribute: .centerX, multiplier: 1.0, constant: 0))
        blackView.addConstraint(NSLayoutConstraint.init(item: activityIndicater, attribute: .centerY, relatedBy: .equal, toItem: blackView, attribute: .centerY, multiplier: 1.0, constant: 0))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func show(InView:UIView?, _ message:String){
        
        DispatchQueue.main.async(execute: {
            if InView == nil{
                return
            }
            guard let loader = InView?.viewWithTag(1322) as? DPLoader else {
                
                let rect = CGRect.init(x: 0, y: 0, width: InView!.frame.width, height: InView!.frame.height )
                let loader = DPLoader.init(frame:rect)
                loader.tag = 1322
                InView?.addSubview(loader)
                return
            }
            
           // loader.lblMessage.text = message
            loader.tag = 1322
            InView?.addSubview(loader)
        })
    }
    
    class func dismiss(InView:UIView?) {
        DispatchQueue.main.async {
            guard let loader = InView?.viewWithTag(1322) as? DPLoader else {return}
            loader.removeFromSuperview()
        }
        
    }
}




//MARK: - FunctionDefination -
func InternetCheck () -> Bool {
    let reachability =  Reachability()
    let networkStatus  = reachability?.currentReachabilityStatus
    if networkStatus == .notReachable {
        return false
    }
    return true
}







