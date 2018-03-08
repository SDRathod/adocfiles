//
//  AFAPICaller.swift
//  APICaller
//
//  Created by Samir Rathod on 22/11/17.
//  Copyright © 2017 Samir Rathod. All rights reserved.
//

import UIKit
import AFNetworking
import SpinKit

class AFAPICaller: NSObject {
    
    typealias AFAPICallerSuccess = (_ responseData : Any, _ success : Bool) -> Void
    typealias AFAPICallerFailure = () -> Void
    

    var manager  =  AFHTTPSessionManager(sessionConfiguration: .default)
    static let  shared = AFAPICaller()
    
    // MARK: -  Add loader in view
    func addShowLoaderInView(viewObj: UIView, boolShow: Bool, enableInteraction: Bool) -> UIView? {
        let viewSpinnerBg = UIView(frame: CGRect(x: (Global.screenWidth - 54.0) / 2.0, y: (Global.screenHeight - 54.0) / 2.0, width: 54.0, height: 54.0))
        viewSpinnerBg.backgroundColor = UIColor.brown //Global().RGB(r: 240, g: 240, b: 240, a: 0.4)
        viewSpinnerBg.layer.masksToBounds = true
        viewSpinnerBg.layer.cornerRadius = 5.0
        viewObj.addSubview(viewSpinnerBg)
        
        if boolShow {
            viewSpinnerBg.isHidden = false
        }
        else {
            viewSpinnerBg.isHidden = true
        }
        
        if !enableInteraction {
            viewObj.isUserInteractionEnabled = false
           // Global.appDelegate.tabBarCustomObj?.view.isUserInteractionEnabled = false
        }
        
        //add spinner in view
        let rtSpinKitspinner: RTSpinKitView = RTSpinKitView(style: RTSpinKitViewStyle.styleFadingCircleAlt, color: UIColor.white)
        rtSpinKitspinner.center = CGPoint(x: (viewSpinnerBg.frame.size.width - 8.0) / 2.0, y: (viewSpinnerBg.frame.size.height - 8.0) / 2.0)
        rtSpinKitspinner.color = Global.kAppColor.AppTheamColor
        rtSpinKitspinner.startAnimating()
        viewSpinnerBg.addSubview(rtSpinKitspinner)
        
        return viewSpinnerBg
    }
//    
    // MARK: -  Hide and remove loader from view
    func hideRemoveLoaderFromView(removableView: UIView, mainView: UIView) {
        removableView.isHidden = true
        removableView.removeFromSuperview()
        mainView.isUserInteractionEnabled = true
        Global.appDelegate.tabBarCustomObj?.view.isUserInteractionEnabled = true
    }
    
