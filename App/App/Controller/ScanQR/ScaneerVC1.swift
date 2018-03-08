//
//  ScaneerVC1.swift
//  App
//
//  Created by admin on 02/01/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import AVFoundation
import Contacts

class ScaneerVC1: UIViewController {
    
   // @IBOutlet var messageLabel:UILabel!
    @IBOutlet var topbar: UIView!
    @IBOutlet weak var btnGallery: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblScanCount: UILabel!
    @IBOutlet weak var btnDone: MyButton!
    
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    var imagePicker: UIImagePickerController?
    var arrScannedResult : NSMutableArray = NSMutableArray()
    
    private let supportedCodeQR = [AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.qr]
    private let supportedCodeBAR = [AVMetadataObject.ObjectType.upce,
                                   AVMetadataObject.ObjectType.code39,
                                   AVMetadataObject.ObjectType.code39Mod43,
                                   AVMetadataObject.ObjectType.code93,
                                   AVMetadataObject.ObjectType.code128,
                                   AVMetadataObject.ObjectType.ean8,
                                   AVMetadataObject.ObjectType.ean13,
                                   AVMetadataObject.ObjectType.aztec,
                                   AVMetadataObject.ObjectType.pdf417,
                                   AVMetadataObject.ObjectType.itf14,
                                   AVMetadataObject.ObjectType.interleaved2of5,
                                   AVMetadataObject.ObjectType.dataMatrix,
                                   AVMetadataObject.ObjectType.qr]
    
    
    var capture: ZXCapture?
    @IBOutlet var scanRectView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Global.singleton.setisQRScanning
        // Get the back-facing camera for capturing videos
        var deviceDiscoverySession: AVCaptureDevice.DiscoverySession

        if AVCaptureDevice.default(.builtInDualCamera, for: AVMediaType.video, position: .back) != nil {

            deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)

        } else {

            deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)

        }

        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }

        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)

            // Set the input device on the capture session.
            captureSession.addInput(input)

            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)

            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)

            if (Global.singleton.getisQRScanning() == true) {
                captureMetadataOutput.metadataObjectTypes = supportedCodeQR
            }
            else{
                captureMetadataOutput.metadataObjectTypes = supportedCodeQR
            }

        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }

        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)

        // Start video capture.
        captureSession.startRunning()

        // Move the message label and top bar to the front
        //view.bringSubview(toFront: messageLabel)
        view.bringSubview(toFront: topbar)
        view.bringSubview(toFront: btnDone)

        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()

        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
        
        
//        capture = ZXCapture()
//        capture?.focusMode = .continuousAutoFocus
//        view.bringSubview(toFront: scanRectView)
//        capture?.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if ((captureSession.isRunning) == false) {
            captureSession.startRunning()
        }
        arrScannedResult.removeAllObjects()
        if (Global.singleton.getLastSelectionOptions()) {
            btnDone.isHidden = false
            lblScanCount.isHidden = false
            lblScanCount.text = "\(self.arrScannedResult.count)"
            btnGallery.isHidden = true
        }
        else {
            btnDone.isHidden = true
            lblScanCount.isHidden = true
            btnGallery.isHidden = false
        }
        
        self.navigationController?.isNavigationBarHidden = true;
        Global.appDelegate.tabBarCustomObj?.hideTabBar()
         self.setDeviceSpecificTextSize()
       
        
