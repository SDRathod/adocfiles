//
//  UITabBarCustom.swift
//  App
//
//  Created by admin on 22/01/2018.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class UITabBarCustom: UITabBarController, UITabBarControllerDelegate {
    var lblShadowLine: UILabel?
    
    var btnTab1: MyButton?
    var btnTab2: MyButton?
    var btnTab3: MyButton?
    var btnTab4: MyButton?
    var btnTab5: MyButton?
    
    var floatTabAspRatio: CGFloat?
    
    // MARK: -  View Life Cycle Start Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideOriginalTabBar()
        self.addCustomElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: -  Hide Original Add Custom elements Method
    func hideOriginalTabBar() {
        for view in self.tabBar.subviews {
            view.isHidden = true
        }
        //self.tabBar.isHidden = true
        for view in self.view.subviews {
            print(view)
            if view is UITabBar {
                view.isHidden = true
                view.removeFromSuperview()
                break;
            }
        }
    }
    
    func addCustomElements() {
        floatTabAspRatio = Global.screenWidth/CGFloat(320)
        
        self.removeAllOldElements()
    }
    
    func removeAllOldElements() {
        if (btnTab1 != nil) {
            btnTab1?.removeFromSuperview()
        }
        if (btnTab2 != nil) {
            btnTab2?.removeFromSuperview()
        }
        if (btnTab3 != nil) {
            btnTab3?.removeFromSuperview()
        }
        if (btnTab4 != nil) {
            btnTab4?.removeFromSuperview()
        }
        self.addAllElements()
    }
    
    func addAllElements() {
        lblShadowLine = UILabel(frame: CGRect(x: 0, y: Global.screenHeight - (42 * floatTabAspRatio!), width: Global.screenWidth, height: 1))
        lblShadowLine?.layer.shadowColor = UIColor.darkGray.cgColor
        lblShadowLine?.layer.shadowOpacity = 0.1
        lblShadowLine?.layer.shadowOffset = CGSize.zero
        lblShadowLine?.layer.shadowRadius = 1
        lblShadowLine?.layer.shadowPath = UIBezierPath(rect: (lblShadowLine?.bounds)!).cgPath
        self.view.addSubview(lblShadowLine!)
        
        btnTab1 = self.generateTabButton(0, isSelected: true)
        btnTab2 = self.generateTabButton(1, isSelected: false)
        btnTab3 = self.generateTabButton(2, isSelected: false)
        //btnTab4 = self.generateTabButton(3, isSelected: false)
        
        self.view.addSubview(btnTab1!)
        self.view.addSubview(btnTab2!)
        self.view.addSubview(btnTab3!)
       // self.view.addSubview(btnTab4!)
        
        btnTab1?.addTarget(self, action: #selector(UITabBarCustom.buttonClicked(_:)), for: .touchUpInside)
        btnTab2?.addTarget(self, action: #selector(UITabBarCustom.buttonClicked(_:)), for: .touchUpInside)
        btnTab3?.addTarget(self, action: #selector(UITabBarCustom.buttonClicked(_:)), for: .touchUpInside)
        //btnTab4?.addTarget(self, action: #selector(UITabBarCustom.buttonClicked(_:)), for: .touchUpInside)
        
        let rect: CGRect = UIApplication.shared.statusBarFrame
        if (rect.size.height > 20) {
            self.changeFrameOfAllCustomElementForStatusBarHeightChange(2)
        }
    }

    func generateTabButton(_ intTag: Int, isSelected boolSel: Bool) -> MyButton {
        let btn = MyButton(type: .custom)
        btn.tag = intTag
        btn.isSelected = boolSel
        //btn.titleLabel?.font = UIFont(name: Global.kFont.ChilaxIcon, size: Global.singleton.getDeviceSpecificFontSize(18))
       // btn.setTitleColor(UIColor.white, for: .normal)
       // btn.setTitleColor(Global.kAppColor.Blue, for: .highlighted)
        
        let tempY: CGFloat = Global.screenHeight - (70 * floatTabAspRatio!)
        let tempBtnHeight: CGFloat = 70 * floatTabAspRatio!
        let tempBtnWidth: CGFloat = Global.screenWidth / 3
        switch intTag {
        case 0: //Tab-1
            btn.setTitle((""), for: .normal)
            btn.frame = CGRect(x: 0 + (tempBtnWidth * 0), y: tempY, width: tempBtnWidth, height: tempBtnHeight)
            btn.setImage(#imageLiteral(resourceName: "home"), for: .normal)
            
        case 1: //Tab-2
            btn.setTitle("", for: .normal)
            btn.frame = CGRect(x: 0 + (tempBtnWidth * 1), y: tempY, width: tempBtnWidth, height: tempBtnHeight)
            //btn.setTitleColor(Global.kAppColor.Blue, for: .normal)
            btn.setTitleColor(UIColor.black, for: .highlighted)
            btn.setImage(#imageLiteral(resourceName: "history"), for: .normal)
        case 2: //Tab-3
            btn.setImage(#imageLiteral(resourceName: "more_apps"), for: .normal)
            btn.setTitle(LocalizeHelper().localizedString(forKey: ""), for: .normal)
            btn.frame = CGRect(x: 0 + (tempBtnWidth * 2), y: tempY, width: tempBtnWidth, height: tempBtnHeight)
        default: // Tab - 4
            btn.setImage(#imageLiteral(resourceName: "more_apps"), for: .normal)
            btn.setTitle(LocalizeHelper().localizedString(forKey: ""), for: .normal)
            btn.frame = CGRect(x: 0 + (tempBtnWidth * 3), y: tempY, width: tempBtnWidth, height: tempBtnHeight)
        }
        btn.setBackgroundColor(color: Global.kAppColor.AppTheamColor, forState: .normal)
        btn.setBackgroundColor(color: Global.kAppColor.SlectedTabColor, forState: .selected)
        return btn;
    }
    
    // MARK: -  Button Click Methods
    @objc func buttonClicked (_ sender: UIButton) {
            self.selectTab(sender.tag)
    }
    
    // MARK: -  Tab bar selection
    func selectTab (_ intSelTabId: Int) {
        self.selectedIndex = intSelTabId
        if(btnTab1?.tag == intSelTabId) {
            btnTab1?.isSelected = true
            btnTab2?.isSelected = false
            btnTab3?.isSelected = false
            btnTab4?.isSelected = false
        }
        else if(btnTab2?.tag == intSelTabId) {
            btnTab2?.isSelected = true
            btnTab1?.isSelected = false
            btnTab3?.isSelected = false
            btnTab4?.isSelected = false
        }
        else if(btnTab3?.tag == intSelTabId) {
            btnTab3?.isSelected = true
            btnTab2?.isSelected = false
            btnTab1?.isSelected = false
            btnTab4?.isSelected = false
        }
        else if(btnTab4?.tag == intSelTabId) {
            btnTab4?.isSelected = true
            btnTab2?.isSelected = false
            btnTab3?.isSelected = false
            btnTab1?.isSelected = false
        }
    }
    
    // MARK: -  Hide Show Tabbar
    func showTabBar() {
        lblShadowLine?.isHidden = false
        
        btnTab1?.isHidden = false
        btnTab2?.isHidden = false
        btnTab3?.isHidden = false
        btnTab4?.isHidden = false

        btnTab1?.isUserInteractionEnabled = true
        btnTab2?.isUserInteractionEnabled = true
        btnTab3?.isUserInteractionEnabled = true
        btnTab4?.isUserInteractionEnabled = true

    }
    
    func hideTabBar() {
        
        lblShadowLine?.isHidden = true
        
        btnTab1?.isHidden = true
        btnTab2?.isHidden = true
        btnTab3?.isHidden = true
        btnTab4?.isHidden = true
        
        btnTab1?.isUserInteractionEnabled = false
        btnTab2?.isUserInteractionEnabled = false
        btnTab3?.isUserInteractionEnabled = false
        btnTab4?.isUserInteractionEnabled = false
    }
    
    func changeFrameOfAllCustomElementForStatusBarHeightChange(_ flag:Int) {
        var tempIncDec: CGFloat = 0;
        if (flag == 1) {
            tempIncDec = 20
        }
        else if (flag == 2) {
            tempIncDec = -20;
        }
        
        self.btnTab1?.frame = CGRect(x: btnTab1!.frame.origin.x, y: btnTab1!.frame.origin.y + tempIncDec, width: self.btnTab1!.frame.size.width, height: self.btnTab1!.frame.size.height)
        
        self.btnTab2?.frame = CGRect(x: btnTab2!.frame.origin.x, y: btnTab2!.frame.origin.y + tempIncDec, width: self.btnTab2!.frame.size.width, height: self.btnTab2!.frame.size.height)
        
        self.btnTab3?.frame = CGRect(x: btnTab3!.frame.origin.x, y: btnTab3!.frame.origin.y + tempIncDec, width: self.btnTab3!.frame.size.width, height: self.btnTab3!.frame.size.height)
        
        self.btnTab4?.frame = CGRect(x: btnTab4!.frame.origin.x, y: btnTab4!.frame.origin.y + tempIncDec, width: self.btnTab4!.frame.size.width, height: self.btnTab4!.frame.size.height)
        
    }
}
