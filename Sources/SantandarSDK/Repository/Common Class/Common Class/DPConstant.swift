
import Foundation
import UIKit
import AVFoundation

let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
let SCREEN_WIDTH  = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let IS_IPHONE_4_OR_LESS  =  SCREEN_HEIGHT < 568.0
let IS_IPHONE_5          =  SCREEN_HEIGHT == 568.0
let IS_IPHONE_6          =  SCREEN_HEIGHT == 667.0
let IS_IPHONE_6_PLUS     =  SCREEN_HEIGHT == 736.0


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


public func equalDate(fromDateDate: Date, toDate: Date) -> Bool {
    let formatter = DateFormatter()
    formatter.dateFormat = DPDateFormatter.date
    let selectedDateStr = formatter.string(from: fromDateDate) //
    let todayDateStr = formatter.string(from: toDate)
    return todayDateStr == selectedDateStr ? true : false
}

public func getMinutesDiffFromTwoTimes (toTime: String, fromTime: String) -> Int64{
    let timeformatter = DateFormatter()
    timeformatter.dateFormat = DPDateFormatter.timeFormat
    if let interval = timeformatter.date(from: toTime)?.timeIntervalSince(timeformatter.date(from: fromTime)!) {
        return Int64(interval / 60)
    }
    return 0
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
    
    public static func thumbnil(fromUrl: URL) -> UIImage? {
        let localPathVideo = FileManager.videoFolderPath.appending(fromUrl.lastPathComponent)
        if FileManager.default.fileExists(atPath: localPathVideo){
            let asset: AVAsset = AVAsset(url: URL.init(fileURLWithPath: localPathVideo))
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            do {
                let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
                return UIImage(cgImage: thumbnailImage)
            } catch {}
        }else{
            let asset: AVAsset = AVAsset(url: fromUrl)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            do {
                let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
                return UIImage(cgImage: thumbnailImage)
            } catch {}
        }
        let blackView = UIView.init(frame: UIScreen.main.bounds)
        blackView.backgroundColor = UIColor.black
        return DPConstant.imageFrom(view: blackView)
        
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

public enum APIMode: Int {
    case testing = 0
    case staging = 1
    case production = 2
}

public class DPConfigClass {
    public static let dlkappname          = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? ""
    public static let dlkappVersion       = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    public static var sharedInstance      = DPConfigClass()

    #if DEVELOPMENT
    public var baseWebAppURL = "https://appstaging.preto3.com/"
    public var baseLoginURL  = "https://apistaging.preto3.com/"
    public var baseURL       = "https://apistaging.preto3.com/"
    public var baseCardURL   = "https://stage.wepayapi.com/"
    public var baseBankURL   = "https://stage-iframe.wepay.com/"
    public var client_Id     = "118866"

    #else
    public var baseWebAppURL = "https://app.preto3.com/"
    public var baseLoginURL  = "https://api.preto3.com/"
    public var baseURL       = "https://api.preto3.com/"
    public var baseCardURL   = "https://wepayapi.com/"
    public var baseBankURL   = "https://iframe.wepay.com/"
    public var client_Id     = "93750"

    #endif
    
//#if DEVELOPMENT
//public var baseWebAppURL = "https://appstaging.preto3.com/"
//public var baseLoginURL  = "https://apistaging.preto3.com/"
//public var baseURL       = "https://apistaging.preto3.com/"
//public var baseCardURL   = "https://stage.wepayapi.com/"
//public var baseBankURL   = "https://stage-iframe.wepay.com/"
//public var client_Id     = "118866"
//
//#else
//    public var baseWebAppURL = "https://appstaging.preto3.com/"
//    public var baseLoginURL  = "https://apistaging.preto3.com/"
//    public var baseURL       = "https://apistaging.preto3.com/"
//    public var baseCardURL   = "https://stage.wepayapi.com/"
//    public var baseBankURL   = "https://stage-iframe.wepay.com/"
//    public var client_Id     = "118866"
//
//#endif
}

public struct DPValidation {
    
    public static let dlkInternet         = "Please check your internet connection and try again"
    public static let dlkServer           = "Server is not responding. Please try again later"
    public static let emailUserName       = "Please enter Email"
    public static let validEmail          = "Please enter a valid Email address to continue"
    public static let email               = "Please enter your Email address to continue"
    public static let oldPassword         = "Please enter your current Password to continue"
    public static let password            = "Please enter your password to continue"
    public static let photoID             = "Please select Photo ID"
    public static let pickupTime          = "Please select pickup time"
    public static let pickupAddress       = "Please enter pickup address"
    public static let dropAddress         = "Please enter drop address"
    public static let passwordChar        = "Password must contain minimum 8 characters"
    public static let confirmPassword     = "Please enter new password"
    public static let passwordUnmatch     = "Both the password must be same"
    public static let noMessageFromServer = "No message from Server side"
    public static let dpLogoutMessage     = "Are you sure you want to logout?"
    public static let CovidMsg            = "Are you sure you want to Proceed?"
    public static let dpLogout            = "Yes"
    public static let selectSchool        = "Please select your Institution"
    public static let schoolName          = "Please enter Institute Name"
    public static let className           = "Please enter room Name"
    public static let firstName           = "Please enter First Name"
    public static let lastName            = "Please enter Last Name"
    public static let selectRole          = "Please select a Role"
    public static let validPhone          = "Please enter valid Phone Number"
    public static let phone               = "Please enter Phone Number"
    public static let noResult            = "No Results found"
    public static let selectClass         = "Please select a room"
    public static let selectAdminStaff    = "Please select at least one Role"
    public static let selectParent        = "Please select a Parent"
    public static let parentToStudent     = "Please select a Student which have parent"
    public static let validWebsite        = "Please enter correct website format like https://www.apple.com"
    public static let validUrl            = "URL invalid"
    public static let validZipCode        = "Please enter valid Zip Code"
    public static let validEANNumber      = "Please enter valid EIN Number"
    public static let validSSNNumber      = "Please enter valid SSN Number"
    public static let classExist          = "You have already added this room. Please enter different name"
    public static let checkInOutPin       = "Please enter Check In - Out Pin"
    public static let validCheckInOutPin  = "Please enter valid Check In - Out Pin"
    public static let dob                 = "Please enter Date of Birth"
    public static let medications         = "Please enter Medications name"
    public static let allergies           = "Please enter Allergy name"
    public static let remarks             = "Please enter Remarks"
    public static let inOutTimeChange     = "Please change either In Time,Out Time or remark"
    public static let validInOutTime      = "Out Time can not be less than to In Time"
    public static let adjustTime          = "Please enter adjusted time."
    public static let selectUsers         = "Please select at least one Recipient"
    public static let selectCountry       = "Please select Country"
    public static let selectState         = "Please select State"
    public static let selectCity          = "Please select City"
    public static let addUsers            = "Please add Recipient"
    public static let enterSubject        = "Please enter Subject"
    public static let enterMessage        = "Please enter Message"
    public static let noContactDetail     = "No Contact Detail"
    public static let teacherExist        = "Teacher is already assigned with this email address."
    public static let noSchoolFound       = "No institute found. Please try again later."
    public static let removeStaff         = "Are you sure you want to remove this staff ?"
    public static let deleteStaff         = "Are you sure you want to delete this staff ?"
    public static let deleteStudent       = "Are you sure you want to delete this student ?"
    public static let deleteClass         = "Are you sure you want to delete this room ?"
    public static let resendInvoice          = "Are you sure you want to resend invoice?"
    public static let deleteInvoices         = "Are you sure you want to delete invoices?"
    public static let deleteInvoice          = "Are you sure you want to delete invoice?"
    public static let cancelAutoPayInvoice   = "Are you sure you want to cancel auto pay for this invoice?"
    public static let enableAutoPayInvoice   = "Are you sure you want to start auto pay for this invoice?"
    public static let deleteAuthorizedPickup = "Are you sure you want to delete authorize pickup?"
    public static let createInvoice          = "Are you sure you want to create invoice for selected students?"
    public static let updateInvoice          = "Are you sure you want to apply changes?"
    public static let updateRecurringInvoice = "Your changes to the invoice will be applied from next billing cycle. Are you sure you want to apply changes?"
    public static let refundInvoice       = "Are you sure you want to refund?"
    public static let removeClass         = "Are you sure you want to remove this room ?"
    public static let deleteMedia         = "Are you sure you want to delete this media ?"
    public static let noStudentFound      = "No Student Found"
    public static let noParentTypeFound   = "No Parent Type Found"
    public static let noStaffFound        = "No Staff Found"
    public static let noClassChange       = "No changes has been done."
    public static let noCamera            = "You don't have camera in your device"
    public static let childInfoSaved      = "Make sure your Child Information is saved ?"
    public static let noClassFound        = "No Room found"
    public static let noPositionFound     = "No Position found"
    public static let noDetachStaff       = "You are admin of this institute. So you can not detach from your staff Role"
    public static let removeAssignedClasses      = "Please remove assigned rooms in order to remove as staff then save your changes."
    public static let disablesPhotoPermission    = "You have disabled the Photo Library permission. So would you like to enable the permission ?"
    public static let disablesCameraPermission   = "You have disabled the Camera permission. So would you like to enable the permission ?"
    public static let disablesLocationPermission = "You have disabled the Location permission. So would you like to enable the permission ?"
    public static let requestStopRecurring    = "Are you sure you want to stop the recurring payment cycle for this invoice?"
    public static let approveStopRecurring    = "Are you sure you want to approve stop recurring request for this invoice?"
    public static let deleteCheckInOut        = "Are you sure you want to delete this activity?"
    public static let fromDate                = "Please select Start Date."
    public static let toDate                  = "Please select End Date."
    public static let selectDate              = "Please select at least one pickup date"
    public static let fromToDateError         = "Start Date can not be greater than End Date"
    public static let cardDetail              = "Please enter all Card details"
    public static let validDate               = "Please enter the valid date"
    public static let PostalCode              = "Please enter the Postal Code"
    public static let PostalValidation        = "Please enter 5 digit Postal Code"
}

struct APIName {
    // Get schools type
    static var getSchoolType              = "user/school/type"
    static var getLanguages               = "language/all"
    static var logout                     = "logout"
    static var appUpdateVersion           = "forceUpdate"
    static var forceUpdate                = "forceUpdate"
    // Sign UP school and user
    static var schoolSignUp               = "user/school/signUp"
    static var joinASchool                = "user/school/join"
    
    // Sign In
    static var authToken                  = "login"
    static var registerDeviceInfo         = "user/registerDeviceInfo"
    static var userRoles                  = "user/roles"
    
    // Password
    static var forgotPassword             = "user/password/forgot"
    static var setPassword                = "user/password/set"
    static var changePassword             = "user/password/change"
    
    // Classes
    static var addEditClass               = "class/addEdit"
    static var deleteClass                = "class/delete"
    static var getClasses                 = "class/all"
    static var getAllClassWithRatio       = "class/allWithStaff"
    static var assignStaffStudent         = "class/assignStaffStudent"
    static var getARoomWithStaff          = "class/getARoomWithStaff"
   
    // Staff
    static var addEditStaff               = "staff/addEdit"
    static var addUpdateSchoolTimeClock   = "profile/addUpdateSchoolTimeClockDetails"
    static var deleteStaff                = "staff/delete"
    static var getStaffs                  = "staff/all"
    static var detachStaff                = "staff/detach"
    static var getStaffPositions          = "profile/getStaffPositions"
    static var switchAdminRole            = "profile/admin/switchAdminRole"
    
    // Students
    static var addStudent                 = "student/addEdit"
    static var newAddEditStudent          = "student/editStudentPersonalProfileDetails"
    static var getStudents                = "student/all"
    static var deleteStudent              = "student/delete"
    static var studentById                = "student/studentById"
    static var getRaceList                = "student/getRaceList"
    static var getEthnicityList           = "student/getEthnicityList"
    
    // Parent
    static var addEditParent              = "parent/addEdit"
    static var getParents                 = "parent/all"
    static var deleteParent               = "parent/delete"
    static var getParentType              = "parent/relations"
    static var sendReminder               = "dashboard/remindInactiveParents"
    static var addEditStudentParentDetails   = "student/addEditStudentParentDetails"
    static var addEditStudentEmergencyContactDetails = "student/addEditStudentEmergencyContactDetails"
    static var deleteStudentParentDetails    =  "student/deleteStudentParentDetails"
    static var deleteStudentEmergencyDetails = "student/deleteStudentEmergencyDetails"
    static var sendParentRegEmail            = "student/sendParentRegEmail"
    // Student Check In and Check Out
    static var getStudentCheckInOut       = "checkinout/student/all" // get data by date
    static var studentCheckInOut          = "checkinout/student/add" // check in and check out
    static var studentEditCheckInOut      = "checkinout/student/edit" // edit check in and check out time
    
    // Staff Check In and Check Out
    static var getStaffCheckInOut         = "checkinout/staff/all" // get data by date
    static var staffCheckInOut            = "checkinout/staff/add" // check in and check out
    static var staffEditCheckInOut        = "checkinout/staff/edit" // edit check in and check out time
    static var singleStaffCheckInOut      = "/checkinout/singlestaff/add"
    static var staffAddMissedCheckInOut   = "checkinout/staff/addMissedActivity" // edit check in and check out time
    static var staffDeleteActivity        = "checkinout/staff/deleteActivity"
    
    // Check In and Check Out Report
    static var staffCheckInOutReport      = "checkinout/report/staffNew"
    static var studentCheckInOutReport    = "checkinout/report/student"
    static var classCheckInOutReport      = "checkinout/report/class"
  //static var staffCheckInOutReportDownload = "checkinout/report/staff/download/"//OLD
    static var staffCheckInOutReportDownload = "checkinout/report/staff/downloadNew/"
    static var studentCheckInOutReportDownload = "checkinout/report/student/download/"
    static var classCheckInOutReportDownload   = "checkinout/report/class/download/"
    
    // Country, State, City
    static var country                    = "country/all"
    static var state                      = "state/all"
    static var city                       = "city/all"
    
   // Dashobard
   //static var getAdminDashBoardMobile   = "dashboard/getAdminDashBoardMobile"
    static var getAdminDashBoardMobile    = "dashboard/getAdminDashBoardForMobileNew"
    
    static var getBirthdays               = "dashboard/getBirthdays"
    static var staffDashboard             = "dashboard/getStaffDashBoardNew"
    static var parentDashboard            = "dashboard/getParentDashBoard"
    static var getStaffRatioCount         = "dashboard/getStaffRatioCount"
    static var getStudentRatioCount       = "dashboard/getStudentRatioCount"
    static var moduleMenu                 = "dashboard/moduleMenu"
    static var moduleMenuMobile           = "dashboard/moduleMenuMobile"
    static var getTodayScheduledCount     = "dashboard/getTodayScheduledCount"
    
    // Profile
    static var getAdminProfile            = "profile/admin"
    static var getStaffProfile            = "profile/staff"
    static var getParentProfile           = "profile/parent"
    static var saveAdminProfile           = "profile/admin/save"
    static var saveStaffProfile           = "profile/staff/save"
    static var saveParentProfile          = "profile/parent/save"
    static var emailVerify                = "dashboard/school/verificationEmail"
    
    // Communication
    static var composeComunication        = "composemessage"
    static var comunicationSummary        = "communicationsummary"
    static var comunicationDetail         = "communicationdetails"
    static var comunicationReply          = "sendreply"
    static var getUserList                = "getuserlist"
    static var uploadMediaFile            = "file/communication/uploadFile"
    static var allUser                    = "communication/user/all"
    static var composeNewMessage          = "communication/send"
    static var chatList                   = "communication/list/"
    static var conversation               = "communication/"
    static var communicationV2            = "communication/v2/send"
    static var createGroup                = "communication/group"
    static var deleteMember               = "communication/group/member"
    static var chatMessages               = "communication/message"
    static var thread                     = "communication/thread"
    static var messagesList               = "communication/messages"
    // Image Upload
    static var imageUpload                = "file/uploadFile"
    
    // Daily Activity
    static var activitiesType             = "activity/getActivityMapList"
    static var createEditActivity         = "activity/saveOrUpdateActivity"
    static var deleteActivity             = "activity/deleteActivityDetail"
    static var getActivities              = "activity/getActivityDetailByStudent"
    static var activityDetail             = "activity/getActivityDetail"
    
    // Calendar
    static var addEditEvent               = "event/saveOrUpdateEvent" // same for add and edit
    static var getEvents                  = "event/getEventDetail" // same for list and detail
    static var deleteEvent                = "event/eventDelete/"
    static var respondEvent               = "event/respondEvent"
    
    // Schedule
    static var getStudentSchedule         = "student/getStudentSchedule"
    static var addStudentSchedule         = "student/addStudentSchedule"
    static var editStudentSchedule        = "student/editStudentSchedule/"
    static var deleteStudentSchedule      = "student/deleteStudentSchedule/"
    static var addStaffSchedule           = "staff/addStaffSchedule"
    static var getStaffSchedule           = "staff/getStaffSchedule"
    static var editStaffSchedule          = "staff/editStaffSchedule"
    static var deleteStaffSchedule        = "staff/deleteStaffSchedule"
    
    // Check In/Out with PIN
    static var checkinoutWithPin          = "checkinout/staffAndStudent"
    static var generateResetPIN           = "profile/generatePin"
    
    // Invoice
    static var getInvoiceCounts           = "invoice/getInvoiceCounts"
    static var paymentMode                = "invoice/getPaymentModeList"
    static var invoiceType                = "invoice/getInvoiceFeeTypeList"
    static var invoiceList                = "invoice/getInvoiceList"
    static var invoiceStateList           = "invoice/getInvoiceStateList"
    static var invoicePaymentHistory      = "invoice/getPaymentHistory"
    static var resendInvoice              = "invoice/resendInvoice"
    static var downloadInvoice            = "invoice/downloadInvoice"
    static var posInvoice                 = "invoice/saveOrUpdateInvoicePayment"
    static var createInvoice              = "invoice/saveOrUpdateInvoice"
    static var UpdateInvoiceRecurringStatus = "invoice/UpdateInvoiceRecurringStatus"
    static var updateAutoPayStatus        = "invoice/updateUserAutoPayPreference"
    static var deleteInvoice              = "invoice/deleteInvoice"
    static var sendBulkInvoice            = "invoice/sendBulkInvoice"
    static var refund                     = "/wepay/checkout/refund"
    
    // Receipt
    static var resendReceipt              = "invoice/resendReceipt"
    static var refundReceipt              = "wepay/checkout/refund"
    static var downloadReceipt            = "invoice/downloadReceipt"
    
    // Pay
    static var payInvoice                 = "pay/invoice/"
    
    //Authorized Pickup
    static var addAuthorizedPickUp        = "addAuthorizedPickUp"
    static var editpickUps                = "editpickUps"
    static var allpickUps                 = "allpickUps"
    static var deletePickUps              = "deletepickUps"
    static var validatePickup             = "validatePickUps"
    static var reminderByAuthorizedPickUpPerson = "reminderByAuthorizedPickUpPerson"
    
    //New punchmaster
    static var punchMasterCheckInOut      = "checkinout/punchMasterCheckInOutWithCovidQuestions"
    static var multiplePersonCheckInOut   = "checkinout/multiplePersonCheckInOut"
    static var multipleStudentCheckInOut  = "checkinout/multipleStudentCheckInOut"
    static var sendCovidNotificationtoAdmin = "checkinout/sendCovidNotificationtoAdmin"
    //Notes
    static var allNotes                   = "notes/allnotes"
    static var deleteNote                 = "notes/deleteNotes"
    static var saveNotes                  = "notes/saveNotes"
    static var editNotes                  = "notes/editNotes"
    ///wepay
    static var wepay_credit_card          = "wepay/credit_card"
    static var wepay_payment_bank         = "wepay/payment_bank"
    static var wepay_Checkout             = "wepay/checkout"
    static var credit_Card_create         = "v2/credit_card/create"
    static var wepay_deleteCreditCard     = "wepay/deleteCreditCard"
    static var credit_card_create         = "v2/credit_card/create"
    static var paymentMethods_bank        = "paymentMethods/bankAccount?client_id="
    static var client_Id_Production       = "93750"
    static var client_Id_staging          = "118866"
}

struct APIKeyName {
    static var lastUpdatedTime            = "lastUpdatedTime"
    static var apiParams                  = "apiParams"
    static var apiName                    = "apiName"
    static var message                    = "message"
    static var code                       = "code"
    static var file                       = "file"
}

struct UserDefaultsKeyName {
    static var deviceToken                = "deviceToken"
    static let selectedUserRole           = "selectedUserRole"
    static let skipLetsExplore            = "skipLetsExplore"
    static let demoClassUserShown         = "demoClassUserShown"
    static let firstTime                  = "firstTime"
    static let syncGetAPIs                = "syncGetAPIs"
    static let oneTimeSyncData            = "oneTimeSyncData"
    static let testHostUrl                = "testHostUrl"
}

struct APICallTimeKeyName {
    static var getClasses                 = "getClasses"
    static var getStaffs                  = "getStaff"
    static var getStudents                = "getStudents"
    static var getParents                 = "getParents"
    static var getActivitiesType          = "getActivitiesType"
    static var country                    = "country"
    static var state                      = "state"
    static var city                       = "city"
    static var student                    = "student"
}

public struct DPKeysProject {
    static let username                   = "userEmailid"
    static let password                   = "userPassword"
    static let accessToken                = "accessToken"
    static let isLogin                    = "isLogin"
    static let kDeviceToken               = "kDeviceToken"
    static let loginUser                  = "loginUser"
    static let dateFormate                = "dd-MMM-yyyy"
    static let apiDateFormate             = "yyyy-MM-dd'T'HH:mm:ss"
    static let appDateFormate             = "MMM dd,yyyy h:mm a"
    static let allowedCharacters          = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_+~:{}|\"?><\\`,./;'[]=-"
    static let baseUrl                    = ""
    static let imageUrl                   = ""
    static let isEmailVerified            = "isEmailVerified"
    static let qrCode                     = "qrCode"
    static let isRefresDashboard          = "isRefresDashboard"
    static let isRefreshRoom              = "isRefreshRoom"
}

struct DPDateFormatter {
    public static let dateFormatServer    =  DPKeysProject.apiDateFormate
    public static let date                = "MMM d, yyyy"
    public static let dobDate             = "dd/MM/yyyy"
    public static let dobServer           = "yyyy-MM-dd"
    public static let dobServerWithtime   = "yyyy-MM-dd h:mm a"
    public static let time24Format        = "HH:mm:ss"
    public static let timeFormat          = "h:mm a"
    public static let dateAndMonth        = "dd MMM"
    public static let dateAndTime         = "MMM d, yyyy h:mm a"
    public static let dateAndTimeWithSecond   = "MMM d, yyyy hh:mm:ss a"
    public static let appDateFormat       = "EEEE MMM d, yyyy"
    public static let staffDateFormat     = "EEE, MMM d, yyyy"
    public static let addEventOnlyDateFormate = "MM-dd-yyyy"
    public static let addEventDateFormat      = "MM-dd-yyyy h:mm a"
    public static let activityDetailViewDateFormat       = "MM-dd-yyyy h:mm a"
    public static let dailyActivityDetailViewDateFormat  = "MM-dd-yyyy"
    public static let dobDateWithDash       = "dd-MM-yyyy"
    public static let newDateFormat         = "MM/dd/yyyy"
    public static let newDateFormatWithDay  = "EEEE MM/dd/yyyy"
    public static let onlyMonthDate         = "MM/dd"
    public static let MonthYear             = "MM-yyyy"
    public static let AuthorizeDate         = "yyyy-MM-dd"
    public static let DemoDate              = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    public static let activityFormat        = "MM/dd/yyyy h:mm a"
    public static let dailyActivityFormat   = "MM/dd/yyyy"
}
