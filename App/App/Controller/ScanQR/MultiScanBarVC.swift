//
//  MultiScanBarVC.swift
//  App
//
//  Created by admin on 18/01/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class ScannedBarCell: UITableViewCell {
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

class MultiScanBarVC: UIViewController {

    @IBOutlet weak var txtBatchName: UITextField!
    var arrBarScanHistory : NSMutableArray = NSMutableArray()
    @IBOutlet weak var tblBarHistory: UITableView!
    @IBOutlet weak var YConstraintBarView: NSLayoutConstraint!
    
    @IBOutlet weak var subViewOfBatchview: UIView!
    @IBOutlet weak var viewBatchName: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblBarHistory.dataSource = self
        tblBarHistory.delegate = self
        subViewOfBatchview.layer.cornerRadius = 20
        viewBatchName.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        
        self.tblBarHistory.backgroundColor = UIColor.clear
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewBatchName.isHidden = true
        self.navigationController?.isNavigationBarHidden = true;
        Global.appDelegate.tabBarCustomObj?.showTabBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            let isSuccess = DBManager.sharedInstance.addHistorywithBarId(toDbRegionArray: arrBarScanHistory as! [HistoryModel], toTable: Global.kHistoryTable, barId:"\(maxId)")
            if (isSuccess) {
                print("addHistorywithBarId Inserted Successfully")
                viewBatchName.isHidden = true
            }
            else{
                Global.singleton.showWarningAlert(withMsg:"error in db, please try agian!!")
            }
            
        }
        
    }
    @IBAction func btnSaveClick(_ sender: Any) {
        self.viewBatchName.isHidden = false
    }
    @IBAction func btnCancelClick(_ sender: Any) {
        self.viewBatchName.isHidden = true
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        YConstraintBarView.constant = 75
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        YConstraintBarView.constant = 156
        return true
    }

}

extension MultiScanBarVC : UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrBarScanHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblBarHistory.dequeueReusableCell(withIdentifier: "ScannedBarCell", for: indexPath) as! ScannedBarCell
        
        let historyM : HistoryModel = self.arrBarScanHistory[indexPath.row] as! HistoryModel
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.selectionStyle = .none
        var strValues = historyM.strDescription
        
        let result: [String] = strValues.components(separatedBy: "\"")
        if (result.count > 0) {
            strValues = result[0]
        }
        
        cell.lblDescription.text = historyM.strScanType
        cell.lblTitle.text = historyM.strDescription
        
        if (historyM.strEventName == "PaperLess.works") {
            //cell.lblEventName.isHidden = true
        }
        else {
            //cell.lblEventName.text = historyM.strEventName
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let historyM : HistoryModel = self.arrBarScanHistory[indexPath.row] as! HistoryModel
        var strValues = historyM.strDescription
    }
}
