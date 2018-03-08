//
//  TextVC.swift
//  App
//
//  Created by admin on 16/01/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class TextVC: UIViewController {

    @IBOutlet weak var txtViewObj: UITextView!
    var strUrl : String = ""
    var lastScannedId :Int  = 0
    
    // MARK: -  UIView LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        txtViewObj.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtViewObj.text = strUrl
        self.navigationController?.isNavigationBarHidden = true;
        Global.appDelegate.tabBarCustomObj?.hideOriginalTabBar()
        Global.appDelegate.tabBarCustomObj?.hideTabBar()
    }
    
    // MARK: -  UIButton Click Events
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCopyText(_ sender: Any) {
        UIPasteboard.general.string = txtViewObj.text
        Global.singleton.showSuccessAlert(withMsg:"Text has been copied in clipboard")
    }
    
    @IBAction func btnShareClick(_ sender: Any) {
        
        // text to share
        let text = "Hey!! I am using PaperLess.works do you want to try it?."
        
        // set up activity view controller
        let textToShare = [ text, strUrl ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook, .postToVimeo, .postToWeibo, .postToFlickr, .postToTwitter, .copyToPasteboard ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    @IBAction func AddFavoriteClick(_ sender: Any) {
        
        if lastScannedId == 0 {
            //
            let isSuccess = DBManager.sharedInstance.UpdateIsFavoriteusingContent(content: strUrl, tblNAme: Global.kHistoryTable, valueforFavorite: "1")
            
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
}