//
//        capture?.layer.frame = scanRectView.bounds
//        scanRectView.layer.addSublayer((capture?.layer)!)
//        capture?.start()
       
    }
    
    
    // MARK: - Helper methods
    
   
    func setDeviceSpecificTextSize() {

        lblTitle.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(18))
        lblScanCount.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(15))
    }
    
    func launchApp(decodedURL: String) {
        
        if presentedViewController != nil {
            return
        }
        
        let alertPrompt = UIAlertController(title: "Open App", message: "You're going to open \(decodedURL)", preferredStyle: .actionSheet)
        let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            
            if let url = URL(string: decodedURL) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        alertPrompt.addAction(confirmAction)
        alertPrompt.addAction(cancelAction)
        
        present(alertPrompt, animated: true, completion: nil)
    }
    
    
     /**
      toggleTorch : Useful for ON/OFF Tourch
     
      - Returns:
      No any return value

      - Parameters:
        - on: Pass the value True or False.
     */
   
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video)
            else {return}
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    
    @objc func chooseImage() {
        if let tryPicker = imagePicker {
            self.present(tryPicker, animated: true, completion: nil)
        } else {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = false
            imagePicker = picker
            
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    // MARK: -  IBAction Methods
    @IBAction func btnGalleryClick(_ sender: Any) {
        self.chooseImage()
    }
    
    @IBAction func btnTourchClick(_ sender: UIButton) {
        if (sender.isSelected == true) {
            self.toggleTorch(on: false)
            sender.isSelected = false
        }
        else{
            self.toggleTorch(on: true)
            sender.isSelected = true
        }
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDoneClick(_ sender: Any) {
        
        if(Global.singleton.getisQRScanning()) {
            print("\(arrScannedResult)")
            if (self.arrScannedResult.count  > 0) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController : MultiScannListVC = storyboard.instantiateViewController(withIdentifier :"MultiScannListVC") as! MultiScannListVC
                viewController.arrScannHistory = self.arrScannedResult
                self.navigationController?.pushViewController(viewController , animated: true)
            }
            else {
                Global.singleton.showWarningAlert(withMsg:"You don't have any scann history")
            }
        }
        else{
            print("\(arrScannedResult)")
            if (self.arrScannedResult.count  > 0) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController : MultiScanBarVC = storyboard.instantiateViewController(withIdentifier :"MultiScanBarVC") as! MultiScanBarVC
                viewController.arrBarScanHistory = self.arrScannedResult
                
                self.navigationController?.pushViewController(viewController , animated: true)
            }
            else {
                Global.singleton.showWarningAlert(withMsg:"You don't have any scann history")
            }
        }
        
    }
    
    // MARK: -  Push View in perticular screen as per type
    
    func pushInPerticularTypeVC(strValue: String, Type strType: String, lastInsertedId: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
       if ((strType.lowercased().range(of:"vcard") != nil) || (strType.lowercased().range(of:"begin:vcard") != nil)) {
            print("VCARD")
            let viewController : VCardVC = storyboard.instantiateViewController(withIdentifier :"VCardVC") as! VCardVC
            viewController.strVCardData = strValue
            self.navigationController?.pushViewController(viewController , animated: true)
            //VCardVC
        }
        else if strValue.lowercased().range(of:"http") != nil {
            
            let viewController : WebAddressVC = storyboard.instantiateViewController(withIdentifier :"WebAddressVC") as! WebAddressVC
            viewController.strUrl = strValue
            viewController.lastScannedId = lastInsertedId
            self.navigationController?.pushViewController(viewController , animated: true)
        }
        else if ((strValue.lowercased().range(of:"mailto") != nil) || (strValue.lowercased().range(of:"matmsg:to") != nil)) {
            print("Mail")
            let viewController : MailVC = storyboard.instantiateViewController(withIdentifier :"MailVC") as! MailVC
            viewController.strUrl = strValue
            self.navigationController?.pushViewController(viewController , animated: true)
        }
        else if strValue.lowercased().range(of:"BEGIN:VCARD") != nil {
            print("VCARD")
            let viewController : VCardVC = storyboard.instantiateViewController(withIdentifier :"VCardVC") as! VCardVC
            viewController.strVCardData = strValue
            self.navigationController?.pushViewController(viewController , animated: true)
            //VCardVC
        }
        else if strValue.lowercased().range(of:"sms") != nil {
            print("SMS")
            let viewController : SMSVC = storyboard.instantiateViewController(withIdentifier :"SMSVC") as! SMSVC
            viewController.strSMS = strValue
            self.navigationController?.pushViewController(viewController , animated: true)
        }
        else {
            //
            let viewController : TextVC = storyboard.instantiateViewController(withIdentifier :"TextVC") as! TextVC
            viewController.strUrl = strValue
            self.navigationController?.pushViewController(viewController , animated: true)
            print("Text")
        }
    }
    
    
    func pushInBarVC(strValue: String, Type strType: String, lastInsertedId:Int) {
        //ScannedBarCodeVC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController : ScannedBarCodeVC = storyboard.instantiateViewController(withIdentifier :"ScannedBarCodeVC") as! ScannedBarCodeVC
        viewController.strBarCodeData = "\(strType)  : \(strValue)"
        self.navigationController?.pushViewController(viewController , animated: true)
    }
    
    
}
extension ScaneerVC1: ZXCaptureDelegate {
    func captureCameraIsReady(_ capture: ZXCapture!) {
        
    }
    func captureResult(_ capture: ZXCapture!, result: ZXResult!) {
        print(capture)
        print("\(result.description)")
        print("\(result.resultMetadata)")
        
    }
}

