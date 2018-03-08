//
//  CreateWebQRVC.swift
//  App
//
//  Created by admin on 24/01/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class CreateWebQRVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtWebURL: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnGenerate: MyButton!
    @IBOutlet weak var btnAddFavorite: MyButton!
    @IBOutlet weak var btnShare: MyButton!
    @IBOutlet weak var imgQR: UIImageView!
    var lastInsertedId : Int = 0
    var arrScannedResult: NSMutableArray = NSMutableArray()
    
    // MARK: -  View Lifecycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtWebURL.layer.borderWidth = 1.0;
        txtWebURL.layer.borderColor = UIColor.lightGray.cgColor;
        txtWebURL.borderStyle = .none
        txtWebURL.layer.cornerRadius = 15
        txtWebURL.setLeftPaddingPoints(10)
        txtWebURL.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        self.txtWebURL.text = ""
        DispatchQueue.main.async {
            Global.appDelegate.tabBarCustomObj?.hideTabBar()
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -  UIButton Click
    
    @IBAction func btnGenerateQR(_ sender: MyButton) {
        self.txtWebURL.resignFirstResponder()
        guard let text = txtWebURL.text, !text.isEmpty else {
            AJNotificationView.showNotice(in: self.view, type: AJNotificationTypeRed, title: "Please enter web address", hideAfter: 1.0)
            return
        }
        
        let url = URL(string: self.txtWebURL.text!)!
        let qrCode = QRCode(url)
        self.imgQR.image = qrCode?.image
        
        let historyM : HistoryModel = HistoryModel()
        historyM.strScanType = "URL"
        historyM.strisFavorite = "0"
        historyM.strDescription = "\(self.txtWebURL.text!)"
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
    
    @IBAction func btnAddFavoriteClick(_ sender: MyButton) {
        guard self.imgQR.image != nil else{
            AJNotificationView.showNotice(in: self.view, type: AJNotificationTypeRed, title: "Please first generate your QR code", linedBackground: AJLinedBackgroundTypeStatic, hideAfter: 1.0)
            return
        }
        let isSuccess = DBManager.sharedInstance.UpdateIsFavorite(id: lastInsertedId, tblNAme: Global.kHistoryTable, valueforFavorite: "1")
        
        if (isSuccess) {
            AJNotificationView.showNotice(in: self.view, title: "Favorite added Successfully", hideAfter: 1.0)
        }
        
    }
    
    @IBAction func btnShareClick(_ sender: MyButton) {
        // set up activity view controller
        let imageToShare = [ self.imgQR.image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: -  UITextFieldDelegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    func setBorderColorandWidth() {
        self.borderStyle = UITextBorderStyle.none
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: 30)
        self.layer.cornerRadius = 5
        self.backgroundColor = UIColor.white
        self.font = UIFont(name: Global.kFont.SourceRegular, size: 14)
    }
}
