//
//  MailVC.swift
//  App
//
//  Created by admin on 16/01/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import MessageUI

class MailVC: UIViewController {

    @IBOutlet weak var txtMail: UITextField!
    @IBOutlet weak var txtSubject: UITextField!
    @IBOutlet weak var txtViewMessage: UITextView!
    var strUrl : String = ""
    var lastScannedId : Int = 0
    
    // MARK: -  UIView LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtMail.text = ""
        txtSubject.text = ""
        txtViewMessage.text = ""
        
        self.navigationController?.isNavigationBarHidden = true;
        Global.appDelegate.tabBarCustomObj?.hideOriginalTabBar()
        Global.appDelegate.tabBarCustomObj?.hideTabBar()
        
        if (strUrl.count > 0){
            let result = strUrl.components(separatedBy: ";")
            print(result)
            if(result.count > 2) {
                let strMsgTo : String = result[0]
                let strSub : String = result[1]
                let strBody : String = result[2]
                
                let strFinalMsgToArray = strMsgTo.components(separatedBy: ":")
                let strFinalSubjectArray = strSub.components(separatedBy: ":")
               
                let strFinalBodyArray = strBody.components(separatedBy: ":")
                
                if (strFinalMsgToArray.count > 1){
                    txtMail.text = strFinalMsgToArray[2]
                }
                if (strFinalSubjectArray.count > 0){
                    let strValues =  strFinalSubjectArray[1].replaceAll(find: "\"", with:"")
                    txtSubject.text = strValues
                }
                if (strFinalBodyArray.count > 0){
                    txtViewMessage.text = strFinalBodyArray[1]
                }
            }
            else if(result.count > 1) {
                let strMsgTo : String = result[0]
                let strSub : String = result[1]
                
                let strFinalMsgToArray = strMsgTo.components(separatedBy: ":")
                let strFinalSubjectArray = strSub.components(separatedBy: ":")
                
                if (strFinalMsgToArray.count > 1){
                    txtMail.text = strFinalMsgToArray[2]
                }
                if (strFinalSubjectArray.count > 0){
                    txtSubject.text = strFinalSubjectArray[1]
                }
               
            }
            else if(result.count > 0) {
                let strMsgTo : String = result[0]
                //let strSub : String = result[1]
                //let strBody : String = result[2]
                
                let strFinalMsgToArray = strMsgTo.components(separatedBy: ":")
                //let strFinalSubjectArray = strSub.components(separatedBy: ":")
                //let strFinalBodyArray = strBody.components(separatedBy: ":")
                
                if (strFinalMsgToArray.count > 1){
                    txtMail.text = strFinalMsgToArray[2]
                }
//                if (strFinalSubjectArray.count > 0){
//                    txtSubject.text = strFinalSubjectArray[1]
//                }
                
            }
        }
    }
    
    // MARK: -  UIButton Click Events
    @IBAction func btnSendClick(_ sender: Any) {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            
            Global.singleton.showWarningAlert(withMsg:"Mail services are not available")
            return
        }
        
        guard let mailTo = txtMail.text else {
            
            Global.singleton.showWarningAlert(withMsg:"Please enter email")
            return
        }
        guard let SubjectLine = txtSubject.text else {
            Global.singleton.showWarningAlert(withMsg:"Please enter subject")
            return
        }
        guard let strMessages = txtViewMessage.text else {
           Global.singleton.showWarningAlert(withMsg:"Please enter Message")
            return
        }
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.setToRecipients([mailTo])
        composeVC.setSubject(SubjectLine)
        composeVC.setMessageBody(strMessages, isHTML: false)
        
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    @IBAction func btnAddFavClick(_ sender: Any) {
        if lastScannedId == 0 {
            //
            let isSuccess = DBManager.sharedInstance.UpdateIsFavoriteusingContent(content: strUrl, tblNAme: Global.kHistoryTable, valueforFavorite: "1")
            
            if (isSuccess) {
                Global.singleton.showSuccessAlert(withMsg:"Favorite added successfully")
            }
            else {
                Global.singleton.showSuccessAlert(withMsg:"something went wrong try again later!!")
            }
        }
        else {
            //Update in db
            let isSuccess = DBManager.sharedInstance.UpdateIsFavorite(id: lastScannedId, tblNAme: Global.kHistoryTable, valueforFavorite: "1")
            
            if (isSuccess) {
                Global.singleton.showSuccessAlert(withMsg:"Favorite added successfully")
            }
        }
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MailVC : MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            Global.singleton.showWarningAlert(withMsg:"Mail Cancel")
        case .failed:
            Global.singleton.showWarningAlert(withMsg:"Mail sending failed")
        case .saved:
            Global.singleton.showWarningAlert(withMsg:"Mail saved in draft")
        case .sent:
            Global.singleton.showWarningAlert(withMsg:"Mail sent sucessfully")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
