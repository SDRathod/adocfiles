//
//  SplashScreen.swift
//  App
//
//  Created by admin on 28/12/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class SplashScreenVC: UIViewController {
    
    @IBOutlet weak var bottomImageConstraint: NSLayoutConstraint!
    
    // MARK: -  View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Global.appDelegate.gotoDetailApp()
//        let myTabVC = self.storyboard?.instantiateViewController(withIdentifier: "UITabBarCustom")
//        self.navigationController?.pushViewController(myTabVC!, animated: true)

//        UIView.animate(withDuration: 2.0, delay: 0.1, options: .autoreverse, animations: {
//            self.bottomImageConstraint.constant += self.view.frame.height - 80
//            self.view.layoutIfNeeded()
//        }, completion: {_ in
//            self.bottomImageConstraint.constant = 0
//            self.view.layoutIfNeeded()
//
//            if #available(iOS 10.0, *) {
//                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: {_ in
//                    let myTabVC = self.storyboard?.instantiateViewController(withIdentifier: "tabBarVC")
//                    self.navigationController?.pushViewController(myTabVC!, animated: true)
//                    //self.tabBarController?.tabBar.selectedImageTintColor = Global.kAppColor.SlectedTabColor;
//                })
//            } else {
//                // Fallback on earlier versions
//            }
//        })

    }

    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
