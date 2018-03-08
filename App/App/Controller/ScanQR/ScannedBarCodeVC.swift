//
//  ScannedBarCodeVC.swift
//  App
//
//  Created by admin on 19/01/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class ScannedBarCodeVC: UIViewController {

    @IBOutlet weak var lblResult: UILabel!
    var strBarCodeData : String = ""
    var lastScannedId : Int = 0 // store id of last scanned id and fetch for make favorite
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblResult.text = strBarCodeData
        self.navigationController?.isNavigationBarHidden = true;
        DispatchQueue.main.async {
            Global.appDelegate.tabBarCustomObj?.hideTabBar()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddFavriteClick(_ sender: Any) {
        let isSuccess = DBManager.sharedInstance.UpdateIsFavorite(id: lastScannedId, tblNAme: Global.kHistoryTable, valueforFavorite: "1")
        
        if (isSuccess) {
            Global.singleton.showSuccessAlert(withMsg:"Favorite added successfully")
        }
    }
    
    @IBAction func btnCopyTextClick(_ sender: Any) {
        UIPasteboard.general.string = lblResult.text
        Global.singleton.showWarningAlert(withMsg:"Text has been copied in clipboard")
    }
    
}
