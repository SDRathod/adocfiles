//
//  WebAddressVC.swift
//  App
//
//  Created by admin on 12/01/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class WebAddressVC: UIViewController {

    @IBOutlet weak var webObj: UIWebView!
    var strUrl : String = ""
    @IBOutlet weak var lblURL: UILabel!
    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    var lastScannedId : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webObj.delegate = self
        // Do any additional setup after loading the view.
        lblURL.text = ""
        webObj.layer.borderWidth = 2.0
        //webObj.layer.borderColor = (Global.kAppColor.AppTheamColor as! CGColor)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        lblURL.text = strUrl
        webObj.loadRequest(URLRequest(url: URL(string: strUrl)!))
        self.navigationController?.isNavigationBarHidden = true;
        Global.appDelegate.tabBarCustomObj?.hideOriginalTabBar()
        Global.appDelegate.tabBarCustomObj?.hideTabBar()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnOpenBrowserClick(_ sender: Any) {
        if (UIApplication.shared.canOpenURL(URL(string: strUrl)!)) {
            UIApplication.shared.open(URL(string: strUrl)!, options: [:])
        }
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
                //AJNotificationView.showNotice(in: self.view, title: "Favorite added Successfully", hideAfter: 1.0)
                Global.singleton.showSuccessAlert(withMsg:"Favorite added Successfully")
            }
        }
        else {
            let isSuccess = DBManager.sharedInstance.UpdateIsFavorite(id: lastScannedId, tblNAme: Global.kHistoryTable, valueforFavorite: "1")
            
            if (isSuccess) {
                Global.singleton.showWarningAlert(withMsg:"Favorite added Successfully")
            }
        }
        
    }
}

@IBDesignable class MyButton: UIButton
{
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
    }
    
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }
    
    func setBorderAndborderColor(color: UIColor, width: CGFloat) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
}

extension WebAddressVC : UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        actIndicator.isHidden = false
        //UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        actIndicator.isHidden = true
        //UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        actIndicator.isHidden = true
        //UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
