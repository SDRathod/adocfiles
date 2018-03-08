//
//  VCardMenuVC.swift
//  App
//
//  Created by admin on 23/01/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class VCardMenuVC: UIViewController {
    @IBOutlet weak var imgViewQRCode: UIImageView!
    @IBOutlet weak var viewSpinner: UIView!
    @IBOutlet weak var btnPickContact: MyButton!
    @IBOutlet weak var btnCreateContact: MyButton!
    
    var lastSavedContact : String = ""
    var lastSavedCN = CNContact()
    
    var contacts = [CNContact]()
    var vcardFromContacts = NSData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnPickContact.setBorderAndborderColor(color: Global.kAppColor.AppTheamColor, width: 2.0)
        btnCreateContact.setBorderAndborderColor(color: Global.kAppColor.AppTheamColor, width: 2.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        DispatchQueue.main.async {
            Global.appDelegate.tabBarCustomObj?.hideTabBar()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentSettingsActionSheet() {
        let alert = UIAlertController(title: "Permission to Contacts", message: "This app needs access to contacts in order to ...", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default) { _ in
            let url = URL(string: UIApplicationOpenSettingsURLString)!
            UIApplication.shared.open(url)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    // MARK: -  Button Click
    
    @IBAction func btnCreateClick(_ sender: Any) {
    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController : CreateContactVC = storyboard.instantiateViewController(withIdentifier :"CreateContactVC") as! CreateContactVC
       // viewController.arrScannHistory = self.arrScannedResult
        self.navigationController?.pushViewController(viewController , animated: true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPickContactClick(_ sender: Any) {
        
        let status = CNContactStore.authorizationStatus(for: .contacts)
        if status == .denied || status == .restricted {
            self.presentSettingsActionSheet()
            return
        }
        
        // open it
        
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, error in
            guard granted else {
                DispatchQueue.main.async {
                    self.presentSettingsActionSheet()
                }
                return
            }
            
            // get the contacts
            let contactPicker = CNContactPickerViewController()
            contactPicker.delegate = self
            contactPicker.displayedPropertyKeys =
                [CNContactPhoneNumbersKey]
            self.present(contactPicker, animated: true, completion: nil)
        }
    }
}

extension VCardMenuVC  : CNContactPickerDelegate {
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        self.dismiss(animated: true) {
            self.viewSpinner.isHidden = false
        }
    }
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        do {
            self.viewSpinner.isHidden = false
            self.lastSavedCN = contact
            try self.vcardFromContacts = CNContactVCardSerialization.data(with: [contact]) as NSData
            
            //var error: Error? = nil
            var vCardData: Data? = try? CNContactVCardSerialization.data(with: ([contact]))
            let vCardNote: String? = contact.note
            if vCardNote == ""  {
                
            }
            else {
                vCardData = CNContactVCardSerialization.vcardDataAppendingNote(vcard: self.vcardFromContacts as Data, noteasString:vCardNote!)
                
            }

            self.lastSavedContact = String(data: vCardData ?? Data(), encoding: .utf8)!
            
            print("added contact = \(String(describing: self.lastSavedContact))")
        } catch {
            AJNotificationView.showNotice(in: self.view, type: AJNotificationTypeRed, title: "Error \(error.localizedDescription)", hideAfter: 2.0)
        }
        self.dismiss(animated: true) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController1 : CreateVCardVC = storyboard.instantiateViewController(withIdentifier :"CreateVCardVC") as! CreateVCardVC
            viewController1.lastSavedContact = self.lastSavedContact
            viewController1.lastSavedCON = self.lastSavedCN
            self.navigationController?.pushViewController(viewController1 , animated: true)
            self.viewSpinner.isHidden = true
        }
        
        
//        do {
//            try self.vcardFromContacts = CNContactVCardSerialization.data(with: [contact]) as NSData
//            
//            //var error: Error? = nil
//            let vCardData: Data? = try? CNContactVCardSerialization.data(with: ([contact]))
//            
//            //With Image but give error  : initQRCodeForInputByteSize cannot find proper rs block info (input data too big?)image
//            //                let base64Image: String? = contactProperty.contact.imageData?.base64EncodedString()
//            //                var vCardData: Data? = try! CNContactVCardSerialization.vcardDataAppendingPhoto(vcard: self.vcardFromContacts as Data, photoAsBase64String: base64Image!)
//            //vCardData = vcString?.data(using: .utf8)
//            let vcString = String(data: vCardData ?? Data(), encoding: .utf8)
//            
//            
//            // NSData
//            let data = vcString?.data(using: .isoLatin1)!
//            let qrCode = QRCode(data!)
//            self.imgViewQRCode.image = qrCode.image
//            
//            
//            // print("\(vcString)")
//            //  self.onBtnGenerateQRCode(sender: vcString)
//            
//        } catch {
//            print("Error \(error)")
//        }
    }
}

extension VCardMenuVC : CNContactViewControllerDelegate {
    
    func contactViewController(_ viewController: CNContactViewController, shouldPerformDefaultActionFor property: CNContactProperty) -> Bool {
        viewController.dismiss(animated: true, completion: nil)
        self.viewSpinner.isHidden = true
        return true
    }
    
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        
        if contact == nil {
            viewController.dismiss(animated: true, completion: nil)
            return
        }
        do {
            self.viewSpinner.isHidden = false
            self.lastSavedCN = contact!
            try self.vcardFromContacts = CNContactVCardSerialization.data(with: [contact!]) as NSData
        
            //var error: Error? = nil
            var vCardData: Data? = try? CNContactVCardSerialization.data(with: ([contact!]))
            let vCardNote: String? = contact?.note
            if vCardNote == ""  {
                
            }
            else {
                vCardData = CNContactVCardSerialization.vcardDataAppendingNote(vcard: self.vcardFromContacts as Data, noteasString:vCardNote!)
                
            }
            lastSavedContact = String(data: vCardData ?? Data(), encoding: .utf8)!
            
            print("added contact = \(String(describing: lastSavedContact))")
        } catch {
            AJNotificationView.showNotice(in: self.view, type: AJNotificationTypeRed, title: "Error \(error.localizedDescription)", hideAfter: 2.0)
        }
        viewController.dismiss(animated: true) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController1 : CreateVCardVC = storyboard.instantiateViewController(withIdentifier :"CreateVCardVC") as! CreateVCardVC
            viewController1.lastSavedContact = self.lastSavedContact
            viewController1.lastSavedCON = self.lastSavedCN
            self.navigationController?.pushViewController(viewController1 , animated: true)
            self.viewSpinner.isHidden = true
        }
    }
}

