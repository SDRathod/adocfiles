//
//  FavoriteVC.swift
//  App
//
//  Created by admin on 01/01/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell {
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgScanType: UIImageView!
    @IBOutlet weak var imgQR_Bar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


class FavoriteVC: UIViewController {

    var arrScannHistory : NSMutableArray  = NSMutableArray()
    @IBOutlet weak var tblHistory: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblHistory.dataSource = self
        self.tblHistory.delegate = self
        self.tblHistory.backgroundColor = UIColor.clear
        self.tblHistory.allowsMultipleSelectionDuringEditing = false;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        Global.appDelegate.tabBarCustomObj?.hideTabBar()
        self.getFavoriteList()
    }

    func getFavoriteList() {
        arrScannHistory = DBManager.sharedInstance.selectFavoritesFromHistroyTable(tblName: Global.kHistoryTable)
        self.tblHistory.reloadData()
    }
    
    // MARK: -  UIButton Click
    
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated:true)
    }
}

extension FavoriteVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrScannHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblHistory.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        
        let historyM : HistoryModel = self.arrScannHistory[indexPath.row] as! HistoryModel
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.selectionStyle = .none
        let strValues = historyM.strDescription
        cell.lblDescription.text = historyM.strDescription
        if ((strValues.lowercased().range(of:"vcard") != nil) || (strValues.lowercased().range(of:"begin:vcard") != nil)) {
            cell.imgScanType.image = #imageLiteral(resourceName: "VcardIcon")
            cell.lblTitle.text  = "VCard"
            
            let wordsFM = strValues.components(separatedBy: "FN:")
            if(wordsFM.count > 0) {
                cell.lblDescription.text = wordsFM[1]
            }
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
    
        //1 for QR and 2 for Barcode
        
        if (historyM.strIsQRorBarcode == "1") {
            cell.imgQR_Bar.image = #imageLiteral(resourceName: "HomeQR")
        }
        else if (historyM.strIsQRorBarcode == "2"){
            cell.imgQR_Bar.image = #imageLiteral(resourceName: "barcode")
        }
        else {
            cell.imgQR_Bar.isHidden = true
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Unfavorite"
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle:   UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            let historyM : HistoryModel = self.arrScannHistory[indexPath.row] as! HistoryModel
            //UpdateIsFavorite
            let success : Bool =  DBManager.sharedInstance.UpdateIsFavorite(id: Int(historyM.strId)!, tblNAme: Global.kHistoryTable, valueforFavorite: "0")
            //let success : Bool =  DBManager.sharedInstance.deleteFrom(toTable: Global.kHistoryTable, arrIDS: [historyM.strId])
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
