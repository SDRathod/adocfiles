//
//  VCardVC.swift
//  App
//
//  Created by Samir Rathod on 16/01/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class VCardVC: UIViewController {

    var strVCardData : String = ""
    
    @IBOutlet weak var tblContact: UITableView!
  
    var arrData : NSMutableArray = NSMutableArray()
    
    var scannedContact : CNContact = CNContact()
    var lastInsertedId : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // tblContact.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ContactCell")
        tblContact.estimatedRowHeight = 44.0
        tblContact.delegate = self
        tblContact.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //value = BEGIN:VCARD\nVERSION:3.0\nN:rathod;samir\nFN:samir rathod\nORG:tops\nTITLE:sr ios\nADR:;;Thaltej;ahmedabad;Gujarat;380052;India\nTEL;WORK;VOICE:58585858\nTEL;CELL:989898989\nTEL;FAX:478\nEMAIL;WORK;INTERNET:samir@gmail.cm\nURL:https://google.com\nBDAY:\nEND:VCARD\n
        //")
        
        self.navigationController?.isNavigationBarHidden = true;
        Global.appDelegate.tabBarCustomObj?.hideOriginalTabBar()
        Global.appDelegate.tabBarCustomObj?.hideTabBar()
    
        if let data = strVCardData.data(using: .utf8) {
            
            do{
                let contanctsMy = try CNContactVCardSerialization.contacts(with: data)
            
                contanctsMy.forEach { contact in
                    
                    scannedContact = contact
                    
                    if (contact.familyName != "") {
                        arrData.add("Name : \(contact.familyName) \(contact.givenName)")
                    }
                    
                    if (contact.jobTitle != "") {
                        arrData.add("Job : \(contact.jobTitle)")
                    }
                    
                    for number in contact.phoneNumbers {
                        let phoneNumber : CNPhoneNumber = number.value as CNPhoneNumber
                        print("number is = \(phoneNumber.stringValue)")
                        arrData.add("Phone : \(phoneNumber.stringValue)")
                    }
                    
                    for email in contact.emailAddresses {
                        let phoneNumber = email.value
                        print("email is = \(phoneNumber)")
                        arrData.add("Email : \(phoneNumber)")
                    }
                    
                    for urls in contact.urlAddresses {
                        let phoneNumber = urls.value
                        print("urls is = \(phoneNumber)")
                        arrData.add("URL : \(phoneNumber)")
                    }
                    
                    for address in contact.postalAddresses {
                        let postalAddress : CNPostalAddress = address.value as CNPostalAddress
                        print("address is = \(postalAddress.street),\(postalAddress.subLocality),\(postalAddress.city)")
                        arrData.add("Address : \(postalAddress.street),\(postalAddress.subLocality),\(postalAddress.city)")
                    }
                    
                    for urls in contact.socialProfiles {
                        let phoneNumber = urls.value.urlString
                        print("urls is = \(phoneNumber)")
                        arrData.add("\(urls.label ?? "Social") : \(phoneNumber)")
                    }
                    for urls in contact.instantMessageAddresses {
                        let phoneNumber = urls.value.username
                        print("urls is = \(phoneNumber)")
                        arrData.add("\(urls.label ?? "Message") : \(phoneNumber)")
                    }
                    print("name is = \(contact.familyName)")
                    print("givenName name is = \(contact.givenName)")
                    print("middleName name is = \(contact.middleName)")
                    print("jobTitle is = \(contact.jobTitle)")
                }
            }
            catch{
                // Error Handling
                print(error.localizedDescription)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveContact(_ sender: Any) {
        self.showUnknownContactViewController()
    }
    
    @IBAction func btnFavClick(_ sender: Any) {
        let isSuccess = DBManager.sharedInstance.UpdateIsFavorite(id: lastInsertedId, tblNAme: Global.kHistoryTable, valueforFavorite: "1")
        
        if (isSuccess) {
            Global.singleton.showSuccessAlert(withMsg:"Favorite added suceessfully")
        }
    }
    
    fileprivate func showUnknownContactViewController() {
       
        let ucvc = CNContactViewController(forNewContact: scannedContact)
        ucvc.delegate = self
        ucvc.allowsEditing = true
        ucvc.allowsActions = true
        ucvc.alternateName = scannedContact.familyName
        ucvc.title = scannedContact.jobTitle
        ucvc.delegate = self
        //ucvc.contactStore = self.scannedContact //needed for editing/adding contacts?
        let navigation = UINavigationController(rootViewController: ucvc)
        self.present(navigation, animated: true, completion: nil)
    }
}

extension VCardVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell")
        
        cell?.textLabel?.text = arrData[indexPath.row] as? String
        cell?.selectionStyle = .none
        return cell!
    }
}

extension VCardVC : CNContactViewControllerDelegate {
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        if contact == nil {
            viewController.dismiss(animated: true, completion: nil)
            return
        }
        
        viewController.dismiss(animated: true) {}
    }
    
    func contactViewController(_ viewController: CNContactViewController, shouldPerformDefaultActionFor property: CNContactProperty) -> Bool {
        viewController.dismiss(animated: true, completion: nil)
        return true
    }
}


