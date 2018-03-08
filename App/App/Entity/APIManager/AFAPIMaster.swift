//
//  AFAPIMaster.swift
//  APICaller
//
//  Created by Samir Rathod on 22/11/17.
//  Copyright © 2017 Samir Rathod. All rights reserved.
//

import UIKit

class AFAPIMaster: AFAPICaller {

    static let sharedAPIMaster = AFAPIMaster()
    typealias AFAPIMasterSuccess = (_ returnData : Any) -> Void
    typealias AFAPIMasterFailure = () -> Void
    
    // MARK: -  Get Application Current Version API
    func getAppCurrentVersionData_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.callAPIUsingGET(filePath: "json?input=", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict: Any, success: Bool) in
            if (success) {
                onSuccess(responseDict)
            }
        }, onFailure: { () in
        })
        
    }
    
    
    // MARK: -  Basic Login Registration Flow API
    func postLoginCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        
        self.callAPIUsingPOST(filePath: "user/login?", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
            if (success){
                onSuccess(responseDict)
            }
        }, onFailure:{ () in
        })
        
    }
     // MARK: -  UPLoadImages
    func postMultipleImages_Completion(params: NSMutableDictionary?, images: [UIImage], imageParamNames: [String],showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        
        self.callAPIWithMultiImage(filePath: "webservice.php", params: params, images: images, imageParamNames: imageParamNames, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
            if (success){
                onSuccess(responseDict)
            }
        }) {
        
        }
        
    }
}
