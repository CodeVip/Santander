//
//  ClickButton.swift
//  Preto3 - Lite
//
//  Created by Vipin Chaudhary on 25/08/20.
//  Copyright © 2020 Vipin Chaudhary. All rights reserved.
//

import Foundation
import UIKit

class ClickButton : UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.setup()
    }
    
    override  func awakeFromNib() {
        super.awakeFromNib()
        //self.setup()
    }
    
   private func setup() {
        self.titleLabel?.text = self.titleLabel?.text
        self.titleLabel?.textColor = self.titleLabel?.textColor
//        if IS_IPAD {
//            self.titleLabel?.font =  UIFont.regularFont(17)
//        }
//        else {
//            self.titleLabel?.font =  UIFont.regularFont(15)
//        }
    }
    
    func setText(text: String) {
        super.setTitle(text,for: .normal)
    }
    
    func setTextColor(textColor: UIColor) {
        super.setTitleColor(.red, for: .normal)
    }
    
    func setBackgroundColor(color: UIColor) {
        super.backgroundColor = color
    }
    
    func setFont(font: UIFont) {
        super.titleLabel?.font = font
    }
    
    func setAlpha(_ alpha: CGFloat) {
        UIView.animate(withDuration: 0.5) {
            self.alpha = alpha
        }
    }
    
    func setImage(_ image: UIImage) {
        UIView.animate(withDuration: 0.5) {
            self.setImage(image, for: .normal)
        }
    }
}
