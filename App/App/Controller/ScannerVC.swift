//
//  ScannerVC.swift
//  App
//
//  Created by admin on 02/01/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var previewView: QRCodeReaderView! {
        didSet {
            previewView.setupComponents(showCancelButton: false, showSwitchCameraButton: false, showTorchButton: false, showOverlayView: true, reader: reader)
        }
    }
    
    lazy var reader: QRCodeReader = QRCodeReader()
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader          = QRCodeReader(metadataObjectTypes: [.qr,.upce,
                                                                    .code39,
                                                                    .code39Mod43,
                                                                    .code93,
                                                                    .code128,
                                                                    .ean8,
                                                                    .ean13,
                                                                    .aztec,
                                                                    .pdf417,
                                                                    .itf14,
                                                                    .dataMatrix,
                                                                    .interleaved2of5], captureDevicePosition: .back)
            $0.showTorchButton = true
            
            $0.reader.stopScanningWhenCodeIsFound = false
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    // MARK: - Actions
    
    private func checkScanPermissions() -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
            let alert: UIAlertController
            
            switch error.code {
            case -11852:
                alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                            UIApplication.shared.openURL(settingsURL)
                        }
                    }
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            default:
                alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            }
            
            present(alert, animated: true, completion: nil)
            
            return false
        }
    }
    
    @IBAction func scanInModalAction(_ sender: AnyObject) {
        guard checkScanPermissions() else { return }
        
        readerVC.modalPresentationStyle = .formSheet
        readerVC.delegate               = self as? QRCodeReaderViewControllerDelegate
        
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if let result = result {
                print("Completion with result: \(result.value) of type \(result.metadataType)")
            }
        }
        
        present(readerVC, animated: true, completion: nil)
    }
    
    @IBAction func scanInPreviewAction(_ sender: Any) {
        guard checkScanPermissions(), !reader.isRunning else { return }
        
        reader.didFindCode = { result in
            print("Completion with result: \(result.value) of type \(result.metadataType)")
        }
        
        reader.startScanning()
    }
    
    // MARK: - QRCodeReader Delegate Methods
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        // reader.stopScanning()
        
        //    let alert = UIAlertController(
        //        title: "QRCodeReader",
        //        message: String (format:"%@ (of type %@)", result.value, result.metadataType),
        //        preferredStyle: .alert
        //    )
        //    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        //
        //    self?.present(alert, animated: true, completion: nil)
        //
        // dismiss(animated: true) { [weak self] in
        
        print(">> All the value of which is sanned = \(result.value)) of type \(result.metadataType)", result.value, result.metadataType)
        
        //      let alert = UIAlertController(
        //        title: "QRCodeReader",
        //        message: String (format:"%@ (of type %@)", result.value, result.metadataType),
        //        preferredStyle: .alert
        //      )
        //      alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        //
        //      self.present(alert, animated: true, completion: nil)
        //}
    }
    
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        print("Switching capturing to: \(newCaptureDevice.device.localizedName)")
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
}
