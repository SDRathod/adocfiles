//
//  ViewController.swift
//  App
//
//  Created by admin on 26/12/17.
//  Copyright © 2017 admin. All rights reserved.
//
// MARK: -  Add loader in view
/// Creates a Loader when you call web services (API).
///
/// - parameter viewObj:     On which view you want to display Loader.
/// - parameter boolShow:    Want to show loader or not whan you call API
/// - parameter enableInteraction: Waen you call API allow user interaction or not?

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var lblPwdErrorMsg: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(Global().getLocalizeStr(key: "keyRVPasswordMsg2"))
        lblPwdErrorMsg.text = Global().getLocalizeStr(key: "keyRVPasswordMsg2")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

