//
//  CreateCodeVC.swift
//  App
//
//  Created by admin on 28/12/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit


class CreateCodeCell: UITableViewCell {

    @IBOutlet weak var lblCodeType: UILabel!
    @IBOutlet weak var imgCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

class CreateCodeVC: UIViewController {

    @IBOutlet weak var tblCreateQR: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblCreateQR.delegate = self
        self.tblCreateQR.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        Global.appDelegate.tabBarCustomObj?.showTabBar()
         self.tabBarController?.tabBar.isHidden = true
         self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CreateCodeVC : UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblCreateQR.dequeueReusableCell(withIdentifier: "CreateCodeCell", for: indexPath) as! CreateCodeCell
        cell.selectionStyle = .none
        
        if (indexPath.row == 0) {
            cell.imgCell.image = #imageLiteral(resourceName: "VcardIcon")
            cell.lblCodeType.text = "VCard"
        }
        else if (indexPath.row == 1) {
            cell.imgCell.image = #imageLiteral(resourceName: "webIcon")
            cell.lblCodeType.text = "Web Address"
        }
        else if (indexPath.row == 2) {
            cell.imgCell.image = #imageLiteral(resourceName: "textIcon")
            cell.lblCodeType.text = "Text"
        }
        else if (indexPath.row == 3) {
            cell.imgCell.image = #imageLiteral(resourceName: "emailIcon")
            cell.lblCodeType.text = "Email"
        }
        else if (indexPath.row == 4) {
            cell.imgCell.image = #imageLiteral(resourceName: "smsIcon")
            cell.lblCodeType.text = "SMS"
        }
        else {
            cell.imgCell.image = #imageLiteral(resourceName: "Paperless_works_images")
            cell.lblCodeType.text = "Images"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if (indexPath.row == 0) {
            //VCard Push VCardMenuVC
            let viewController : VCardMenuVC = storyboard.instantiateViewController(withIdentifier :"VCardMenuVC") as! VCardMenuVC
            self.navigationController?.pushViewController(viewController , animated: true)
            
        }
        else if (indexPath.row == 1) {
            let viewController : CreateWebQRVC = storyboard.instantiateViewController(withIdentifier :"CreateWebQRVC") as! CreateWebQRVC
            self.navigationController?.pushViewController(viewController , animated: true)
        }
        else if (indexPath.row == 2) {
            let viewController : CreateTextQRVC = storyboard.instantiateViewController(withIdentifier :"CreateTextQRVC") as! CreateTextQRVC
            self.navigationController?.pushViewController(viewController , animated: true)
        }
        else if (indexPath.row == 3) {
            let viewController : CreateMailQRVC = storyboard.instantiateViewController(withIdentifier :"CreateMailQRVC") as! CreateMailQRVC
            self.navigationController?.pushViewController(viewController , animated: true)
        }
        else if (indexPath.row == 4) {
            let viewController : CreateSMSQRVC = storyboard.instantiateViewController(withIdentifier :"CreateSMSQRVC") as! CreateSMSQRVC
            self.navigationController?.pushViewController(viewController , animated: true)
        }
        else {
            let viewController : ImageUploadVC = storyboard.instantiateViewController(withIdentifier :"ImageUploadVC") as! ImageUploadVC
            self.navigationController?.pushViewController(viewController , animated: true)
        }
    }

}
