//
//  CreateSMSQRVC.swift
//  App
//
//  Created by admin on 25/01/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class CreateSMSQRVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgQR: UIImageView!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtBody: UITextView!
    
    @IBOutlet weak var btnShare: MyButton!
    @IBOutlet weak var btnAddFavorite: MyButton!
    @IBOutlet weak var btnGenerate: MyButton!
    var arrScannedResult : NSMutableArray = NSMutableArray()
    var lastInsertedId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtPhone.layer.borderWidth = 1.0;
        txtPhone.layer.borderColor = UIColor.lightGray.cgColor;
        txtPhone.borderStyle = .none
        txtPhone.layer.cornerRadius = 15
        txtPhone.setLeftPaddingPoints(10)
        txtPhone.delegate = self
        
        txtBody.layer.borderWidth = 1.0;
        txtBody.layer.borderColor = UIColor.lightGray.cgColor;
        txtBody.layer.cornerRadius = 15
        txtBody.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        DispatchQueue.main.async {
            Global.appDelegate.tabBarCustomObj?.hideTabBar()
        }
    }
    
    @IBAction func btnFavoriteClick(_ sender: Any) {
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
        let imageToShare = [ self.imgQR.image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func btnGenerateClick(_ sender: Any) {
        self.view.resignFirstResponder()
        
        guard let text = txtPhone.text, !text.isEmpty else {
            AJNotificationView.showNotice(in: self.view, type: AJNotificationTypeRed, title: "Please enter mobile number", hideAfter: 1.0)
            return
        }
        guard Global.singleton.validatePhoneNumber(strPhone: txtPhone.text!) else {
            AJNotificationView.showNotice(in: self.view, type: AJNotificationTypeRed, title: "Please enter proper mobile", hideAfter: 1.0)
            return
        }
        
        let qrCode = QRCode("MATMSG:TO:\(self.txtPhone.text!);BODY:\(txtBody.text)")
        self.imgQR.image = qrCode?.image
        
        let historyM : HistoryModel = HistoryModel()
        historyM.strScanType = "SMS"
        historyM.strisFavorite = "0"
        historyM.strDescription = "MATMSG:TO:\(self.txtPhone.text!);BODY:\(txtBody.text)"
        historyM.strIsQRorBarcode = Global.isQRCode
        historyM.strBatchId = "1"
        historyM.strEventName = ""
        self.arrScannedResult.add(historyM)
        
        
        let isSuccess = DBManager.sharedInstance.addHistory(toDbRegionArray: self.arrScannedResult as! [HistoryModel], toTable: Global.kHistoryTable)
        
        if (isSuccess) {
            print("Record Inserted Successfully")
            lastInsertedId = DBManager.sharedInstance.GetMaxlId(table: Global.kHistoryTable)
        }

    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CreateSMSQRVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
        return true
    }
}
extension CreateSMSQRVC : UITextViewDelegate {
    
}