extension CNContactVCardSerialization {
    internal class func vcardDataAppendingPhoto(vcard: Data, photoAsBase64String photo: String) -> Data? {
        let vcardAsString = String(data: vcard, encoding: .utf8)
        let vcardPhoto = "PHOTO;TYPE=JPEG;ENCODING=BASE64:".appending(photo)
        let vcardPhotoThenEnd = vcardPhoto.appending("\nEND:VCARD")
        if let vcardPhotoAppended = vcardAsString?.replacingOccurrences(of: "END:VCARD", with: vcardPhotoThenEnd) {
            return vcardPhotoAppended.data(using: .utf8)
        }
        return nil
        
    }
    class func data(jpegPhotoContacts: [CNContact]) throws -> Data {
        var overallData = Data()
        for contact in jpegPhotoContacts {
            let data = try CNContactVCardSerialization.data(with: [contact])
            if contact.imageDataAvailable {
                if let base64imageString = contact.imageData?.base64EncodedString(),
                    let updatedData = vcardDataAppendingPhoto(vcard: data, photoAsBase64String: base64imageString) {
                    overallData.append(updatedData)
                }
            } else {
                overallData.append(data)
            }
        }
        return overallData
    }
    internal class func vcardDataAppendingNote(vcard: Data, noteasString note: String) -> Data? {
        let vcardAsString = String(data: vcard, encoding: .utf8)
        let vcardNote = "NOTE:".appending(note)
        let vcardNoteThenEnd = vcardNote.appending("\nEND:VCARD")
        if let vcardNotetoAppended = vcardAsString?.replacingOccurrences(of: "END:VCARD", with: vcardNoteThenEnd) {
            return vcardNotetoAppended.data(using: .utf8)
        }
        return nil
        
    }
}
