//
//  CreateVCardVC.swift
//  App
//
//  Created by admin on 25/01/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import Contacts
import IQKeyboardManagerSwift

class CreateVCardVC: UIViewController {
    var lastSavedContact: String = ""
    var lastSavedCON = CNContact()
    // MARK: Public
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtviewCard: UITextView!
    @IBOutlet weak var imgQR: UIImageView!
    
    var lastInsertedId : Int  = 0
    var arrScannedResult: NSMutableArray = NSMutableArray()
    
    // MARK: -  View Lifecycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getContactDetails()
        self.navigationController?.isNavigationBarHidden = true;
        DispatchQueue.main.async {
            Global.appDelegate.tabBarCustomObj?.hideTabBar()
        }
        
        // NSData
        let data = lastSavedContact.data(using: .isoLatin1)!
        let qrCode = QRCode(data)
        self.imgQR.image = qrCode.image
        self.saveInHistroyTable()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func saveInHistroyTable() {
        let historyM : HistoryModel = HistoryModel()
        historyM.strScanType = "VCard"
        historyM.strisFavorite = "0"
        historyM.strBatchId = "1"
        historyM.strEventName = ""
        do {
            let vcardFromContacts = try CNContactVCardSerialization.data(with: [lastSavedCON]) as NSData
            historyM.strDescription = "\(String(data: vcardFromContacts as Data , encoding: .utf8)!)"
        }
        catch {
            
        }
        
        historyM.strIsQRorBarcode = Global.isQRCode
        
        self.arrScannedResult.add(historyM)
        
        let isSuccess = DBManager.sharedInstance.addHistory(toDbRegionArray: self.arrScannedResult as! [HistoryModel], toTable: Global.kHistoryTable)
        
        if (isSuccess) {
            print("Record Inserted Successfully")
            lastInsertedId = DBManager.sharedInstance.GetMaxlId(table: Global.kHistoryTable)
        }
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
    
        self.navigationController?.popToViewController((self.navigationController?.viewControllers[0])!, animated: true)
        //self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnFavClick(_ sender: Any) {
        guard self.imgQR.image != nil else{
            AJNotificationView.showNotice(in: self.view, type: AJNotificationTypeRed, title: "Please first generate your QR code", linedBackground: AJLinedBackgroundTypeStatic, hideAfter: 1.0)
            return
        }
        let isSuccess = DBManager.sharedInstance.UpdateIsFavorite(id: lastInsertedId, tblNAme: Global.kHistoryTable, valueforFavorite: "1")
        
        if (isSuccess) {
            AJNotificationView.showNotice(in: self.view, title: "Favorite added Successfully", hideAfter: 1.0)
        }
    }
    
    @IBAction func btnShareClick(_ sender: Any) {
        // set up activity view controller
        let imageToShare = [ self.imgQR.image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func getContactDetails () {
        /* Get all mobile number */
        var strContactData : String = ""
        strContactData = "\(lastSavedCON.familyName)  \(lastSavedCON.givenName)"
        for ContctNumVar: CNLabeledValue in lastSavedCON.phoneNumbers
        {
            let MobNumVar  = (ContctNumVar.value).value(forKey: "digits") as? String
            strContactData = "\(strContactData) \n \((ContctNumVar.value).value(forKey: "digits") as? String ?? "")"
            print(MobNumVar!)
            break;
        }
        
        /* Get all mobile number */
        for email in lastSavedCON.emailAddresses{
            strContactData = "\(strContactData) \n \((email.value as String))"
            print("\(email.value as String)")
            
        }
        
        
        let address = lastSavedCON.postalAddresses.count > 0 ? "\(lastSavedCON.postalAddresses[0].value.street)" : ""
        let city = lastSavedCON.postalAddresses.count > 0 ? "\(lastSavedCON.postalAddresses[0].value.city)" : ""
    
        strContactData = "\(strContactData) \n \(address) \n \((city))"
        strContactData =  "\(strContactData) \n \(lastSavedCON.note)"
        
        /* Get all mobile number */
        for socialProfile in lastSavedCON.socialProfiles{
            strContactData = "\(strContactData) \n \((socialProfile.value.urlString as String))"
            print("\(socialProfile.value.username as String)")
        }
        
        for instantMsg in lastSavedCON.instantMessageAddresses{
            strContactData = "\(strContactData) \n \((instantMsg.value.username as String))"
            print("\(instantMsg.value.username as String)")
        }
        
        self.txtviewCard.text = strContactData
    }
}


