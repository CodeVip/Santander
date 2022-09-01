//
//  UILabel+Extension.swift
//  Preto3 - Lite
//
//  Created by Vipin Chaudhary on 25/08/20.
//  Copyright © 2020 Vipin Chaudhary. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore


class HeaderLabel : UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.setup()
    }

   private func setup() {
        self.text = self.text
        self.textColor = self.textColor
//        if IS_IPAD {
//            self.font = UIFont.regularFont(25)
//        }
//        else {
//            self.font = UIFont.regularFont(18)
//        }
        self.font = UIFont.mediumFont(16)
    }
    
    func setText(text: String) {
        super.text = text
    }
    
    func setTextColor(textColor: UIColor) {
        super.textColor = textColor
    }
    
    func setFont(font: UIFont) {
        super.font = font
    }
}
