//
//  Global.swift
//  chilax
//
//  Created by Tops on 6/13/17.
//  Copyright © 2017 Tops. All rights reserved.
//
//

import UIKit
//MARK: -  Global Class
    /**
     Create **Global** class to use :
    - Global **object** or variable in entire app
    - Global **Structure** for entire app
    - Global **functions** for entire app

     */
class Global {
    
    //MARK: -  Device Compatibility
    /**
     Create is_Device to Check which device is available
     - Author:
     Magnates technologies Pvt. Ltd
     
     -Returns:
     return **true** or **false**
     
     - Parameters:
     - **_iPhone**: Check the device is iPhone?
     - **_iPad**: Check the device is iPad?
     - **_iPod**: Check the device is iPod?

     */

    struct is_Device {
        static let _iPhone = (UIDevice.current.model as String).isEqual("iPhone") ? true : false
        static let _iPad = (UIDevice.current.model as String).isEqual("iPad") ? true : false
        static let _iPod = (UIDevice.current.model as String).isEqual("iPod touch") ? true : false
    }
    
    //MARK: -  iPhone Size Compatibility
    /**
     Create is_iPhone to Check Device Compatibility
     
     - **_6p**: Check the device is 6Plush or Greater?
     - **_6**: Check the device is 6?
     - **_5**: Check the device is 5?
     - **_4**: Check the device is 4?
     
     @return : return **true** or **false**
     */
    struct is_iPhone {
        static let _6p = (UIScreen.main.bounds.size.height >= 736.0 ) ? true : false
        static let _6 = (UIScreen.main.bounds.size.height <= 667.0 && UIScreen.main.bounds.size.height > 568.0) ? true : false
        static let _5 = (UIScreen.main.bounds.size.height <= 568.0 && UIScreen.main.bounds.size.height > 480.0) ? true : false
        static let _4 = (UIScreen.main.bounds.size.height <= 480.0) ? true : false
    }

    //MARK: -  iOS Version Compatibility
    /**
     Create **is_iOS** to Check Device Compatibility
     
     - **_10** : Check the iOS is Greater than or equal to 10.0?
     - **_9** : Check the iOS is Greater than or equal to 9.0 and less than 10.0?
     - **_8** : Check the iOS is Greater than or equal to 8.0 and lessthan 9.0?
     
     @return : return **true** or **false**
     */
    struct is_iOS {
        static let _10 = ((Float(UIDevice.current.systemVersion as String))! >= Float(10.0)) ? true : false
        static let _9 = ((Float(UIDevice.current.systemVersion as String))! >= Float(9.0) && (Float(UIDevice.current.systemVersion as String))! < Float(10.0)) ? true : false
        static let _8 = ((Float(UIDevice.current.systemVersion as String))! >= Float(8.0) && (Float(UIDevice.current.systemVersion as String))! < Float(9.0)) ? true : false
    }
    
    //MARK: -  Shared classes
    /**
     This is the list of **Shared Class**. We can say its a our applicaion's `Singleton', you can use any where inside the app
     - appDelegate: AppDelegate's Singleton object
     - singleton: Custom app Singleton's object to store value Globlly inside the app
     - screenWidth: return screen with
     - baseURLPath: Return App Base URL, useful for API calling
     
     - Author:
     Magnates technologies Pvt. Ltd
     
     -Returns:
     return a **single Instance** in the app
     */

    
    static let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    static let singleton = Singleton.sharedSingleton
    //static let appPushNotifHandler = AppPushNotifHandler.shareAppPushNotifHandler
    // MARK: -  Screen size
    static let screenWidth : CGFloat = (Global.appDelegate.window!.bounds.size.width)
    static let screenHeight : CGFloat = (Global.appDelegate.window!.bounds.size.height)
    
    // MARK: -  Web service Base URL
    static let baseURLPath = "http://MyApp.com/mobile/web/api/"
    static let BlogBaseURLPath = "https://info.MyApp.com/wp-json/wp/v2/"
    
