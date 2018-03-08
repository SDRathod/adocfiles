
//
//  HomeVC.swift
//  App
//
//  Created by admin on 28/12/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import AVFoundation
import Contacts
import ContactsUI

// MARK: -  Custom Cell for Option TableView.
   /**
    Create Custom Cell for Disploay Options of Scanning. It has two Objects one is Lable and another is Button
    ## Important Notes ##
     - lblOption: Message for the Options.
     - imgSelect: Selected and UnSelected Images.
   */

class OptionCell : UITableViewCell {
    /**
      Construction lblOption.
     
     - lblOption: Message for the Options.
     - imgSelect: Selected and UnSelected Images.
     */
    @IBOutlet weak var lblOption: UILabel!
    @IBOutlet weak var imgSelect: UIButton!
}

// MARK: -  Custom Model class for Option table.

    /**
     Create Custom Model to store Options value in locally
    ## Important Notes ##
    - strOptionName: Message for the Options.
    - isSelected: Selected and UnSelected Images using `Bool` Options.
     */
class OptionShare : NSObject {
    /**
     Construction lblOption.
     
     - strOptionName: Message for the Options.
     - isSelected: Selected and UnSelected Images using `Bool` Options.
     */
    var isSelected : Bool = false
    var strOptionName : String = ""
}

class HomeVC: UIViewController {

    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var viewAlertBg: UIView!
    @IBOutlet weak var tblOptions: UITableView!
    @IBOutlet weak var btnQR: UIButton!
    @IBOutlet weak var btnBar: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblScanQR: UILabel!
    @IBOutlet weak var lblScanBarCode: UILabel!
    
    var isClickOnQRBarCode : String  = ""

    var arrSelectd : NSMutableArray =  NSMutableArray()
    
    //org.iso.QRCode
    //org.gs1.EAN-13   upce
    //org.iso.Code39
    //org.iso.Code128
    //org.gs1.UPC-E
    //org.iso.Aztec
    //org.iso.PDF417
    //org.ansi.Interleaved2of5
    
    // MARK: -  UIView LifeCycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        viewAlertBg.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.backgroundColor: UIColor.white], for: .normal)
        tabBarController?.tabBar.selectionIndicatorImage = UIImage(named: "imageBGSelected.png")
        let appearance = UITabBarItem.appearance()
        let attributes: [NSAttributedStringKey: AnyObject] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue):UIFont(name: "Verdana", size: 10)!]
        appearance.setTitleTextAttributes(attributes, for: .normal)
        
        let viewGest = UITapGestureRecognizer(target: self, action: #selector(viewTabGesture))
        viewGest.numberOfTapsRequired = 1
        viewAlertBg.addGestureRecognizer(viewGest)
        
        viewGest.cancelsTouchesInView = false
        
        let shrObj : OptionShare = OptionShare()
        shrObj.strOptionName = "Single Scan"
        shrObj.isSelected = false
        arrSelectd.add(shrObj)
        
        let shrObj1 : OptionShare = OptionShare()
        shrObj1.strOptionName = "Multi Scan"
        shrObj1.isSelected = false
        arrSelectd.add(shrObj1)
        self.tabBarController?.hidesBottomBarWhenPushed = true
        
        btnQR.imageView?.contentMode = .scaleToFill
        btnBar.imageView?.contentMode = .scaleToFill
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewAlertBg.isHidden = true
        self.navigationController?.isNavigationBarHidden = true;
        Global.appDelegate.tabBarCustomObj?.showTabBar()
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        Global.appDelegate.tabBarCustomObj?.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.setDeviceSpecificTextSize()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        btnQR.imageView?.contentMode = .scaleToFill
        btnBar.imageView?.contentMode = .scaleToFill
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -  Other Functions
    
    func setDeviceSpecificTextSize() {
       // btnBack.titleLabel?.font = UIFont(name: Global.kFont.ChilaxIcon, size: Global.singleton.getDeviceSpecificFontSize(16))
        lblTitle.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(18))
        //lblScanQR.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(15))
        lblScanBarCode.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(15))
        let IsCreatedBusinessCard = Global.singleton.retriveFromUserDefaults(key: Global.IsCreatedBusinessCard)
        
        if IsCreatedBusinessCard == "1"  {
            print("Saved Business Card.")
            let  lastSavedContact = Global.singleton.retriveFromUserDefaults(key: Global.myBusinessCard)
            let data = lastSavedContact?.data(using: .isoLatin1)!
            let qrCode = QRCode(data!)
         //   qrCode.color = Global.kAppColor.AppTheamColor.ciColor
            self.btnQR.setImage(qrCode.image, for: .normal)
            
        } else {
            print("First launch, setting UserDefault.")
            
            let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showCreateContact))
            tap.numberOfTouchesRequired = 1
            tap.numberOfTapsRequired = 1
            lblScanQR.addGestureRecognizer(tap)
            lblScanQR.isUserInteractionEnabled = true
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController : CreateContactVC = storyboard.instantiateViewController(withIdentifier :"CreateContactVC") as! CreateContactVC
            // viewController.arrScannHistory = self.arrScannedResult
            self.navigationController?.pushViewController(viewController , animated: true)
            
        }
       
    }
    
    @objc func viewTabGesture() {
        self.viewAlertBg.isHidden = true
    }
    
    @objc func showCreateContact()  {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController : CreateContactVC = storyboard.instantiateViewController(withIdentifier :"CreateContactVC") as! CreateContactVC
        // viewController.arrScannHistory = self.arrScannedResult
        self.navigationController?.pushViewController(viewController , animated: true)
    }
    
    // MARK: -  UIButton Click
    
    @IBAction func btnFavouriteClick(_ sender: Any) {
        
    }
    
    @IBAction func btnSettingClick(_ sender: Any) {
        
    }
    
    @IBAction func btnQRClick(_ sender: UIButton) {
        if (Global.singleton.retriveFromUserDefaults(key: Global.kQRAppSettingKeys.MyCardcontactId) == "1") {
            
        }
        else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController : CreateContactVC = storyboard.instantiateViewController(withIdentifier :"CreateContactVC") as! CreateContactVC
            viewController.contactIdentifireForEdit = "1"
            // viewController.arrScannHistory = self.arrScannedResult
            self.navigationController?.pushViewController(viewController , animated: true)
        }
    }
    
    @IBAction func btnBarClick(_ sender: UIButton) {
        isClickOnQRBarCode = "\(1)"
        viewAlertBg.isHidden = false
    }

    // MARK: -   Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

