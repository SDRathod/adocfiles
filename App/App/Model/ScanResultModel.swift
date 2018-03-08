//
//  ScanResultModel.swift
//  App
//
//  Created by admin on 10/01/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

/**
 Create Custom Model to store Scan Result value in local Array
    ## Important Notes ##
     - strScanValue: store scanned Messages.
     - strScanType:  store scann type.
 */
class ScanResultModel: NSObject {
    var strScanValue : String = ""
    var strScanType  : String = ""
}


class HistoryModel: NSObject {
    var strId : String = ""
    var strScanType  : String = ""
    var strDescription  : String = ""
    var strisFavorite  : String = ""
    var strIsQRorBarcode  : String = ""
    var strBatchId : String = ""  // For Event or Batch Id
    var strEventName : String = "" // Set GroupName or Event name 
}

