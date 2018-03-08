//
//  SettingVC.swift
//  App
//
//  Created by admin on 01/01/18.
//  Copyright © 2018 admin. All rights reserved.
//
/*
 1) Setting Screen options
 2) CreateContactQR - > Save in DB
 3) ImageScanning
 4) UploadImage
 5) Estimationn
 */


import UIKit

class SettingCell : UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var switchObj: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class SettingVC: UIViewController {

    @IBOutlet weak var tblSettings: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblSettings.dataSource = self
        self.tblSettings.delegate = self
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
        
        DispatchQueue.main.async {
            Global.appDelegate.tabBarCustomObj?.hideTabBar()
        }
    }

    // MARK: -  UIButton Click
    
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated:true)
    }
}

extension SettingVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "SCAN SETTINGS"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblSettings.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
        cell.switchObj.addTarget(self, action: #selector(switchValueChanges), for: .valueChanged)
        cell.switchObj.tag = indexPath.row
        //Global.singleton.retriveFromUserDefaults(key: Global.kQRAppSettingKeys.BeepSound)
        if indexPath.row == 0 {
            cell.imgIcon.image = #imageLiteral(resourceName: "beepIcon")
            cell.lblTitle.text = "Beep"
        }
        else if (indexPath.row == 1) {
            cell.imgIcon.image = #imageLiteral(resourceName: "vibrateIcon")
            cell.lblTitle.text = "Vibrate"
        }
        else if (indexPath.row == 2) {
            cell.imgIcon.image = #imageLiteral(resourceName: "laser_animation")
            cell.lblTitle.text = "Laser Animation"
        }
        if indexPath.row == 0 {
            if ( Global.kQRAppSettingData().isBeepSound == "1" ) {
                cell.switchObj.isOn = true
            }
            else{
                cell.switchObj.isOn = false
            }
        }
        else if(indexPath.row == 1) {
            if ( Global.kQRAppSettingData().isVibrate == "1" ) {
                cell.switchObj.isOn = true
            }
            else{
                cell.switchObj.isOn = false
            }
        }
        else {
            if ( Global.kQRAppSettingData().isDisplayLaser == "1" ) {
                cell.switchObj.isOn = true
            }
            else{
                cell.switchObj.isOn = false
            }
        }
        
        
        return cell
    }
    
    @objc func switchValueChanges(_ sender: UISwitch) {
        
        if (sender.tag == 0) {
            if (sender.isOn) {
                Global.singleton.saveToUserDefaults(value: "1", forKey: Global.kQRAppSettingKeys.BeepSound)
            }
            else {
                Global.singleton.saveToUserDefaults(value: "0", forKey: Global.kQRAppSettingKeys.BeepSound)
            }
        }
        else if (sender.tag == 1) {
            if (sender.isOn) {
                Global.singleton.saveToUserDefaults(value: "1", forKey: Global.kQRAppSettingKeys.Vibration)
            }
            else {
                Global.singleton.saveToUserDefaults(value: "0", forKey: Global.kQRAppSettingKeys.Vibration)
            }
        }
        else {
            if (sender.isOn) {
                Global.singleton.saveToUserDefaults(value: "1", forKey: Global.kQRAppSettingKeys.DisplayLaser)
            }
            else {
                Global.singleton.saveToUserDefaults(value: "0", forKey: Global.kQRAppSettingKeys.DisplayLaser)
            }
        }
    }
            
        
}
