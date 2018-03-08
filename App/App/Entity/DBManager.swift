//
//  DBManager.swift
//  APICaller
//
//  Created by Samir Rathod on 12/01/2018.
//  Copyright © 2017 Samir Rathod. All rights reserved.
//

import UIKit
import FMDB

class DBManager: NSObject {

    static let sharedInstance = DBManager(withDBName: "PaperLess")
    
    
    var dbPath : NSURL!
    var DatabasePAth:String!
    var database : FMDatabase!
    var queryResults : FMResultSet?
    var arrObjects:[String: AnyObject] = [:]
    
    init(withDBName: String) {
        _ = FileManager.default
        let dirPaths =
            NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                .userDomainMask, true)
        let docsDir = dirPaths[0]
        DatabasePAth = docsDir + "/" + withDBName+".db"
        
        //  DatabasePAth = Bundle.main.path(forResource: "\(withDBName)", ofType: ".db")!
        let db = FMDatabase(path: DatabasePAth)
        print("DB Open From Path......=== \(DatabasePAth)")
        if !(db.open()) {
            print("Unable to open database, some random error happened.")
        }
        else {
            database = db
        }
    }
    
    /// Sets the dbPath and the database member variables
    ///  - parameters:
    ///     - dbName (String): The name of the DB. Uses a constant defined in strings.swift
    
    func getDatabase(dbName : String) -> Bool {
        _ = FileManager.default
        let dirPaths =
            NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                .userDomainMask, true)
        let docsDir = dirPaths[0]
        DatabasePAth = docsDir + "/" + dbName+".db"
        //DatabasePAth = Bundle.main.path(forResource: "\(dbName)", ofType: ".db")!
        let db = FMDatabase(path: DatabasePAth)
        if !(db.open()) {
            print("Unable to open database, some random error happened.")
        }
        else {
            database = db
            return true
        }
        return false
    }
    
    ///Closes the connection to the class database
    func closeDatabase() -> Void {
        database.close()
    }

    // MARK: -  Add loader in view
    func addShowLoaderInView(viewObj: UIView, boolShow: Bool, enableInteraction: Bool) -> UIView? {
        let viewSpinnerBg = UIView(frame: CGRect(x: (Global.screenWidth - 54.0) / 2.0, y: (Global.screenHeight - 54.0) / 2.0, width: 54.0, height: 54.0))
        viewSpinnerBg.backgroundColor = UIColor.gray
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
        }
        return viewSpinnerBg
    }
        
    // MARK: -  Hide and remove loader from view
    func hideRemoveLoaderFromView(removableView: UIView, mainView: UIView) {
        removableView.isHidden = true
        removableView.removeFromSuperview()
        mainView.isUserInteractionEnabled = true
    }

    func GetMaxlId(table:String) -> Int {
        if !database.open() {
            return 0
        }
        database.beginTransaction()
        
        let strQuery = "Select max(id) from \(table)"
        var strr : Int = 0
        
        if let results = database.executeQuery(strQuery, withArgumentsIn: []) {
            queryResults = nil
            while (results.next()) {
                queryResults = results
                strr = Int(results.int(forColumn: "max(id)"))
            }
            results.close()
        }
        database.commit()
        database.close()
        return strr
    }
    
     // MARK: -  addHistorywithBarId
    
    func addHistorywithBarId(toDbRegionArray arrData: [HistoryModel], toTable:String, barId: String) -> Bool {
        if !database.open() {
            return false
        }
        
        for histroyM in arrData {
            
            database.beginTransaction()
            let insertSQL:String = "INSERT INTO \(toTable)(ScanType,Description,isFavorite,isQRorBarCode,Barid) values('\(histroyM.strScanType)','\(histroyM.strDescription)','\(histroyM.strisFavorite)','\(histroyM.strIsQRorBarcode)','\(barId)')"
            print(insertSQL)
            _ = database.executeUpdate(insertSQL,
                                       withArgumentsIn: [])
            
            database.commit()
            database.close()
        }
        
        return true
    }
    
    // MARK: -  Insert History
    
    func addHistory(toDbRegionArray arrData: [HistoryModel], toTable:String) -> Bool {
        if !database.open() {
            return false
        }
        
        for histroyM in arrData {
            
            database.beginTransaction()
            let insertSQL:String = "INSERT INTO \(toTable)(ScanType,Description,isFavorite,isQRorBarCode,Barid) values('\(histroyM.strScanType)','\(histroyM.strDescription)','\(histroyM.strisFavorite)','\(histroyM.strIsQRorBarcode)','\(histroyM.strBatchId)')"
            print(insertSQL)
            _ = database.executeUpdate(insertSQL,
                                       withArgumentsIn: [])
            
            database.commit()
            database.close()
        }
        
        return true
    }
    
    // MARK: -  Insert addHistoryWith Group Name
    
    func addHistoryWithName(wihBatchName strBatchName: String, toTable:String) -> Bool {
        if !database.open() {
            return false
        }
        
        database.beginTransaction()
        let insertSQL:String = "INSERT INTO \(toTable)(groupName) values('\(strBatchName)')"
        print(insertSQL)
        _ = database.executeUpdate(insertSQL,
                                   withArgumentsIn: [])
        
        database.commit()
        database.close()
        
        return true
    }
    
    // MARK: -  Update History for Favorite
    
    func UpdateIsFavorite(id:Int, tblNAme:String, valueforFavorite:String) -> Bool {
        if database == nil {
            print("Error: No database created")
            return false
        }
        if database.open() {
            let insertSQL = "UPDATE \(tblNAme) set isFavorite = '\(valueforFavorite)' WHERE id = '\(id)'"
            let result = database.executeUpdate(insertSQL,
                                                withArgumentsIn: [])
            if !result {
                print("Error: \(database.lastErrorMessage())")
                
                return false
            } else {
                
                return true
            }
        }
        
        return false
    }
    
    func UpdateIsFavoriteusingContent(content:String, tblNAme:String, valueforFavorite:String) -> Bool {
        if database == nil {
            print("Error: No database created")
            return false
        }
        if database.open() {
            let insertSQL = "UPDATE \(tblNAme) set isFavorite = '\(valueforFavorite)' WHERE Description = '\(content)'"
            let result = database.executeUpdate(insertSQL,
                                                withArgumentsIn: [])
            if !result {
                print("Error: \(database.lastErrorMessage())")
                
                return false
            } else {
                
                return true
            }
        }
        
        return false
    }
    
    // MARK: -  Delete History
    
    func deleteFrom(toTable:String, arrIDS: [Int]) -> Bool {
        
        if database == nil {
            print("Error: No database created")
            return false
        }
        for singleId : Int in arrIDS {
            if database.open() {
                let insertSQL = "DELETE FROM \(toTable)  WHERE id = '\(singleId)'"
                let result = database.executeUpdate(insertSQL,
                                                    withArgumentsIn: [])
                if !result {
                    print("Error: \(database.lastErrorMessage())")
                    
                    return false
                } else {
                    
                    return true
                }
            }
        }
        return false
    }
    
    func SearchcomparingAllContacts(tblName:String) -> [String]?
    {
        var arrstr:[String] = []
        if database == nil {
            print("Error: No database created")
            return nil
        }
        
        if database.open() {
            
            let querySQL = "SELECT * FROM \(tblName)"
            if let results = database.executeQuery(querySQL, withArgumentsIn: []) {
                queryResults = nil
                while (results.next()) {
                    queryResults = results
                    let id = results.int(forColumn: "contact_id")
                    arrstr.append( "\(id)")
                    
                }
                results.close()
                return arrstr
            }
        }
        else {
            
            return nil
        }
        
        return nil
    }
    
    func selectAllHistroyData (tblName: String)  -> NSMutableArray {
        let arrHistory : NSMutableArray = NSMutableArray()
        if database.open() {
            
            //let querySQL = "SELECT * FROM \(tblName)"
            let querySQL = "SELECT History.id, History.Description, History.isFavorite, History.isQRorBarCode, History.ScanType, History.Barid, tblBarCode.groupName  FROM History JOIN tblBarCode where History.barid = tblBarCode.Bar_id"
            
            if let results = database.executeQuery(querySQL, withArgumentsIn: []) {
                queryResults = nil
                while (results.next()) {
                    queryResults = results
                    let historyShare : HistoryModel = HistoryModel()
                    historyShare.strId = "\(Int(results.int(forColumn: "id")))"
                    historyShare.strScanType = results.string(forColumn: "ScanType")!
                    historyShare.strisFavorite = results.string(forColumn: "isFavorite")!
                    historyShare.strDescription = results.string(forColumn: "Description")!
                    historyShare.strIsQRorBarcode = results.string(forColumn: "isQRorBarCode")!
                    historyShare.strBatchId = results.string(forColumn: "Barid")!
                    historyShare.strEventName = results.string(forColumn: "groupName")!
                    arrHistory.add(historyShare)
                }
                results.close()
               
            }
             return arrHistory
        }
        else {
            
            return arrHistory
        }
    }
    
    func selectFavoritesFromHistroyTable (tblName: String)  -> NSMutableArray {
        let arrFavHistory : NSMutableArray = NSMutableArray()
        if database.open() {
            
            let querySQL = "SELECT * FROM \(tblName) where isFavorite = 1"
            
            
            if let results = database.executeQuery(querySQL, withArgumentsIn: []) {
                queryResults = nil
                while (results.next()) {
                    queryResults = results
                    let historyShare : HistoryModel = HistoryModel()
                    historyShare.strId = "\(Int(results.int(forColumn: "id")))"
                    historyShare.strScanType = results.string(forColumn: "ScanType")!
                    historyShare.strisFavorite = results.string(forColumn: "isFavorite")!
                    historyShare.strDescription = results.string(forColumn: "Description")!
                    historyShare.strIsQRorBarcode = results.string(forColumn: "isQRorBarCode")!
                    arrFavHistory.add(historyShare)
                }
                results.close()
                
            }
            return arrFavHistory
        }
        else {
            
            return arrFavHistory
        }
    }
    

}