    // MARK: -  Call web service with GET method
    func callAPIUsingGET(filePath: String, params: NSMutableDictionary?, enableInteraction: Bool, showLoader: Bool, viewObj: UIView, onSuccess: @escaping (AFAPICallerSuccess), onFailure: (AFAPICallerFailure)) {
        
        let strPath = Global.baseURLPath + filePath;
        
        let viewSpinner: UIView = self.addShowLoaderInView(viewObj: viewObj, boolShow: showLoader, enableInteraction: enableInteraction)!
        
        let afManager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        afManager.get(strPath, parameters: params, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            
            self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
            
            let dictResponse = responseObject as! NSDictionary
            if (dictResponse.object(forKey: "error") as! Bool == false) { //no error
                onSuccess(dictResponse, true)
            }
            else { //with error
                if (showLoader) {
                    Global.singleton.showWarningAlert(withMsg: dictResponse.object(forKey: "response") as? String ?? "Something went wrong please try again")
                }
                onSuccess(dictResponse, false)
            }
        }) { (task: URLSessionDataTask?, error: Error) in
           self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
            if (showLoader) {
                Global.singleton.showWarningAlert(withMsg: LocalizeHelper().localizedString(forKey: "keyInternetMsg"))
            }
        }
    }
    
    // MARK: -  Call web service with POST method
    func callAPIUsingPOST(filePath: String, params: NSMutableDictionary?, enableInteraction: Bool, showLoader: Bool, viewObj: UIView, onSuccess: @escaping (AFAPICallerSuccess), onFailure: (AFAPICallerFailure)) {
        let strPath = Global.baseURLPath + filePath;
        
        let viewSpinner: UIView = self.addShowLoaderInView(viewObj: viewObj, boolShow: showLoader, enableInteraction: enableInteraction)!
        print("Param:- \(String(describing: params))")
        let afManager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        afManager.post(strPath, parameters: params, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            
            self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
            
            let dictResponse = responseObject as! NSDictionary
            print("Response:- \(dictResponse)")
            if (dictResponse.object(forKey: "error") as! Bool == false) { //no error
                onSuccess(dictResponse, true)
            }
            else { //with error
                if (showLoader) {
                    if ((dictResponse.object(forKey: "response") as? String) != nil){
                        Global.singleton.showWarningAlert(withMsg: dictResponse.object(forKey: "response") as? String ?? "Something went wrong please try again")
                    }
                }
                onSuccess(dictResponse, false)
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
            if (showLoader) {
                Global.singleton.showWarningAlert(withMsg: LocalizeHelper().localizedString(forKey: "keyInternetMsg"))
            }
        }
    }
    
    // MARK: -  Call web service with one image
    func callAPIWithImage(filePath: String, params: NSMutableDictionary?, image: UIImage?, imageParamName: String, enableInteraction: Bool, showLoader: Bool, viewObj: UIView, onSuccess: @escaping (AFAPICallerSuccess), onFailure: (AFAPICallerFailure)) {
        let strPath = Global.baseURLPath + filePath;
        
        let viewSpinner: UIView = self.addShowLoaderInView(viewObj: viewObj, boolShow: showLoader, enableInteraction: enableInteraction)!
        
        let afManager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        
        afManager.post(strPath, parameters: params, constructingBodyWith: { (Data) in
            if (image != nil) {
                let imageData: Data = UIImagePNGRepresentation(image!)!
                Data.appendPart(withFileData: imageData, name: imageParamName, fileName: "photo.png", mimeType: "image/png")
            }
        }, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            
            self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
            
            let dictResponse = responseObject as! NSDictionary
            if (dictResponse.object(forKey: "error") as! Bool == false) { //no error
                onSuccess(dictResponse, true)
            }
            else { //with error
                if (showLoader) {
                   Global.singleton.showWarningAlert(withMsg: dictResponse.object(forKey: "response") as? String ?? "Something went wrong please try again")
                }
                onSuccess(dictResponse, false)
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
            if (showLoader) {
               Global.singleton.showWarningAlert(withMsg: LocalizeHelper().localizedString(forKey: "keyInternetMsg"))
            }
        }
    }
    
    // MARK: -  Call web service with multi image
    func callAPIWithMultiImage(filePath: String, params: NSMutableDictionary?, images: [UIImage], imageParamNames: [String], enableInteraction: Bool, showLoader: Bool, viewObj: UIView, onSuccess: @escaping (AFAPICallerSuccess), onFailure: (AFAPICallerFailure)) {
        let strPath = "http://206.72.192.56/qrcode/" + filePath;
        
      let viewSpinner: UIView = self.addShowLoaderInView(viewObj: viewObj, boolShow: showLoader, enableInteraction: enableInteraction)!
        
        let afManager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        
        afManager.post(strPath, parameters: params, constructingBodyWith: { (Data) in
            var i: Int = 0
            for image in images {
                let imageData: Data = UIImagePNGRepresentation(image)!
                Data.appendPart(withFileData: imageData, name: imageParamNames[i], fileName: "photo.png", mimeType: "image/png")
                i = i+1;
            }
        }, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            
            self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
            
            let dictResponse = responseObject as! NSDictionary
            if (dictResponse.object(forKey: "status") as! Int == 1) { //no error
                onSuccess(dictResponse, true)
            }
            else { //with error
                if (showLoader) {
                  Global.singleton.showWarningAlert(withMsg: dictResponse.object(forKey: "response") as? String ?? "Something went wrong please try again")
                }
                onSuccess(dictResponse, false)
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
            if (showLoader) {
               Global.singleton.showWarningAlert(withMsg: LocalizeHelper().localizedString(forKey: "keyInternetMsg"))
            }
        }
    }
}
