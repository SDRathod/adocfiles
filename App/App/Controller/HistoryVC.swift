//
//  HistoryVC.swift
//  App
//
//  Created by admin on 28/12/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class HistoryVC: UIViewController {
    
    var arrScannHistory : NSMutableArray  = NSMutableArray()
    @IBOutlet weak var tblHistory: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblHistory.dataSource = self
        self.tblHistory.delegate = self
        self.tblHistory.backgroundColor = UIColor.clear
        self.tblHistory.allowsMultipleSelectionDuringEditing = false;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        self.tabBarController?.tabBar.isHidden = true
        Global.appDelegate.tabBarCustomObj?.showTabBar()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.getHistoryList()
        
    }
    
    func getHistoryList() {
        arrScannHistory = DBManager.sharedInstance.selectAllHistroyData(tblName: Global.kHistoryTable)
        self.tblHistory.reloadData()
    }
}

extension HistoryVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrScannHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblHistory.dequeueReusableCell(withIdentifier: "ScannedHistoryCell", for: indexPath) as! ScannedHistoryCell
        
        let historyM : HistoryModel = self.arrScannHistory[indexPath.row] as! HistoryModel
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.selectionStyle = .none
        var strValues = historyM.strDescription
        cell.lblDescription.text = historyM.strDescription
        if ((strValues.lowercased().range(of:"vcard") != nil) || (strValues.lowercased().range(of:"begin:vcard") != nil)) {
            cell.imgScanType.image = #imageLiteral(resourceName: "VcardIcon")
            cell.lblTitle.text  = "VCard"
            
            //let wordsN = strValues.components(separatedBy: "N:")
            if strValues.range(of: "FN:") != nil{
                print("Got the string")
                let wordsFM = strValues.components(separatedBy: "FN:")
                if(wordsFM.count > 0) {
                    cell.lblDescription.text = wordsFM[1]
                }
            }
            else if strValues.range(of: "FN;") != nil {
                let wordsFM = strValues.components(separatedBy: "FN;")
                if(wordsFM.count > 0) {
                    cell.lblDescription.text = wordsFM[1]
                }
            }
            else {
                cell.lblDescription.text = strValues
                
                //Default all data will be display
            }
           
        }
        else if strValues.lowercased().range(of:"http") != nil {
            cell.imgScanType.image = #imageLiteral(resourceName: "webIcon")
            cell.lblTitle.text  = "Web Address"
        }
        else if ((strValues.lowercased().range(of:"mailto") != nil) || (strValues.lowercased().range(of:"matmsg:to") != nil)) {
            cell.imgScanType.image = #imageLiteral(resourceName: "emailIcon")
            cell.lblTitle.text  = "Email"
            
            var strFinalMailString = strValues
            strValues =  strValues.replaceAll(find: "MATMSG:", with:"")
            strValues =  strValues.replaceAll(find: "Optional(", with:"")
            strValues =  strValues.replaceAll(find: ")", with:"")
            cell.lblDescription.text = strValues
            

            strFinalMailString =  strFinalMailString.replaceAll(find: "Optional(", with:"")
            strFinalMailString =  strFinalMailString.replaceAll(find: ")", with:"")
            historyM.strDescription = strFinalMailString
            
        }
        else if strValues.lowercased().range(of:"sms") != nil {
            cell.imgScanType.image = #imageLiteral(resourceName: "smsIcon")
            cell.lblTitle.text  = "SMS"
        }
        else {
            cell.lblTitle.text  = "Text"
            cell.imgScanType.image = #imageLiteral(resourceName: "textIcon")
        }
        if (historyM.strEventName == "PaperLess.works") {
            cell.lblEventName.isHidden = true
        }
        else {
            cell.lblEventName.text = historyM.strEventName
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let historyM : HistoryModel = self.arrScannHistory[indexPath.row] as! HistoryModel
        var strValues = historyM.strDescription
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if ((strValues.lowercased().range(of:"vcard") != nil) || (strValues.lowercased().range(of:"begin:vcard") != nil)) {
            print("VCARD")
            let viewController : VCardVC = storyboard.instantiateViewController(withIdentifier :"VCardVC") as! VCardVC
            viewController.strVCardData = strValues
            viewController.lastInsertedId = Int(historyM.strId)!
            self.navigationController?.pushViewController(viewController , animated: true)
            //VCardVC
        }
        else if strValues.lowercased().range(of:"http") != nil {
            let result = strValues.components(separatedBy: "\"")
            strValues = result[0]
            
            let viewController : WebAddressVC = storyboard.instantiateViewController(withIdentifier :"WebAddressVC") as! WebAddressVC
            viewController.strUrl = strValues
            self.navigationController?.pushViewController(viewController , animated: true)
        }
        else if ((strValues.lowercased().range(of:"mailto") != nil) || (strValues.lowercased().range(of:"matmsg:to") != nil)) {
//            let result: [String] = strValues.components(separatedBy: "\"")
//            if (result.count > 0) {
//                strValues = result[0]
//            }
            
            let viewController : MailVC = storyboard.instantiateViewController(withIdentifier :"MailVC") as! MailVC
            viewController.strUrl = strValues
            self.navigationController?.pushViewController(viewController , animated: true)
        }
        else if strValues.lowercased().range(of:"sms") != nil {
            print("SMS")
            let viewController : SMSVC = storyboard.instantiateViewController(withIdentifier :"SMSVC") as! SMSVC
            viewController.strSMS = strValues
            self.navigationController?.pushViewController(viewController , animated: true)
        }
        else {
            //
            let result: [String] = strValues.components(separatedBy: "\"")
            if (result.count > 0) {
                strValues = result[0]
            }
            
            let viewController : TextVC = storyboard.instantiateViewController(withIdentifier :"TextVC") as! TextVC
            viewController.strUrl = strValues
            self.navigationController?.pushViewController(viewController , animated: true)
            print("Text")
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle:   UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            let historyM : HistoryModel = self.arrScannHistory[indexPath.row] as! HistoryModel
            let success : Bool =  DBManager.sharedInstance.deleteFrom(toTable: Global.kHistoryTable, arrIDS: [Int(historyM.strId)!])
            if (success) {
                //DispatchQueue.main.async {
                    self.arrScannHistory.removeObject(at: indexPath.row)
                
                    self.tblHistory.reloadData()
//                    tableView.beginUpdates()
//                    tableView.deleteRows(at: [indexPath], with: .middle)
//                    tableView.endUpdates()
                //}
                
            }
        }
    }
    
}
