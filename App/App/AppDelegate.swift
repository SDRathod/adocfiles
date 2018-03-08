//
//  AppDelegate.swift
//  App
//
//  Created by admin on 26/12/17.
//  Copyright © 2017 admin. All rights reserved.
//
/*
 Command for document :
 
 sudo gem install jazzy
 jazzy --min-acl private
 
 https://iosdevcenters.blogspot.com/2017/09/building-barcode-and-qr-code-reader-in.html
 */

import UIKit
import Fabric
import Crashlytics
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabBarCustomObj: UITabBarCustom?
    var homeObj: HomeVC?
    var createCodeObj: CreateCodeVC?
    var historyObj: HistoryVC?
    var moreAppObj: MoreAppVC?
    var navObj: UINavigationController?
    var splashObj : SplashScreenVC?
    
    func fontDisplayAllFonts() -> Void {
        for family: String in UIFont.familyNames
        {
            print("\(family)")
            for names: String in UIFont.fontNames(forFamilyName: family)
            {
                print("== \(names)")
            }
        }
    }
  

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.sharedManager().enable = true
        Fabric.with([Crashlytics.self])
         let launchedBefore = UserDefaults.standard.bool(forKey: "QRApplaunchedBefore")
        if launchedBefore  {
            print("Not first launch. already launch")
            
        } else {
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "QRApplaunchedBefore")
            Global.singleton.saveToUserDefaults(value: "1", forKey: Global.kQRAppSettingKeys.BeepSound)
            Global.singleton.saveToUserDefaults(value: "1", forKey: Global.kQRAppSettingKeys.Vibration)
            Global.singleton.saveToUserDefaults(value: "1", forKey: Global.kQRAppSettingKeys.DisplayLaser)
            Global.singleton.saveToUserDefaults(value: "1", forKey: Global.kQRAppSettingKeys.MyCardcontactId)
        }
        self.fontDisplayAllFonts()
        
        if let sb = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView {
            sb.backgroundColor = UIColor.black
            
            // if you prefer a light gray under there...
            //sb.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.9, alpha: 1)
        }
        
        
        
        if (Global.LanguageData().SelLanguage == "" || Global.LanguageData().SelLanguage == nil) {
            Global.singleton.saveToUserDefaults(value: Global.LanguageData.German, forKey: Global.LanguageData.SelLanguageKey)
        }
        LocalizeHelper.sharedLocalSystem().setLanguage(Global.LanguageData().SelLanguage)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.copyDatabaseIfNeeded()
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        splashObj = storyboard.instantiateViewController(withIdentifier :"SplashScreenVC") as? SplashScreenVC
        navObj = UINavigationController.init(rootViewController: splashObj!)
        navObj?.navigationBar.isHidden = true
        window?.rootViewController = navObj;
        window?.makeKeyAndVisible()
        
        
//        self.window.backgroundColor = UIColor(red: 0.78, green: 0.13, blue: 0.11, alpha: 1)
//        application.statusBarStyle = UIStatusBarStyleBlackTranslucent
//
        //self.gotoDetailApp()
        return true
    }

    //MARK: Copy Database
    /**
      Funciton is useful to copy db from app to Document folder.

      @return nothing.
     */
    func copyDatabaseIfNeeded() {
        // Move database file from bundle to documents folder
        let fileManager = FileManager.default
        let documentsUrl = fileManager.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        guard documentsUrl.count != 0 else {
            return // Could not find documents URL
        }
        
        let finalDatabaseURL = documentsUrl.first!.appendingPathComponent("PaperLess.db")
        
        if !( (try? finalDatabaseURL.checkResourceIsReachable()) ?? false) {
            print("DB does not exist in documents folder")
            
            let documentsURL = Bundle.main.resourceURL?.appendingPathComponent("PaperLess.db")
            
            do {
                print("document URL Path......=== \(documentsURL!.path)")
                print("Final Database Path......=== \(finalDatabaseURL.path)")
                try fileManager.copyItem(atPath: (documentsURL?.path)!, toPath: finalDatabaseURL.path)
            } catch let error as NSError {
                print("Couldn't copy file to final location! Error:\(error.description)")
            }
            
        } else {
            print("Database file found at path: \(finalDatabaseURL.path)")
        }
    }

    // MARK: -  Push Tabbar control

        func gotoDetailApp() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            // Crashlytics.sharedInstance().crash()
            //self.tabBarCustomObj = storyboard.instantiateViewController(withIdentifier :"UITabBarCustom") as? UITabBarCustom
           
            self.tabBarCustomObj = UITabBarCustom(nibName: "UITabBarCustom", bundle: nil)
            homeObj = storyboard.instantiateViewController(withIdentifier :"HomeVC") as? HomeVC
           // createCodeObj = storyboard.instantiateViewController(withIdentifier :"CreateCodeVC") as? CreateCodeVC
            historyObj = storyboard.instantiateViewController(withIdentifier :"HistoryVC") as? HistoryVC
            moreAppObj = storyboard.instantiateViewController(withIdentifier :"MoreAppVC") as? MoreAppVC
    
            let navhomeObj: UINavigationController = UINavigationController.init(rootViewController: homeObj!)
            //let navcreateCodeObj: UINavigationController = UINavigationController.init(rootViewController: createCodeObj!)
            let navhistoryObj: UINavigationController = UINavigationController.init(rootViewController: historyObj!)
            let navmoreAppObj: UINavigationController = UINavigationController.init(rootViewController: moreAppObj!)
    
            self.tabBarCustomObj?.viewControllers = [navhomeObj, navhistoryObj, navmoreAppObj]
    
            navObj?.pushViewController(self.tabBarCustomObj!, animated: true)
        }
    
}

func UIImage2CGimage(_ image: UIImage?) -> CGImage? {
    if let tryImage = image, let tryCIImage = CIImage(image: tryImage) {
        return CIContext().createCGImage(tryCIImage, from: tryCIImage.extent)
    }
    return nil
}
