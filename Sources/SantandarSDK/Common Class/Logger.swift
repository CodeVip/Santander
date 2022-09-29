//
//  Logger.swift
//  OFS
//
//  Created by Vipin Chaudhary on 05/09/22.
//  Copyright © 2019 Tanmoy. All rights reserved.
//

import Foundation

/// Enum which maps an appropiate symbol which added as prefix for each log message
/// - error: Log type error
/// - debug: Log type debug
enum LogEvent: String {
case e = "[😡]" // error
case d = "[😁]" // debug
}


/// Wrapping Swift.print() within DEBUG flag
///
/// - Note: *print()* might cause [security vulnerabilities](https://codifiedsecurity.com/mobile-app-security-testing-checklist-ios/)
///
/// - Parameter object: The object which is to be logged
///
func print(_ object: Any) {
Swift.print(object)
}

class Log {

static var dateFormat = "yyyy-MM-dd HH:mm:ss"
static var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormat
    formatter.locale = Locale.current
    formatter.timeZone = TimeZone.current
    return formatter
}


// MARK: - Loging methods


/// Logs error messages on console with prefix [😡]
///
/// - Parameters:
///   - object: Object or message to be logged
///   - filename: File name from where loggin to be done
///   - line: Line number in file from where the logging is done
///   - funcName: Name of the function from where the logging is done
class func e( _ object: Any, filename: String = #file, line: Int = #line, funcName: String = #function) {
   // if kUserDefults_("isLoggingEnabled") as! Bool {
        print("\(Date().toString()) \(LogEvent.e.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(funcName) -> \(object)")
   // }
}


/// Logs debug messages on console with prefix [😁]
///
/// - Parameters:
///   - object: Object or message to be logged
///   - filename: File name from where loggin to be done
///   - line: Line number in file from where the logging is done
///   - funcName: Name of the function from where the logging is done
class func d( _ object: Any, filename: String = #file, line: Int = #line, funcName: String = #function) {
    
   // if kUserDefults_("isLoggingEnabled") as! Bool {
        print("\(Date().toString()) \(LogEvent.d.rawValue)[\(sourceFileName(filePath: filename))]:\(line)  \(funcName) -> \(object)")
   // }
}


/// Extract the file name from the file path
///
/// - Parameter filePath: Full file path in bundle
/// - Returns: File Name with extension
private class func sourceFileName(filePath: String) -> String {
    let components = filePath.components(separatedBy: "/")
    return components.isEmpty ? "" : components.last!
}
}

internal extension Date {
func toString() -> String {
    return Log.dateFormatter.string(from: self as Date)
}
}
