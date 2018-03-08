//
//  SMSVC.swift
//  App
//
//  Created by admin on 17/01/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import MessageUI

class SMSVC: UIViewController {

    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtSMS: UITextView!
     var strSMS : String = ""
    var lastScannedId: Int = 0
    
     // MARK: -  UIView LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtMobile.text = ""
        txtSMS.text = ""
        
        self.navigationController?.isNavigationBarHidden = true;
        Global.appDelegate.tabBarCustomObj?.showTabBar()
        
        if (strSMS.count > 0){
            let result = strSMS.components(separatedBy: "\"")
            print(result)
            if(result.count == 1) {
                let strSMSFullString : String = result[0]
                let finalResult = strSMSFullString.components(separatedBy: ":")
                if(finalResult.count > 0){
                    txtMobile.text = finalResult[1]
                    txtSMS.text = finalResult[2]
                }
            }
            else if(result.count > 0) {
                let strSMSFullString : String = result[1]
                let finalResult = strSMSFullString.components(separatedBy: ":")
                if(finalResult.count > 0){
                    txtMobile.text = finalResult[1]
                    txtSMS.text = finalResult[2]
                }
            }
        }
    }
    
    // MARK: -  UIButton Click Events
    @IBAction func btnAddFavClick(_ sender: Any) {
        //Update in db
        if lastScannedId == 0 {
            let isSuccess = DBManager.sharedInstance.UpdateIsFavoriteusingContent(content: strSMS, tblNAme: Global.kHistoryTable, valueforFavorite: "1")
            
            if (isSuccess) {
                Global.singleton.showSuccessAlert(withMsg:"Favorite added Successfully")
            }
        }
        else {
            let isSuccess = DBManager.sharedInstance.UpdateIsFavorite(id: lastScannedId, tblNAme: Global.kHistoryTable, valueforFavorite: "1")
            
            if (isSuccess) {
                Global.singleton.showSuccessAlert(withMsg:"Favorite added Successfully")
            }
        }
    }
    
    @IBAction func btnSendClick(_ sender: Any) {
        if let url = NSURL(string: "sms:") {
            if UIApplication.shared.canOpenURL(url as URL) {
                let messageVC = MFMessageComposeViewController()
                
                messageVC.body = txtSMS.text
                messageVC.recipients = [txtMobile.text!]
                messageVC.messageComposeDelegate = self
                
                self.present(messageVC, animated: false, completion: nil)
            }
            else{
                Global.singleton.showWarningAlert(withMsg:"There is no SMS app, please try again")
            }
        }
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SMSVC: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case .cancelled:
            print("Message was cancelled")
        case .failed:
            print("Message failed")
        case .sent:
            print("Message was sent")
        }
        self.dismiss(animated: true, completion: nil)
    }
}