extension String {
    func replaceAll(find:String, with:String) -> String {
        return replacingOccurrences(of: find, with: with)
        //return stringByReplacingOccurrencesOfString(find, withString: with, options: .CaseInsensitiveSearch, range: nil)
    }
}

extension ScaneerVC1: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            //messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        var isQROrBarCode = ""
        var strType: String = ""
        if (Global.singleton.getisQRScanning() == true) {
            //QR Code Scanning
            if supportedCodeQR.contains(metadataObj.type) {
                // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
                let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
                qrCodeFrameView?.frame = barCodeObject!.bounds
                
                //QR Code
                isQROrBarCode = "1"
            
                if (Global.singleton.getLastSelectionOptions()) {
                    
                    //For Multiple Scann
                    //1 -  Add to it in Array and Click on Done button
                    //2 -  Insert in DB
                    //3 -  Push in MultiScan VC
                    
                    var strValues = metadataObj.stringValue
                    
                    
                    if ((strValues?.lowercased().range(of:"vcard") != nil) || (strValues?.lowercased().range(of:"begin:vcard") != nil)) {
                        print("VCARD")
                        strType = "VCARD"
                        
                    }
                    else if strValues?.lowercased().range(of:"http") != nil {
                        print("URL")
                        strType = "URL"
                    }
                    else if ((strValues?.lowercased().range(of:"mailto") != nil) || (strValues?.lowercased().range(of:"matmsg:to") != nil)) {
                        print("Mail")
                        strType = "Mail"
                        //Optional(
                        
                       strValues =  strValues?.replaceAll(find: "Optional(", with:"")
                       strValues =  strValues?.replaceAll(find: ")", with:"")
                        
                    }
                    else if strValues?.lowercased().range(of:"sms") != nil {
                        print("sms")
                        strType = "SMS"
                    }
                    else {
                        //text
                        strType = "Text"
                    }
                    
                    let historyM : HistoryModel = HistoryModel()
                    historyM.strScanType = strType
                    historyM.strisFavorite = "0"
                    historyM.strDescription = strValues!
                    historyM.strIsQRorBarcode = isQROrBarCode
                    historyM.strBatchId = "1"
                    historyM.strEventName = ""
                    
                    let arrHistory: NSMutableArray = NSMutableArray()
                    arrHistory.add(historyM)
                    
                    if arrScannedResult.first(where: { ($0 as! HistoryModel).strDescription == historyM.strDescription }) != nil {
                        print("duplicateScan")
                        return
                        
                    }
                    
                    self.playBeepSoundOrNot()
                    
                    self.arrScannedResult.add(historyM)
                    lblScanCount.text = "\(self.arrScannedResult.count)"
                    
                    let isSuccess = DBManager.sharedInstance.addHistory(toDbRegionArray: arrHistory as! [HistoryModel], toTable: Global.kHistoryTable)
                    
                    if (isSuccess) {
                        print("Record Inserted Successfully")
                    }
                }
                else {
                    
                    //For Single Scann
                    
                    print("value = \(String(describing: metadataObj.stringValue))")
                    print("type = \(metadataObj.type)")
                    var strValues = metadataObj.stringValue
                    print(strValues ?? "")
                    
                    if ((strValues?.lowercased().range(of:"vcard") != nil) || (strValues?.lowercased().range(of:"begin:vcard") != nil)) {
                        print("VCARD")
                        strType = "VCARD"
                        
                    }
                    else if strValues?.lowercased().range(of:"http") != nil {
                        print("URL")
                        strType = "URL"
                        let result = strValues?.components(separatedBy: "\"")
                        strValues = result?[0]
                        
                    }
                    else if ((strValues?.lowercased().range(of:"mailto") != nil) || (strValues?.lowercased().range(of:"matmsg:to") != nil)) {
                        print("Mail")
                        strType = "Mail"
                        let result: [String] = strValues!.components(separatedBy: "\"")
                        if (result.count > 0) {
                            strValues = result[0]
                        }
                        strValues  = strValues?.replaceAll(find: "Optional(", with:"")
                        strValues = strValues?.replaceAll(find: ")", with:"")
                    }
                    else if ((strValues?.lowercased().range(of:"vcard") != nil) || (strValues?.lowercased().range(of:"begin:vcard") != nil)) {
                        print("VCARD")
                        strType = "VCARD"
                    }
                    else if strValues?.lowercased().range(of:"sms") != nil {
                        print("sms")
                        strType = "SMS"
                    }
                    else {
                        //text
                        strType = "Text"
                        let result: [String] = strValues!.components(separatedBy: "\"")
                        if (result.count > 0) {
                            strValues = result[0]
                        }
                    }
                    self.playBeepSoundOrNot()
                    
                    let historyM : HistoryModel = HistoryModel()
                    historyM.strScanType = strType
                    historyM.strisFavorite = "0"
                    historyM.strDescription = strValues!
                    historyM.strIsQRorBarcode = isQROrBarCode
                    historyM.strBatchId = "1"
                    historyM.strEventName = ""
                    
                    self.arrScannedResult.add(historyM)
                    
                                
                    let isSuccess = DBManager.sharedInstance.addHistory(toDbRegionArray: self.arrScannedResult as! [HistoryModel], toTable: Global.kHistoryTable)
                    
                    if (isSuccess) {
                        print("Record Inserted Successfully")
                        let lastInsertedId : Int = DBManager.sharedInstance.GetMaxlId(table: Global.kHistoryTable)
                        captureSession.stopRunning()
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                            self.pushInPerticularTypeVC(strValue:strValues! , Type: strType, lastInsertedId: lastInsertedId)
                        })
                    }
                    
                   
                }
                print("value = \(String(describing: metadataObj.stringValue))")
                print("type = \(metadataObj.type)")
            }
            else{
                print("type = \(metadataObj.type)   NOT SUPPORTED")
            }
        }
        else{
            //Bar Code Scanning
            /*
            if supportedCodeBAR.contains(metadataObj.type) {
                // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
                let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
                qrCodeFrameView?.frame = barCodeObject!.bounds
                
                isQROrBarCode = "2"
                var strValues = metadataObj.stringValue
                
                print(strValues ?? "")
                
                let result: [String] = strValues!.components(separatedBy: "\"")
                if (result.count > 0) {
                    strValues = result[0]
                }
                
                strType = self.checkBarCodeType(metadataObj: metadataObj)
                
                if (Global.singleton.getLastSelectionOptions()) {
                   
                    let historyM : HistoryModel = HistoryModel()
                    historyM.strScanType = strType
                    historyM.strisFavorite = "0"
                    historyM.strDescription = metadataObj.stringValue!
                    historyM.strIsQRorBarcode = isQROrBarCode
                    
                    let arrHistory: NSMutableArray = NSMutableArray()
                    arrHistory.add(historyM)
                    
                    if arrScannedResult.first(where: { ($0 as! HistoryModel).strDescription == historyM.strDescription }) != nil {
                        print("duplicateScan")
                        return
                    }
                    
                    self.playBeepSoundOrNot()
                    self.arrScannedResult.add(historyM)
                    lblScanCount.text = "\(self.arrScannedResult.count)"
                }
                else {
                    
                    //For Single Scann
                    
                    print("value = \(String(describing: metadataObj.stringValue))")
                    print("type = \(metadataObj.type)")
                    var strValues = metadataObj.stringValue
                    print(strValues ?? "")
                    
                    let result: [String] = strValues!.components(separatedBy: "\"")
                    if (result.count > 0) {
                        strValues = result[0]
                    }
                    
                    strType = self.checkBarCodeType(metadataObj: metadataObj)
                
                    let historyM : HistoryModel = HistoryModel()
                    historyM.strScanType = strType
                    historyM.strisFavorite = "0"
                    historyM.strDescription = strValues!
                    historyM.strIsQRorBarcode = isQROrBarCode
                    historyM.strBatchId = "1"
                    historyM.strEventName = ""
                    
                    self.arrScannedResult.add(historyM)
                    
                    self.playBeepSoundOrNot()
                    
                    let isSuccess = DBManager.sharedInstance.addHistory(toDbRegionArray: self.arrScannedResult as! [HistoryModel], toTable: Global.kHistoryTable)
                    
                    if (isSuccess) {
                        print("Record Inserted Successfully")
                        let lastInsertedId : Int = DBManager.sharedInstance.GetMaxlId(table: Global.kHistoryTable)
                        captureSession.stopRunning()
                        self.pushInBarVC(strValue:strValues! , Type: strType, lastInsertedId: lastInsertedId)
                    }
                }
                print("value = \(String(describing: metadataObj.stringValue))")
                print("type = \(metadataObj.type)")
            }
            else{
                print("type = \(metadataObj.type)   NOT SUPPORTED")
            }*/
        }
    }
    
    
    func playBeepSoundOrNot () {
        if ( Global.kQRAppSettingData().isBeepSound == "1" ) {
            if let customSoundUrl = Bundle.main.url(forResource: "beep-07", withExtension: "mp3") {
                var customSoundId: SystemSoundID = 0
                AudioServicesCreateSystemSoundID(customSoundUrl as CFURL, &customSoundId)
                //let systemSoundId: SystemSoundID = 1016  // to play apple's built in sound, no need for upper 3 lines
                
                AudioServicesAddSystemSoundCompletion(customSoundId, nil, nil, { (customSoundId, _) -> Void in
                    AudioServicesDisposeSystemSoundID(customSoundId)
                }, nil)
                AudioServicesPlaySystemSound(customSoundId)
            }
        }
        if ( Global.kQRAppSettingData().isVibrate == "1" ) {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
    }
    
    func checkBarCodeType (metadataObj: AVMetadataMachineReadableCodeObject ) -> String {
        
        let strValues: String = metadataObj.type._rawValue as String
        
        var strType: String = ""
        
        if ((strValues.lowercased().range(of:"ean-13") != nil) || (strValues.lowercased().range(of:"ean13") != nil)) {
            print("EAN-13")
            strType = "EAN-13"
        }
        else  if ((strValues.lowercased().range(of:"ean-8") != nil) || (strValues.lowercased().range(of:"ean8") != nil)) {
            print("EAN-8")
            strType = "EAN-8"
        }
        else if strValues.lowercased().range(of:"code39") != nil {
            print("Code39")
            strType = "Code39"
        }
        else if ((strValues.lowercased().range(of:"code128") != nil)) {
            print("code128")
            strType = "code128"
        }
        else if ((strValues.lowercased().range(of:"upce") != nil) || (strValues.lowercased().range(of:"upc-e") != nil)) {
            print("UPC-E")
            strType = "UPC-E"
        }
        else if strValues.lowercased().range(of:"aztec") != nil {
            print("Aztec")
            strType = "Aztec"
        }
        else if strValues.lowercased().range(of:"pdf417") != nil {
            print("PDF417")
            strType = "PDF417"
        }
        else if strValues.lowercased().range(of:"itf14") != nil {
            print("itf14")
            strType = "itf14"
        }
        else if strValues.lowercased().range(of:"interleaved2of5") != nil {
            print("interleaved2of5")
            strType = "interleaved2of5"
        }
        else {
            //text
            strType = "BarCode"
        }
        return strType;
    }
    
}