// MARK: -  extension of UITableView.

extension HomeVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSelectd.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! OptionCell
        cell.imgSelect.addTarget(self, action: #selector(btnSelectedClick), for:.touchUpInside)
        cell.imgSelect.tag = indexPath.row
        let shrObj : OptionShare = arrSelectd[indexPath.row] as! OptionShare
        cell.lblOption.text = shrObj.strOptionName
        cell.imgSelect.isSelected = shrObj.isSelected
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.row == 0) {
            Global.singleton.setLastSelectionOptions(false)
        }
        else {
            Global.singleton.setLastSelectionOptions(true)
        }
        if (isClickOnQRBarCode == "1") {
            Global.singleton.setisQRScanning(true)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier :"ScaneerVC1") as! ScaneerVC1
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController , animated: true)
        }
        else if (isClickOnQRBarCode == "2") {
             Global.singleton.setisQRScanning(false)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier :"ScaneerVC1") as! ScaneerVC1
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController , animated: true)
        }
        
    }
    
    @objc func btnSelectedClick(sender: UIButton) {
        for i in 0..<arrSelectd.count {
            let shrObj : OptionShare = arrSelectd[i] as! OptionShare
            if (i == sender.tag) {
                shrObj.isSelected = !sender.isSelected
            }
            else {
                shrObj.isSelected = false
            }
        }
        self.tblOptions.reloadData()
    }
}

extension HomeVC : CNContactViewControllerDelegate {
    func contactViewController(_ viewController: CNContactViewController, shouldPerformDefaultActionFor property: CNContactProperty) -> Bool {
        viewController.dismiss(animated: true, completion: nil)
        return true
    }
    
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        if contact == nil {
            viewController.dismiss(animated: true, completion: nil)
            return
        }
        do {

            let vcardFromContacts = try CNContactVCardSerialization.data(with: [contact!]) as NSData
            
            //var error: Error? = nil
            var vCardData: Data? = try? CNContactVCardSerialization.data(with: ([contact!]))
            let vCardNote: String? = contact?.note
            if vCardNote == ""  {
                
            }
            else {
                vCardData = CNContactVCardSerialization.vcardDataAppendingNote(vcard: vcardFromContacts as Data, noteasString:vCardNote!)
                
            }
           let  lastSavedContact = String(data: vCardData ?? Data(), encoding: .utf8)!
            let data = lastSavedContact.data(using: .isoLatin1)!
            let qrCode = QRCode(data)
            self.btnQR.setImage(qrCode.image, for: .normal)
            
            Global.singleton.saveToUserDefaults(value: lastSavedContact, forKey: Global.myBusinessCard)
            Global.singleton.saveToUserDefaults(value: "1", forKey: Global.IsCreatedBusinessCard)
            //self.imgQR.image = qrCode.image
            
            print("added contact = \(String(describing: lastSavedContact))")
        } catch {
            Global.singleton.showWarningAlert(withMsg: "Error \(error.localizedDescription)")
        }
    }
}

