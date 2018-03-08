//
//  CreateImageQR.swift
//  App
//
//  Created by admin on 09/02/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class CreateImageQR: UIViewController {

    var arrImages : NSMutableArray = NSMutableArray ()
    @IBOutlet weak var imgQR: UIImageView!
    var lastInsertedId : Int = 0
    var strURL : String = ""
    @IBOutlet weak var collectionImages: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionImages.delegate = self
        collectionImages.dataSource = self
        
        if let layout = collectionImages.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemWidth = view.bounds.width / 3.50
            let itemHeight = layout.itemSize.height
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.invalidateLayout()
        }
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        DispatchQueue.main.async {
            Global.appDelegate.tabBarCustomObj?.hideTabBar()
        }
    }
    // MARK: - IBAction
    
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnGenerateClick(_ sender: Any) {
        if self.arrImages.count > 0 {
            let param: NSMutableDictionary = NSMutableDictionary()
            print(param)
            
            AFAPIMaster.sharedAPIMaster.postMultipleImages_Completion(params: param, images: self.arrImages as! [UIImage], imageParamNames: ["image1","image2","image3"], showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess:{ (returnData: Any) in
                
                let dictResponse: NSDictionary = returnData as! NSDictionary
                let arrData : NSArray = dictResponse.object(forKey: "data") as! NSArray
                if (arrData.count > 4) {
                    let dictPath : NSDictionary = arrData.object(at: 4) as! NSDictionary
                    let url = URL(string: dictPath.object(forKey: "url") as! String)!
                    let qrCode = QRCode(url)
                    self.imgQR.image = qrCode?.image
                    
                    self.strURL = dictPath.object(forKey: "url") as! String
                    
                    let historyM : HistoryModel = HistoryModel()
                    historyM.strScanType = "Images"
                    historyM.strisFavorite = "0"
                    historyM.strDescription = "\(dictPath.object(forKey: "url") as! String)"
                    historyM.strIsQRorBarcode = Global.isQRCode
                    historyM.strBatchId = "1"
                    historyM.strEventName = ""
                    
                    let arrScannedResult : NSMutableArray = NSMutableArray()
                    arrScannedResult.add(historyM)
                    
                    let isSuccess = DBManager.sharedInstance.addHistory(toDbRegionArray: arrScannedResult as! [HistoryModel], toTable: Global.kHistoryTable)
                    
                    if (isSuccess) {
                        print("Record Inserted Successfully")
                        self.lastInsertedId = DBManager.sharedInstance.GetMaxlId(table: Global.kHistoryTable)
                    }
                }
                print(dictResponse)
            })
        }
    }
    @IBAction func btnAddFavorites(_ sender: Any) {
        guard self.imgQR.image != nil else{
            Global.singleton.showWarningAlert(withMsg:"Please first generate your QR code")
            return
        }
        let isSuccess = DBManager.sharedInstance.UpdateIsFavorite(id: self.lastInsertedId, tblNAme: Global.kHistoryTable, valueforFavorite: "1")
        
        if (isSuccess) {
            AJNotificationView.showNotice(in: self.view, title: "Favorite added Successfully", hideAfter: 1.0)
        }
    }
    @IBAction func btnShareClick(_ sender: Any) {
        // text to share
        //let text = "Hey!! I am using PaperLess.works do you want to try it?."
        
        let img : UIImage = self.imgQR.image!

        // set up activity view controller
        let textToShare = [ img, self.strURL ] as [Any]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook, .postToVimeo, .postToWeibo, .postToFlickr, .postToTwitter, .copyToPasteboard ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
}

extension CreateImageQR : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell : MyCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionCell", for: indexPath) as! MyCollectionCell
        myCell.backgroundColor = UIColor.clear
        myCell.imgCell.image = (arrImages[indexPath.row] as? UIImage)
        myCell.btnClose.addTarget(self, action: #selector(DeleteImage), for: UIControlEvents.touchUpInside)
        myCell.btnClose.tag = indexPath.row
        return myCell
    }
    
    @objc func DeleteImage(_ sender : UIButton)  {
        self.arrImages.removeObject(at: sender.tag)
        self.collectionImages.reloadData()
    }
}

class MyCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var imgCell: UIImageView!
}
