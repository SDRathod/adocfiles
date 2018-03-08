                                          //
//  Singleton.swift
//  chilax
//
//  Created by Tops on 6/13/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit
import ISMessages
import Contacts
                                          
@objc protocol SingletonDelegate {
    @objc optional func didSelectLanguage()
}
                                          
class Singleton: NSObject {
    
    static let sharedSingleton = Singleton()
    
    var isMultipleScanning : Bool = true
    var isQRScanning : Bool = true
    var contactStoreGlobal: String? = ""
    
    
    // MARK: -  Device Specific Method
    func getDeviceSpecificNibName(_ strNib: String) -> String {
        if Global.is_iPhone._4 {
            return strNib + ("_4")
        }
        else {
            return strNib
        }
    }
    
    func getDeviceSpecificFontSize(_ fontsize: CGFloat) -> CGFloat {
        return ((Global.screenWidth) * fontsize) / 320
    }
    
    func setContactStoreId(_ contactStore : String) {
        self.contactStoreGlobal = contactStore
    }
    func getContactStoreId() -> String {
        return self.contactStoreGlobal!
    }
    
    // MARK: -  UserDefaults Methods
    func saveToUserDefaults (value: String, forKey key: String) {
        let defaults = UserDefaults.standard
        defaults.set(value , forKey: key as String)
        defaults.synchronize()
    }
    
    
    func retriveFromUserDefaults (key: String) -> String? {
        let defaults = UserDefaults.standard
        if let strVal = defaults.string(forKey: key as String) {
            return strVal
        }
        else{
            return "" as String?
        }
    }
    func saveToUserDefaultsWithContactObject(contact : Data, forKey key: String)  {
        let defaults = UserDefaults.standard
        defaults.set(contact , forKey: key as String)
        defaults.synchronize()
    }
    
    func retriveFromUserDefaultsWithContactObject (key: String) -> Data? {
        let defaults = UserDefaults.standard
        if let strVal = defaults.object(forKey:key) {
            
            return strVal as? Data
        }
        else{
            let contact :Data = Data ()
            return contact
        }
    }
    
    // MARK: -  String RemoveNull and Trim Method
    func removeNull (str:String) -> String {
        if (str == "<null>" || str == "(null)" || str == "N/A" || str == "n/a" || str.isEmpty) {
            return ""
        } else {
            return str
        }
    }
    
    func kTRIM(string: String) -> String {
        return string.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    // MARK: -  Attributed String
    func setButtonStringMyAppFontBaseLine(_ strText: String, floatIconFontSize:CGFloat, floatTextFontSize: CGFloat, floatBase: CGFloat, intIconPos: Int) -> NSMutableAttributedString { //first character Chilax font and other all GothamBook font
        let attributedString = NSMutableAttributedString(string: strText)
        if (intIconPos == 1) {//first character icon
            attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: Global.kFont.MyAppTops, size: Global.singleton.getDeviceSpecificFontSize(floatIconFontSize))!, range: NSRange(location: 0, length: 1))
            attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(floatTextFontSize))!, range: NSRange(location: 1, length: strText.characters.count-1))
            attributedString.addAttribute(NSAttributedStringKey.baselineOffset, value: Global.singleton.getDeviceSpecificFontSize(floatBase), range: NSRange(location: 1, length: strText.characters.count-1))
        }
        else if (intIconPos == 2) {//last character icon
            attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: Global.kFont.MyAppTops, size: Global.singleton.getDeviceSpecificFontSize(floatTextFontSize))!, range: NSRange(location: 0, length: strText.count-1))
            attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(floatIconFontSize))!, range: NSRange(location: strText.count-1, length: 1))
        }
        return attributedString;
    }
    
    // MARK: -  Get string size Method
    func getSizeFromString (str: String, stringWidth width: CGFloat, fontname font: UIFont, maxHeight mHeight: CGFloat) -> CGSize {
        let rect : CGRect = str.boundingRect(with: CGSize(width: width, height: mHeight), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font:font], context: nil)
        return rect.size
    }
    
    func getSizeFromAttributedString (str: NSAttributedString, stringWidth width: CGFloat, maxHeight mHeight: CGFloat) -> CGSize {
        let rect : CGRect = str.boundingRect(with: CGSize(width: width, height: mHeight), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        return rect.size
    }
     
    // MARK: -  Attributed String
    func setStringLineSpacing(_ strText: String, floatSpacing: CGFloat, intAlign: Int) -> NSMutableAttributedString {
        //o=center  1=left = 2=right
        let attributedString = NSMutableAttributedString(string: strText)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = floatSpacing
        if intAlign == 0 {
            paragraphStyle.alignment = .center
        }
        else if intAlign == 1 {
            paragraphStyle.alignment = .left
        }
        else {
            paragraphStyle.alignment = .right
        }
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: (strText.characters.count )))
        return attributedString
    }
    
    // MARK: -  TextField Validation Method
    func validateEmail(strEmail: String) -> Bool {
        let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: strEmail)
    }
    
    func validatePhoneNumber(strPhone: String) -> Bool {
        let phoneRegex: String = "([0-9]{8,15})"
        let test = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return test.evaluate(with: strPhone)
    }
    
//    // MARK: -  Show Message on Success and Failure
    func showSuccessAlert(withMsg message: String) {
        
        //AJNotificationView.showNotice(in: self.view, type: AJNotificationTypeGreen, title: message, hideAfter: 1.0)
        ISMessages.showCardAlert(withTitle: "", message: message, duration: 3.0, hideOnSwipe: true, hideOnTap: true, alertType: ISAlertType.success, alertPosition: ISAlertPosition.top, didHide: nil)
    }

    func showWarningAlert(withMsg message: String) {
        //AJNotificationView.showNotice(in: self.view, type: AJNotificationTypeRed, title: "Something went wrong please try again", hideAfter: 1.0)
        ISMessages.showCardAlert(withTitle: "", message: message, duration: 3.0, hideOnSwipe: true, hideOnTap: true, alertType: ISAlertType.warning, alertPosition: ISAlertPosition.top, didHide: nil)
    }
    
    // MARK: -  Emoji encode decode string
    func emojisDecodedConvertedString(strText: String) -> String {
        let dataDecode: Data = strText.data(using: .utf8)!
        if (String.init(data: dataDecode, encoding: .nonLossyASCII) == nil){
            return strText
        }
        return String.init(data: dataDecode, encoding: .nonLossyASCII)!
    }
    
    func emojisEncodedConvertedString(strText: String) -> String {
        let dataEncode: Data = strText.data(using: .nonLossyASCII)!
        return String.init(data: dataEncode, encoding: .utf8)!
    }
    
    // MARK: -  get Directory Path
    func getDocumentDirPath() -> String {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        return documentsPath
    }
    
    // MARK: -  Get current timestamp
    func getCurrentDateTimeStamp() -> String! {
        return String(NSDate().timeIntervalSince1970)
    }
    
    func getLastSelectionOptions() -> Bool {
        return isMultipleScanning
    }
    
    func setLastSelectionOptions(_ valBool: Bool) {
        isMultipleScanning = valBool
    }
    //isBarCodeOrQR
    func getisQRScanning() -> Bool {
        return isQRScanning
    }
    
    func setisQRScanning(_ valBool: Bool) {
        isQRScanning = valBool
    }
}
                            
                                          
                                  
                                          
                                          
