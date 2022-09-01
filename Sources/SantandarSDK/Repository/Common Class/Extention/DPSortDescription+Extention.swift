//
//  DPSortDescription+Extention.swift
//  PDC
//
//  Created by Vipin Chaudhary on 05/08/20.
//  Copyright © 2020 Vipin Chaudhary. All rights reserved.
//

import Foundation

extension NSSortDescriptor {
    
    public static func descriptor(_ key:String?,_ ascending:Bool = true) -> NSSortDescriptor{
        return NSSortDescriptor.init(key: key, ascending: ascending)
    }
}
