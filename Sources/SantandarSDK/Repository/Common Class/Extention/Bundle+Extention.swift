//
//  Bundle+Extention.swift
//  PDC
//
//  Created by Vipin Chaudhary on 06/08/20.
//  Copyright © 2018 Vipin Chaudhary. All rights reserved.
//

import Foundation
import UIKit

@objc extension FileManager{
    
    static let awsImageFolderName = "SignaturesImages"
    static let videoFolderName    = "Video"
    private static let documentBasePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
    public static  let awsImageFolderPath = documentBasePath.appending("/\(awsImageFolderName)/")
    public static  let videoFolderPath = documentBasePath.appending("/\(videoFolderName)/")
    
    
    @discardableResult
    public static func createFolder(folderName:String) -> Bool{
        let folderPath = documentBasePath.appending("/\(folderName)")
        
        if FileManager.default.fileExists(atPath: folderPath) == false{
            do {
                try FileManager.default.createDirectory(at: URL.init(fileURLWithPath: folderPath), withIntermediateDirectories: false, attributes: nil)
                return true
                
            } catch  {
               debugPrint("Error with creating directory at path: \(error.localizedDescription)")
                UIAlertController.showAlertError(message: error.localizedDescription)
                return false
            }
        }
        return true
    }
    
    public static func allFolderData(folderName:String) -> [String]{
        return FileManager.default.subpaths(atPath: folderName) ?? [String]()
    }
    @discardableResult
    public static func removeFile(fileName:String)-> Bool{
        
        do {
            try FileManager.default.removeItem(atPath: awsImageFolderPath.appending(fileName))
            return true
            
        } catch  {
           debugPrint("Error with creating directory at path: \(error.localizedDescription)")
            UIAlertController.showAlertError(message: error.localizedDescription)
            return false
        }
        
    }
    @discardableResult
    public static func removeVideo(fileName:String)-> Bool{
        
        do {
        
            guard let url = URL.init(string: fileName) else {
                return false
            }
            try FileManager.default.removeItem(atPath: videoFolderPath.appending(url.lastPathComponent))
            return true
            
        } catch  {
           debugPrint("Error with creating directory at path: \(error.localizedDescription)")
            UIAlertController.showAlertError(message: error.localizedDescription)
            return false
        }
        
    }
    
    @discardableResult
    public static func saveFile(fileName:String,image:UIImage) -> Bool{
       guard let data = image.jpegData(compressionQuality: 0.20) else {return false}
            do{
                try data.write(to: URL.init(fileURLWithPath: awsImageFolderPath.appending(fileName)))
                return true
                
            } catch {
               UIAlertController.showAlertError(message: error.localizedDescription)
                return false
            }
        }
}