    static let isBarCode = "2"
    static let isQRCode = "1"

    //MARK: -  RGB
    /**
     RGB is a common usefull function, it returns RBG color of your RGB values
     - Author:
     Magnates technologies Pvt. Ltd
     
     - Returns:
     return RGB Color
     
     - Parameters:
       - r: Red color value
       - g: Green color value
       - b: Blue color value
       - a: alpha color value
     */
    
    func RGB(r: Float, g: Float, b: Float, a: Float) -> UIColor {
        return UIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue: CGFloat(b / 255.0), alpha: CGFloat(a))
    }
    
    // MARK: -  Dispatch Delay
    func delay(delay: Double, closure: @escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    func getLocalizeStr(key: String) -> String {
        return LocalizeHelper.sharedLocalSystem().localizedString(forKey: key)
    }
    
    //MARK: -  TIME FORMAT
    func TimeFormatter_12H() -> DateFormatter {
        //06:35 PM
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter
    }
    
    func TimeFormatter_24_H() -> DateFormatter {
        //19:29:50
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }
    //MARK: DATE FORMAT
    func dateFormatterFullWiteTimeZone() -> DateFormatter {
        //2016-10-24 19:29:50 +0000
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return dateFormatter
    }
    
    func dateFormatterFull_DMY_HMS() -> DateFormatter {
        //24-10-2016 19:29:50
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        return dateFormatter
    }
    
    func dateFormatter() -> DateFormatter {
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter
    }
    
    func dateFormatterForDisplay() -> DateFormatter {
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        return dateFormatter
    }
    func dateFormatterMMDDYYY() -> DateFormatter {
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter
    }
    
    func dateFormatterForDisplay_DMMMY() -> DateFormatter {
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        return dateFormatter
    }
    func dateFormatterForCall() -> DateFormatter {
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }
    func dateFormatterForYearOnly() -> DateFormatter {
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter
    }
    func dateFormatterForMonthINNumberOnly() -> DateFormatter {
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter
    }
    func dateFormatterForDaysMonthsYears() -> DateFormatter {
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE, d LLL yyyy"
        return dateFormatter
    }
    func dateFormatterForYMD_T_HMSsss() -> DateFormatter {
        //yyyy-MM-dd'T'HH:mm:ss.SSS
        //"Date": "2016-12-15T00:00:00",
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        return dateFormatter
    }
    
    func dateFormatterForYMD_T_HMS() -> DateFormatter {
        //yyyy-MM-dd'T'HH:mm:ss
        //"Date": "2016-12-15T00:00:00",
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter
    }
    
    // MARK: -  Application Colors
    struct kAppColor {
        static let AppTheamColor = Global().RGB(r: 126.0, g: 0.0, b: 1.0, a: 1.0)
         static let SlectedTabColor = Global().RGB(r: 248.0, g: 46.0, b: 63.0, a: 1.0)
        
    }
    
    // MARK: -  Application Name
    static let kAppName = "MyAppName"
    static let kPlaceAPiKey = "AIzaSyB8vow9vHFb9UyxlxQ1GzDkjLlwEdnkHvE"
    static let kHistoryTable = "History"
    static let kBarTable = "tblBarCode"
    
    // MARK: -  Application Fonts
    struct kFont {
        static let SourceRegular = "SourceSansPro-Regular"
        static let SourceSemiBold = "SourceSansPro-Bold"
        static let SourceBold = "SourceSansPro-SemiBold"
        static let MyAppTops = "MyApp_TOPS"
    }
    
    // MARK: - 
    struct LanguageData {
        static let English: String! = "en"
        static let Dutch: String! = "nl"
        static let French: String! = "fr"
        static let German: String! = "de"
        
        static let SelLanguageKey: String! = "MyAppSelLanguage"
        var SelLanguage: String! = Global.singleton.retriveFromUserDefaults(key: Global.LanguageData.SelLanguageKey) ?? ""
    }
    
    // MARK: -  User Data
    static let IsFirstTimeInstall: String! = "QRApplaunchedBefore"
    static let IsCreatedBusinessCard: String! = "QRAppBussinessCard"
    static let myBusinessCard: String! = "QRAppmyBusinessCard"
    
    struct kLoggedInUserKey {
        static let IsFirstTimeLogIn: String! = "MyAppUserFisttimeLoggedIn"
        static let IsLoggedIn: String! = "MyAppUserIsLoggedIn"
        static let IsPassword: String! = "MyAppUserIsPassword"
        static let AccessToken: String! = "MyAppUserAccessToken"
        static let Id: String! = "MyAppUserId"
        static let Salutation: String! = "MyAppUserSalutation"
        static let Title: String! = "MyAppUserTitle"
        static let FirstName: String! = "MyAppUserFName"
        static let LastName: String! = "MyAppUserLName"
        static let UserName: String! = "MyAppUserName"
        static let Password: String! = "MyAppUserPassword"
    }
    
    struct kQRAppSettingKeys {
        static let BeepSound: String! = "QRAppBeepSound"
        static let Vibration: String! = "QRAppVibration"
        static let DisplayLaser: String! = "QRAppDisplayLaser"
        static let MyCardcontactId: String! = "MyCardContactId"
        static let MyContactDetail : String! = "MyContactDetail"
    }
    
    struct kQRAppSettingData {
        var isBeepSound: String? = Global.singleton.retriveFromUserDefaults(key: Global.kQRAppSettingKeys.BeepSound)
        var isVibrate: String? = Global.singleton.retriveFromUserDefaults(key: Global.kQRAppSettingKeys.Vibration)
        var isDisplayLaser: String? = Global.singleton.retriveFromUserDefaults(key: Global.kQRAppSettingKeys.DisplayLaser)
    }
    
    // MARK: -  String Type for Validation
    enum kStringType : Int {
        case AlphaNumeric
        case AlphabetOnly
        case NumberOnly
        case Fullname
        case Username
        case Email
        case PhoneNumber
    }
    
    // MARK: -  Static Webpage URL
    struct kWebPageURL {
        static let PrivacyPolicy = "https://info.MyApp.com/privacy-policy/"
        static let Contact = "https://info.MyApp.com/contact/"
        static let AboutUs = "https://info.MyApp.com/about-us/"
    }
    
    struct kUserRole {
        static let Driver = "1"
        static let User = "2"
        static let Both = "3"
    }
    
    struct kReviewRatingColor {
        static let Rate0 = Global().RGB(r: 200.0, g: 200.0, b: 200.0, a: 1.0)
        static let Rate1 = Global().RGB(r: 229.0, g: 9.0, b: 0.0, a: 1.0)
        static let Rate2 = Global().RGB(r: 219.0, g: 122.0, b: 0.0, a: 1.0)
        static let Rate3 = Global().RGB(r: 194.0, g: 210.0, b: 0.0, a: 1.0)
        static let Rate4 = Global().RGB(r: 82.0, g: 200.0, b: 0.0, a: 1.0)
        static let Rate5 = Global().RGB(r: 0.0, g: 191.0, b: 19.0, a: 1.0)
    }
    
    static let kDeviceTypeWS = "1"   //1 for ios and 2 for Android
    
    struct kTextFieldProperties {
        static let BorderColor = Global().RGB(r: 225.0, g: 225.0, b: 225.0, a: 1.0).cgColor
    }
    struct kTextFieldBorderProperties {
        static let BorderColor = Global().RGB(r: 42.0, g: 82.0, b: 134.0, a: 1.0).cgColor
    }
    // MARK: -  Web services keyName
    struct kSearchFilterParamKey {
        static let PatientID: String! = "MPPatientId"
        static let Keyword: String! = "MPkeyword"
        static let Category: String! = "MPCategory"
    }
}