extension ScaneerVC1 : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if (Global.singleton.getisQRScanning() == true) {
            
            if let qrcodeImg = info[UIImagePickerControllerOriginalImage] as? UIImage {
                let detector:CIDetector=CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])!
                let ciImage:CIImage=CIImage(image:qrcodeImg)!
                var qrCodeLink=""
                
                let features=detector.features(in: ciImage)
                for feature in features as! [CIQRCodeFeature] {
                    qrCodeLink += feature.messageString!
                }
                
                if qrCodeLink=="" {
                    print("nothing")
                }else{
                    print("message: \(qrCodeLink)")
                }
                
                var strType: String = ""
                
                if qrCodeLink.lowercased().range(of:"http") != nil {
                    print("URL")
                    strType = "URL"
                    print(qrCodeLink)
                    //let newString = strValues.replacingOccurrences(of: "http", with: "", options: .literal, range: nil)
                }
                else if qrCodeLink.lowercased().range(of:"mailto") != nil {
                    strType = "Mail"
                    print("Mail")
                }
                else if (qrCodeLink.lowercased().range(of:"begin:vcard") != nil){
                    strType = "VCARD"
                    print("VCARD")
                }
                else if qrCodeLink.lowercased().range(of:"") != nil {
                    strType = "VCARD"
                    print("VCARD")
                }
                else {
                    strType = "Text"
                }
                let historyM : HistoryModel = HistoryModel()
                historyM.strScanType    = strType
                historyM.strisFavorite  = "0"
                historyM.strDescription = qrCodeLink
                historyM.strBatchId = "1"
                historyM.strEventName = ""
                
                self.arrScannedResult.add(historyM)
                
                let isSuccess = DBManager.sharedInstance.addHistory(toDbRegionArray: self.arrScannedResult as! [HistoryModel], toTable: Global.kHistoryTable)
                
                if (isSuccess) {
                    print("Record Inserted Successfully")
                }
                
                self.dismiss(animated: true, completion: nil)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    self.pushInPerticularTypeVC(strValue:qrCodeLink , Type: strType, lastInsertedId: 1)
                })
            }
            else{
                print("Something went wrong")
            }
        }
        else {
            let qrcodeImg = info[UIImagePickerControllerOriginalImage] as? UIImage
            
            let imageToDecode: CGImage? = qrcodeImg?.cgImage
            // Given a CGImage in which we are looking for barcodes
            let source = (ZXCGImageLuminanceSource(cgImage: imageToDecode))
            let bitmap = ZXBinaryBitmap(binarizer: ZXHybridBinarizer(source: source))
            var _: Error? = nil
            // There are a number of hints we can give to the reader, including
            // possible formats, allowed lengths, and the string encoding.
            let hints = ZXDecodeHints()
            let reader = ZXMultiFormatReader()
            let result: ZXResult? = try? reader.decode(bitmap, hints: hints)
            var typeofbar : String = "BARCODE"
            
            if result != nil {
                let contents: String? = result?.text
                print(contents ?? "")
                // The barcode format, such as a QR code or UPC-A
                typeofbar = self.iDentifyTypesofBarCode(result: result!)
                self.dismiss(animated: true, completion: {
                    let historyM : HistoryModel = HistoryModel()
                    historyM.strScanType = typeofbar
                    historyM.strisFavorite = "0"
                    historyM.strDescription = (result?.text)!
                    historyM.strIsQRorBarcode = "2"
                    historyM.strBatchId = "1"
                    historyM.strEventName = ""
                    
                    self.arrScannedResult.add(historyM)
                    
                    self.playBeepSoundOrNot()
                    
                    let isSuccess = DBManager.sharedInstance.addHistory(toDbRegionArray: self.arrScannedResult as! [HistoryModel], toTable: Global.kHistoryTable)
                    
                    if (isSuccess) {
                        print("Record Inserted Successfully")
                        let lastInsertedId : Int = DBManager.sharedInstance.GetMaxlId(table: Global.kHistoryTable)
                        self.pushInBarVC(strValue:(result?.text)! , Type: typeofbar, lastInsertedId: lastInsertedId)
                    }
                })
            }
            else {
                //AJNotificationView.showNotice(in: self.view, type: AJNotificationTypeRed, title: "Can't Read this BARCode", hideAfter: 1.0)
                Global.singleton.showWarningAlert(withMsg:"Can't Read this BAR Code")
                self.dismiss(animated: true, completion: {
                    
                })
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func iDentifyTypesofBarCode (result: ZXResult) -> String {
        var barType : String = ""
        let format: ZXBarcodeFormat? = result.barcodeFormat
        if format == kBarcodeFormatAztec {
            /** Aztec 2D barcode format. */
            barType = "Aztec 2D"
        }
        else if format == kBarcodeFormatCodabar {
            /** CODABAR 1D format. */
            barType = "CODABAR"
        }
        else if format == kBarcodeFormatCode39 {
            /** Code 39 1D format. */
            barType = "Code 39"
        }
        else if format == kBarcodeFormatCode93 {
            /** Code 93 1D format. */
            barType = "Code 93"
        }
        else if format == kBarcodeFormatCode128 {
            /** Code 128 1D format. */
            barType = "Code 128"
        }
        else if format == kBarcodeFormatDataMatrix {
            /** Data Matrix 2D barcode format. */
            barType = "Data Matrix 2D"
        }
        else if format == kBarcodeFormatEan8 {
            /** EAN-8 1D format. */
            barType = "EAN-8"
        }
        else if format == kBarcodeFormatEan13 {
            /** EAN-13 1D format. */
            barType = "EAN-13"
        }
        else if format == kBarcodeFormatITF {
            /** ITF (Interleaved Two of Five) 1D format. */
            barType = "ITF"
        }
        else if format == kBarcodeFormatMaxiCode {
            /** MaxiCode 2D barcode format. */
            barType = "MaxiCode"
        }
        else if format == kBarcodeFormatPDF417 {
            /** PDF417 format. */
            barType = "PDF417"
        }
        else if format == kBarcodeFormatQRCode {
            /** QR Code 2D barcode format. */
            barType = "QR"
        }
        else if format == kBarcodeFormatRSS14 {
            /** RSS 14 */
            barType = "RSS14"
        }
        else if format == kBarcodeFormatRSSExpanded {
            /** RSS EXPANDED */
            barType = "RSS"
        }
        else if format == kBarcodeFormatUPCA {
            /** UPC-A 1D format. */
              barType = "UPC-A"
        }
        else if format == kBarcodeFormatUPCE {
            /** UPC-E 1D format. */
            barType = "UPC-E 1D"
        }
        else if format == kBarcodeFormatUPCEANExtension {
            /** UPC/EAN extension format. Not a stand-alone format. */
            barType = "UPC/EAN"
        }
        return barType;
    }
}

