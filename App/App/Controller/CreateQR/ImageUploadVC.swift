//
//  ImageUploadVC.swift
//  App
//
//  Created by admin on 09/02/18.
//  Copyright © 2018 admin. All rights reserved.
//https://qiita.com/ottati/items/b86a8a11f1b54564c738

import UIKit
import AssetsLibrary
import IQKeyboardManagerSwift

class ImageUploadVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnCamera: MyButton!
    @IBOutlet weak var btnUploadImages: MyButton!
    var imagePicker: UIImagePickerController?
    var pickedImages = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        DispatchQueue.main.async {
            Global.appDelegate.tabBarCustomObj?.hideTabBar()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

    @IBAction func btnUploadImagesClick(_ sender: Any) {
        
        let elcPicker = ELCImagePickerController.init(imagePicker: ())
        elcPicker?.maximumImagesCount = 3
        //Set the maximum number of images to select to 100
        elcPicker?.returnsOriginalImage = true
        //Only return the fullScreenImage, not the fullResolutionImage
        elcPicker?.returnsImage = true
        //Return UIimage if YES. If NO, only return asset location information
        elcPicker?.onOrder = true
        //For multiple image selection, display and return order of selected images
        elcPicker?.mediaTypes = ["kUTTypeImage"]
        //Supports image and movie types
        elcPicker?.imagePickerDelegate = self
        present(elcPicker ?? UIViewController(), animated: true) {() -> Void in }
    }
    
    @IBAction func btnCameraClick(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension ImageUploadVC :  UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //Convert image in 1 KB
        self.pickedImages.removeAllObjects()
        if (info[UIImagePickerControllerOriginalImage] as? UIImage) != nil {
            var image = info[UIImagePickerControllerOriginalImage] as? UIImage
            image = image?.resized(withPercentage: 0.5)!
            pickedImages.add(image!)
            self.dismiss(animated: true, completion: {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController : CreateImageQR = storyboard.instantiateViewController(withIdentifier :"CreateImageQR") as! CreateImageQR
                viewController.arrImages = self.pickedImages
                self.navigationController?.pushViewController(viewController , animated: true)
            })
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension ImageUploadVC : ELCImagePickerControllerDelegate {
   
    func elcImagePickerController(_ picker: ELCImagePickerController!, didFinishPickingMediaWithInfo info: [Any]!) {
        if (info.count == 0) {
            return
        }
        self.pickedImages.removeAllObjects()
        for any in info {
            let dict = any as! NSMutableDictionary
            var image = dict.object(forKey: UIImagePickerControllerOriginalImage) as! UIImage
            image = image.resized(withPercentage: 0.5)!
            pickedImages.add(image)
        }
        self.dismiss(animated: true, completion: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController : CreateImageQR = storyboard.instantiateViewController(withIdentifier :"CreateImageQR") as! CreateImageQR
            viewController.arrImages = self.pickedImages
            self.navigationController?.pushViewController(viewController , animated: true)
        })
        print(pickedImages)
    }

    
    func elcImagePickerControllerDidCancel(_ picker: ELCImagePickerController!) {
        self.dismiss(animated: true) {
           

        }
    }
}
