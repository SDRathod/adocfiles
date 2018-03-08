//
//  MultiScannListVCViewController.swift
//  App
//
//  Created by admin on 18/01/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class ScannedHistoryCell: UITableViewCell {
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgScanType: UIImageView!
    @IBOutlet weak var lblEventName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}


class MultiScannListVC: UIViewController {

    var arrScannHistory : NSMutableArray  = NSMutableArray()
    @IBOutlet weak var tblScannedHistory: UITableView!

    @IBOutlet weak var txtBatchName: UITextField!
    @IBOutlet weak var subViewOfBatchview: UIView!
    @IBOutlet weak var viewBatchName: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblScannedHistory.dataSource = self
        self.tblScannedHistory.delegate = self
        self.tblScannedHistory.backgroundColor = UIColor.clear
        viewBatchName.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        //self.view.backgroundColor = .clear
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        Global.appDelegate.tabBarCustomObj?.hideOriginalTabBar()
        Global.appDelegate.tabBarCustomObj?.hideTabBar()
         viewBatchName.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func saveInBarTable() -> Bool {
        
        let isSuccess = DBManager.sharedInstance.addHistoryWithName(wihBatchName: txtBatchName.text!, toTable: Global.kBarTable)
        
        if (isSuccess) {
            print("\(txtBatchName.text!) Inserted Successfully")
            return true
        }
        else{
            return false
        }
    }
    
    @IBAction func btnSaveBatchName(_ sender: Any) {
        guard txtBatchName.text != nil else {
            Global.singleton.showWarningAlert(withMsg:"Please enter batch name")
            return
        }
        
        if(saveInBarTable()) {
            let maxId = DBManager.sharedInstance.GetMaxlId(table: Global.kBarTable)
            let isSuccess = DBManager.sharedInstance.addHistorywithBarId(toDbRegionArray: arrScannHistory as! [HistoryModel], toTable: Global.kHistoryTable, barId:"\(maxId)")
            if (isSuccess) {
                print("addHistorywithBarId Inserted Successfully")
                viewBatchName.isHidden = true
            }
            else{
                Global.singleton.showWarningAlert(withMsg:"Error in db, please try again later.")
            }
            
        }
        
    }
    @IBAction func btnSaveClick(_ sender: Any) {
        self.viewBatchName.isHidden = false
    }
    @IBAction func btnCancelClick(_ sender: Any) {
        self.viewBatchName.isHidden = true
    }
}

extension MultiScannListVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrScannHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblScannedHistory.dequeueReusableCell(withIdentifier: "ScannedHistoryCell", for: indexPath) as! ScannedHistoryCell
        
        let historyM : HistoryModel = self.arrScannHistory[indexPath.row] as! HistoryModel
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.selectionStyle = .none
        let strValues = historyM.strDescription
        
        if ((strValues.lowercased().range(of:"vcard") != nil) || (strValues.lowercased().range(of:"begin:vcard") != nil)) {
            cell.imgScanType.image = #imageLiteral(resourceName: "VcardIcon")
            cell.lblTitle.text  = "VCard"
        }
        else if strValues.lowercased().range(of:"http") != nil {
            cell.imgScanType.image = #imageLiteral(resourceName: "webIcon")
            cell.lblTitle.text  = "Web Address"
        }
        else if ((strValues.lowercased().range(of:"mailto") != nil) || (strValues.lowercased().range(of:"matmsg:to") != nil)) {
            cell.imgScanType.image = #imageLiteral(resourceName: "emailIcon")
            cell.lblTitle.text  = "Email"
        }
        else if strValues.lowercased().range(of:"sms") != nil {
            cell.imgScanType.image = #imageLiteral(resourceName: "smsIcon")
            cell.lblTitle.text  = "SMS"
        }
        else {
            cell.lblTitle.text  = "Text"
            cell.imgScanType.image = #imageLiteral(resourceName: "textIcon")
        }
        cell.lblDescription.text = historyM.strDescription
        if (historyM.strEventName == "PaperLess.works") {
            cell.lblEventName.isHidden = true
        }
        else {
            if historyM.strEventName != ""{
                cell.lblEventName.text = historyM.strEventName
            }
            else {
                cell.lblEventName.text = ""
            }
            
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
            let result: [String] = strValues.components(separatedBy: "\"")
            if (result.count > 0) {
                strValues = result[0]
            }
            
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
    
}
