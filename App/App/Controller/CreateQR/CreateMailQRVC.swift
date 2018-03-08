//
//  CreateMailQRVC.swift
//  App
//
//  Created by admin on 24/01/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class CreateMailQRVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgQR: UIImageView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtSub: UITextField!
    @IBOutlet weak var txtBody: UITextView!
    
    @IBOutlet weak var btnShare: MyButton!
    @IBOutlet weak var btnAddFavorite: MyButton!
    @IBOutlet weak var btnGenerate: MyButton!
    var arrScannedResult : NSMutableArray = NSMutableArray()
    var lastInsertedId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtEmail.layer.borderWidth = 1.0;
        txtEmail.layer.borderColor = UIColor.lightGray.cgColor;
        txtEmail.borderStyle = .none
        txtEmail.layer.cornerRadius = 15
        txtEmail.setLeftPaddingPoints(10)
        txtEmail.delegate = self
        txtEmail.keyboardType = .emailAddress
        
        txtSub.layer.borderWidth = 1.0;
        txtSub.layer.borderColor = UIColor.lightGray.cgColor;
        txtSub.borderStyle = .none
        txtSub.layer.cornerRadius = 15
        txtSub.setLeftPaddingPoints(10)
        txtSub.delegate = self
        
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
        self.txtEmail.resignFirstResponder()
        self.txtSub.resignFirstResponder()
        self.txtBody.resignFirstResponder()
        
        guard let text = txtEmail.text, !text.isEmpty else {
            AJNotificationView.showNotice(in: self.view, type: AJNotificationTypeRed, title: "Please enter email", hideAfter: 1.0)
            return
        }
        guard Global.singleton.validateEmail(strEmail: txtEmail.text!) else {
            AJNotificationView.showNotice(in: self.view, type: AJNotificationTypeRed, title: "Please enter proper email", hideAfter: 1.0)
            return
        }
//        guard let text1 = txtSub.text, !text1.isEmpty else {
//            AJNotificationView.showNotice(in: self.view, type: AJNotificationTypeRed, title: "Please enter subject", hideAfter: 1.0)
//            return
//        }
//        guard let text2 = txtBody.text, !text2.isEmpty else {
//            AJNotificationView.showNotice(in: self.view, type: AJNotificationTypeRed, title: "Please enter body", hideAfter: 1.0)
//            return
//        }
        
        //MATMSG:TO:foo@example.com;SUB:The subject;BODY:The body;
        let qrCode = QRCode("MATMSG:TO:\(self.txtEmail.text!);SUB:\(self.txtSub.text);BODY:\(txtBody.text)")
        self.imgQR.image = qrCode?.image
        
        let historyM : HistoryModel = HistoryModel()
        historyM.strScanType = "SMS"
        historyM.strisFavorite = "0"
        historyM.strDescription = "MATMSG:TO:\(self.txtEmail.text!);SUB:\(self.txtSub.text);BODY:\(txtBody.text)"
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

extension CreateMailQRVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField == self.txtEmail) {
            textField.resignFirstResponder()
            txtSub.becomeFirstResponder()
        }
        else if (textField == self.txtSub) {
            textField.resignFirstResponder()
        }
        
        return true
    }
}

extension CreateMailQRVC : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return true
    }
    
}
