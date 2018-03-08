
//
//  CreateTextQRVC.swift
//  App
//
//  Created by admin on 24/01/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class CreateTextQRVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgQR: UIImageView!
    @IBOutlet weak var txtNote: UITextView!
    
    @IBOutlet weak var btnShare: MyButton!
    @IBOutlet weak var btnAddFavorite: MyButton!
    @IBOutlet weak var btnGenerate: MyButton!
    var lastInsertedId : Int = 0
    var arrScannedResult : NSMutableArray = NSMutableArray()
    
    let PLACEHOLDER_TEXT = "Enter your text"
     // MARK: View Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtNote.delegate = self
        self.txtNote.layer.borderWidth = 1.0
        self.txtNote.layer.cornerRadius = 10.0
        self.txtNote.layer.borderColor = UIColor.lightGray.cgColor;
        applyPlaceholderStyle(aTextview: self.txtNote!, placeholderText: PLACEHOLDER_TEXT)
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        DispatchQueue.main.async {
            Global.appDelegate.tabBarCustomObj?.hideTabBar()
        }
    }
    
     // MARK: -  UIButton Click
    @IBAction func btnAddFavClick(_ sender: Any) {
        
        guard self.imgQR.image != nil else{
            AJNotificationView.showNotice(in: self.view, type: AJNotificationTypeRed, title: "Please first generate your QR code", linedBackground: AJLinedBackgroundTypeStatic, hideAfter: 1.0)
            return
        }
        let isSuccess = DBManager.sharedInstance.UpdateIsFavorite(id: lastInsertedId, tblNAme: Global.kHistoryTable, valueforFavorite: "1")
        
        if (isSuccess) {
            AJNotificationView.showNotice(in: self.view, title: "Favorite added Successfully", hideAfter: 1.0)
        }
    }
    
    @IBAction func btnShareClick(_ sender: Any) {
        let imageToShare = [ self.imgQR.image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func btnGenerate(_ sender: Any) {
        self.txtNote.resignFirstResponder()
        guard let text = txtNote.text, !text.isEmpty else {
            AJNotificationView.showNotice(in: self.view, type: AJNotificationTypeRed, title: "Please enter proper text", hideAfter: 1.0)
            return
        }
        let qrCode = QRCode("\(self.txtNote.text!)")
        self.imgQR.image = qrCode?.image
        
        let historyM : HistoryModel = HistoryModel()
        historyM.strScanType = "Text"
        historyM.strisFavorite = "0"
        historyM.strDescription = "\(self.txtNote.text!)"
        historyM.strIsQRorBarcode = Global.isQRCode
        historyM.strBatchId = "1"
        historyM.strEventName = ""
        
        self.arrScannedResult.add(historyM)
        
        let isSuccess = DBManager.sharedInstance.addHistory(toDbRegionArray: self.arrScannedResult as! [HistoryModel], toTable: Global.kHistoryTable)
        
        if (isSuccess) {
            print("Record Inserted Successfully")
            lastInsertedId = DBManager.sharedInstance.GetMaxlId(table: Global.kHistoryTable)
        }
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
     // MARK: -  UITextView Placeholder Methods
    
    func applyPlaceholderStyle(aTextview: UITextView, placeholderText: String)
    {
        // make it look (initially) like a placeholder
        aTextview.textColor = UIColor.lightGray
        aTextview.text = placeholderText
    }
    func applyNonPlaceholderStyle(aTextview: UITextView)
    {
        // make it look like normal text instead of a placeholder
        aTextview.textColor = UIColor.black
        aTextview.alpha = 1.0
    }
    
    func moveCursorToStart(aTextView: UITextView)
    {
        DispatchQueue.main.async {
            aTextView.selectedRange = NSMakeRange(0, 0);
        }
    }
}

extension CreateTextQRVC : UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        if textView == self.txtNote && textView.text == PLACEHOLDER_TEXT
        {
            // move cursor to start
            moveCursorToStart(aTextView: textView)
        }
        return true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // remove the placeholder text when they start typing
        // first, see if the field is empty
        // if it's not empty, then the text should be black and not italic
        // BUT, we also need to remove the placeholder text if that's the only text
        // if it is empty, then the text should be the placeholder
        let newLength = textView.text.utf16.count + text.utf16.count - range.length
        if newLength > 0 // have text, so don't show the placeholder
        {
            // check if the only text is the placeholder and remove it if needed
            // unless they've hit the delete button with the placeholder displayed
            if textView == self.txtNote && textView.text == PLACEHOLDER_TEXT
            {
                if text.utf16.count == 0 // they hit the back button
                {
                    return false // ignore it
                }
                applyNonPlaceholderStyle(aTextview: textView)
                textView.text = ""
            }
            return true
        }
        else  // no text, so show the placeholder
        {
            applyPlaceholderStyle(aTextview: textView, placeholderText: PLACEHOLDER_TEXT)
            moveCursorToStart(aTextView: textView)
            return false
        }
    }
    
}
