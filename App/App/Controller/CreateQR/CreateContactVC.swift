//
//  CreateContactVC.swift
//  App
//
//  Created by manish on 02/02/18.
//  Copyright © 2018 admin. All rights reserved.
//

/*
 
 1) Create Phone, email cell
 2) Create Note Cell
 3) Create Address Cell
 3) Create 4 section Tableview - Phone, Email, Address and Note
 4) Create an Array of Phone, email, Note and Address
 5) Create QR String for VCARD from above data
 
 */

import UIKit
import Contacts
import ContactsUI
import IQKeyboardManagerSwift


class CreateContactVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtTitle: UITextField!  //Position
    @IBOutlet weak var txtCompany: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var tblCreateContact: UITableView!
    @IBOutlet weak var txtFname: UITextField!
    @IBOutlet weak var scrollObj: UIScrollView!
    var imagePicker: UIImagePickerController?
    
    @IBOutlet weak var ScrollContentView: UIView!
    //All Cell Array
    var arrPhones : NSMutableArray = NSMutableArray()
    var arrEmails : NSMutableArray = NSMutableArray()
    var arrURLs :  NSMutableArray = NSMutableArray()
    var arrSocials :  NSMutableArray = NSMutableArray()
    var arrInstantMsg :  NSMutableArray = NSMutableArray()
    var arrAddress :  NSMutableArray = NSMutableArray()
    var arrAboutMe :  NSMutableArray = NSMutableArray()
    var tmpIndexPath : IndexPath = IndexPath()
    
    // MARK: -  Dropdown
    var arrDropdownPhone : NSMutableArray = NSMutableArray()
    var arrDropdownEmail : NSMutableArray = NSMutableArray()
    var arrDropdownSocials : NSMutableArray = NSMutableArray()
    var arrDropdownMsg : NSMutableArray = NSMutableArray()
    var dropDownPhone : DropDownListView = DropDownListView()
    var dropDownEmail : DropDownListView = DropDownListView()
    var dropDownSocial : DropDownListView = DropDownListView()
    var dropDownMessages : DropDownListView = DropDownListView()
    
    var contactStore = CNContactStore()
    var contactIdentifireForEdit : String? = ""
   // var cnContectforEdit : CNContact
    
    // MARK: -  Viewlife cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblCreateContact.dataSource = self
        tblCreateContact.delegate = self
        // tblCreateContact.backgroundColor = UIColor.clear
        tblCreateContact.isScrollEnabled = false
        self.setInitialDataToArray()
        txtFname.setLeftPaddingPoints(10)
        txtFname.setBorderColorandWidth()
        txtName.setLeftPaddingPoints(10)
        txtName.setBorderColorandWidth()
        txtCompany.setLeftPaddingPoints(10)
        txtCompany.setBorderColorandWidth()
        txtTitle.setLeftPaddingPoints(10)
        txtTitle.setBorderColorandWidth()
        
        arrDropdownPhone.add("Work")
        arrDropdownPhone.add("Home")
        arrDropdownPhone.add("iPhone")
        arrDropdownPhone.add("mobile")
        
        arrDropdownEmail.add("Home")
        arrDropdownEmail.add("Work")
        
        arrDropdownSocials.add("Facebook")
        arrDropdownSocials.add("Twitter")
        
        arrDropdownMsg.add("WhatsApp")
        arrDropdownMsg.add("Messages")
        arrDropdownMsg.add("Skype")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        DispatchQueue.main.async {
            Global.appDelegate.tabBarCustomObj?.hideTabBar()
        }
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        if(self.contactIdentifireForEdit == "1") {
            //self.loadEditContact()
           // Global.singleton.saveToUserDefaultsWithContactObject(contact: contact, forKey: )
            self.getContactDetails(Global.singleton.retriveFromUserDefaultsWithContactObject(key: Global.kQRAppSettingKeys.MyContactDetail)!)
        }
        
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tblCreateContact.contentSize = CGSize(width: self.view.frame.size.width, height: 800)
        tblCreateContact.frame = CGRect(x: tblCreateContact.frame.origin.x, y: tblCreateContact.frame.origin.y, width: tblCreateContact.contentSize.width, height: tblCreateContact.contentSize.height)
        //scrollObj.frame = tblCreateContact.frame
        scrollObj.contentSize = CGSize(width: self.view.frame.size.width, height: tblCreateContact.contentSize.height + 300)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tblCreateContact.contentSize = CGSize(width: self.view.frame.size.width, height: 800)
        tblCreateContact.frame = CGRect(x: tblCreateContact.frame.origin.x, y: tblCreateContact.frame.origin.y, width: tblCreateContact.contentSize.width, height: tblCreateContact.contentSize.height)
        //scrollObj.frame = tblCreateContact.frame
        scrollObj.contentSize = CGSize(width: self.view.frame.size.width, height: tblCreateContact.contentSize.height + 300)
        
        print("Scrollview contentsize = \(scrollObj.contentSize.height)")
        print("tableview contentsize = \(tblCreateContact.contentSize.height)")
        print("tableview frmae : \(tblCreateContact.contentSize.height)")
        
    }
    
    // MARK: - Array filling methods
    func setInitialDataToArray()  {
        let shrPhone : ContactShare = ContactShare()
        shrPhone.strValue = ""
        shrPhone.strtype = "Phone"
        shrPhone.strLastPlushMinus = "1" //1 for Plus , 0 for Minus
        self.arrPhones.add(shrPhone)
        
        let shrEmail : ContactShare = ContactShare()
        shrEmail.strValue = ""
        shrEmail.strtype = "Email"
        shrEmail.strLastPlushMinus = "1" //1 for Plus , 0 for Minus
        self.arrEmails.add(shrEmail)
        
        let shrSocial : ContactShare = ContactShare()
        shrSocial.strValue = ""
        shrSocial.strtype = "Twitter"
        shrSocial.strLastPlushMinus = "1" //1 for Plus , 0 for Minus
        self.arrSocials.add(shrSocial)
        
        let shrURL : ContactShare = ContactShare()
        shrURL.strValue = ""
        shrURL.strtype = "URL"
        shrURL.strLastPlushMinus = "1" //1 for Plus , 0 for Minus
        self.arrURLs.add(shrURL)
        
        let shrInstantMsg : ContactShare = ContactShare()
        shrInstantMsg.strValue = ""
        shrInstantMsg.strtype = "WhatsApp"
        shrInstantMsg.strLastPlushMinus = "1" //1 for Plus , 0 for Minus
        self.arrInstantMsg.add(shrInstantMsg)
        
        let shrAddress : ContactAddressShare = ContactAddressShare()
        shrAddress.strLine1 = ""
        shrAddress.strLine2 = ""
        shrAddress.strCity = ""
        shrAddress.strState = ""
        shrAddress.strCountry = ""
        self.arrAddress.add(shrAddress)
        
        let shrAboutMe : ContactAboutMeShare = ContactAboutMeShare()
        shrAboutMe.strAboutMe = ""
        self.arrAboutMe.add(shrAboutMe)
    }
    
    func loadEditContact() {
        
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactEmailAddressesKey,
            CNContactPhoneNumbersKey,
            CNContactJobTitleKey,
            CNContactSocialProfilesKey,
            CNContactUrlAddressesKey,
            CNContactNoteKey,
            CNContactFamilyNameKey,
            CNContactNicknameKey,
            CNContactInstantMessageAddressesKey] as [Any]
        
        // Get all the containers
        var allContainers: [CNContainer] = []
        
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }
        
        // Iterate all containers and append their contacts to our results array
       // for container in allContainers {
            print([Global.singleton.retriveFromUserDefaults(key: Global.kQRAppSettingKeys.MyCardcontactId)!])
            let arrTemp : [String] = [Global.singleton.retriveFromUserDefaults(key: Global.kQRAppSettingKeys.MyCardcontactId)!]
            if (arrTemp.count > 0) {
                let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: arrTemp[0] as String)
                
                do {
                    let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                    print(containerResults)
                    //self.getContactDetails(containerResults)
                    //results.append(contentsOf: containerResults)
                } catch {
                    print("Error fetching results for container")
                }
            }
    }
    
    func getContactDetails (_ lastSavedCON2 : Data) {
        /* Get all mobile number */
    
        do {
            let createContact = try CNContactVCardSerialization.contacts(with: lastSavedCON2)
            print(createContact)
            
            
            if (createContact.count > 0) {
                let lastSavedCON : CNContact = createContact[0]
                var strContactData : String = ""
                self.txtFname.text = lastSavedCON.familyName
                self.txtName.text = lastSavedCON.givenName
                self.txtTitle.text = lastSavedCON.jobTitle
                self.txtCompany.text = lastSavedCON.organizationName
                strContactData = "\(lastSavedCON.familyName)  \(lastSavedCON.givenName)"
                arrPhones.removeAllObjects()
                for ContctNumVar: CNLabeledValue in lastSavedCON.phoneNumbers
                {
                    
                    let MobNumVar  = (ContctNumVar.value).value(forKey: "digits") as? String
                    let shrPhone : ContactShare = ContactShare()
                    print(ContctNumVar.label!)
                    shrPhone.strValue = MobNumVar!
                    let strTemp : String = ContctNumVar.label!.replaceAll(find:"_$!<", with: "")
                    
                    shrPhone.strtype = strTemp.replaceAll(find:">!$_", with: "")
                    shrPhone.strLastPlushMinus = "1" //1 for Plus , 0 for Minus
                    self.arrPhones.add(shrPhone)
                    //strContactData = "\(strContactData) \n \((ContctNumVar.value).value(forKey: "digits") as? String ?? ""))"
                    //print(MobNumVar!)
                }
                
                if (arrPhones.count == 0) {
                    let shrPhone : ContactShare = ContactShare()
                    shrPhone.strValue = ""
                    shrPhone.strtype = "Phone"
                    shrPhone.strLastPlushMinus = "1" //1 for Plus , 0 for Minus
                    self.arrPhones.add(shrPhone)
                }
                
                self.arrEmails.removeAllObjects()
                /* Get all mobile number */
                for email in lastSavedCON.emailAddresses{
                    strContactData = "\(strContactData) \n \((email.value as String))"
                    print("\(email.value as String)")
                    let shrPhone : ContactShare = ContactShare()
                    shrPhone.strValue = email.value as String
                    let strTemp : String = email.label!.replaceAll(find:"_$!<", with: "")
                    
                    shrPhone.strtype = strTemp.replaceAll(find:">!$_", with: "")
                    shrPhone.strLastPlushMinus = "1" //1 for Plus , 0 for Minus
                    self.arrEmails.add(shrPhone)
                    
                }
                
                if (arrEmails.count == 0) {
                    let shrPhone : ContactShare = ContactShare()
                    shrPhone.strValue = ""
                    shrPhone.strtype = "Email"
                    shrPhone.strLastPlushMinus = "1" //1 for Plus , 0 for Minus
                    self.arrEmails.add(shrPhone)
                }
                
                self.arrSocials.removeAllObjects()
                for ContctProfile: CNLabeledValue in lastSavedCON.socialProfiles
                {
                    let mobnumvar  = (ContctProfile.value).value(forKey: "username") as? String
                    //let MobNumVar  = (ContctProfile.value).value(forKey: "digits") as? String
                    print(ContctProfile)
                    print(mobnumvar ?? "")
                    let shrSocial : ContactShare = ContactShare()
                    shrSocial.strValue = ContctProfile.value.username
                    let strTemp : String = ContctProfile.value.service.replaceAll(find:"_$!<", with: "")
                    shrSocial.strtype = strTemp.replaceAll(find:">!$_", with: "")
                    shrSocial.strLastPlushMinus = "1" //1 for Plus , 0 for Minus
                    self.arrSocials.add(shrSocial)
                }
                if (self.arrSocials.count == 0) {
                    let shrPhone : ContactShare = ContactShare()
                    shrPhone.strValue = ""
                    shrPhone.strtype = "Facebook"
                    shrPhone.strLastPlushMinus = "1" //1 for Plus , 0 for Minus
                    self.arrSocials.add(shrPhone)
                }
                
                self.arrInstantMsg.removeAllObjects()
                for msg in lastSavedCON.instantMessageAddresses{
                    //                strContactData = "\(strContactData) \n \((email.value as String))"
                    //                print("\(email.value as String)")
                    let shrPhone : ContactShare = ContactShare()
                    print(msg.label!)
                    
                    shrPhone.strValue = msg.value.username
                    let strTemp : String = msg.label!.replaceAll(find:"_$!<", with: "")
                    shrPhone.strtype = strTemp.replaceAll(find:">!$_", with: "")
                    shrPhone.strLastPlushMinus = "1" //1 for Plus , 0 for Minus
                    
                    self.arrInstantMsg.add(shrPhone)
                    
                }
                if (self.arrInstantMsg.count == 0) {
                    let shrPhone : ContactShare = ContactShare()
                    shrPhone.strValue = ""
                    shrPhone.strtype = "WhatsApp"
                    shrPhone.strLastPlushMinus = "1" //1 for Plus , 0 for Minus
                    self.arrInstantMsg.add(shrPhone)
                }
                self.arrURLs.removeAllObjects()
                for msg in lastSavedCON.urlAddresses{
                    let shrPhone : ContactShare = ContactShare()
                    shrPhone.strValue = msg.value as String
                    let strTemp : String = msg.label!.replaceAll(find:"_$!<", with: "")
                    shrPhone.strtype = strTemp.replaceAll(find:">!$_", with: "")
                    shrPhone.strLastPlushMinus = "1" //1 for Plus , 0 for Minus
                    self.arrURLs.add(shrPhone)
                }
                if (self.arrURLs.count == 0) {
                    let shrPhone : ContactShare = ContactShare()
                    shrPhone.strValue = ""
                    shrPhone.strtype = "URL"
                    shrPhone.strLastPlushMinus = "1" //1 for Plus , 0 for Minus
                    self.arrURLs.add(shrPhone)
                }
                
                let shrAboutMe : ContactAboutMeShare = ContactAboutMeShare()
                shrAboutMe.strAboutMe = lastSavedCON.note
                self.arrAboutMe.removeAllObjects()
                self.arrAboutMe.add(shrAboutMe)
                
                
                            let address = lastSavedCON.postalAddresses.count > 0 ? "\(lastSavedCON.postalAddresses[0].value.street)" : ""
                            let address2 = lastSavedCON.postalAddresses.count > 0 ? "\(lastSavedCON.postalAddresses[0].value.subLocality)" : ""
                            let city = lastSavedCON.postalAddresses.count > 0 ? "\(lastSavedCON.postalAddresses[0].value.city)" : ""
                            let state = lastSavedCON.postalAddresses.count > 0 ? "\(lastSavedCON.postalAddresses[0].value.state)" : ""
                            let country = lastSavedCON.postalAddresses.count > 0 ? "\(lastSavedCON.postalAddresses[0].value.country)" : ""
                
                            let shrAddress : ContactAddressShare = ContactAddressShare()
                            shrAddress.strLine1 = address
                            shrAddress.strLine2 = address2
                            shrAddress.strCity = city
                            shrAddress.strState = state
                            shrAddress.strCountry = country
                            self.arrAddress.removeAllObjects()
                            self.arrAddress.add(shrAddress)
                
                //            strContactData = "\(strContactData) \n \(address) \n \((city))"
                //            strContactData =  "\(strContactData) \n \(lastSavedCON.note)"
                self.tblCreateContact.reloadData()
            }
            
            
            
        } catch {
            print("Error \(error)")
        }
        
        //self.txtviewCard.text = strContactData
    }
    // MARK: -  Button Click Events
    
    @IBAction func btnCancelClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func validateUrl (stringURL : String) -> Bool {
        
        let urlRegEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[urlRegEx])
        var urlTest = NSPredicate.withSubstitutionVariables(predicate)
        
        return predicate.evaluate(with: stringURL)
    }
    
    func isValidCountryInput(Input:String) -> Bool {
        let myCharSet=CharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        let output: String = Input.trimmingCharacters(in: myCharSet.inverted)
        let isValid: Bool = (Input == output)
        print("\(isValid)")
        return isValid
    }
    
    @IBAction func btnSaveClick(_ sender: Any) {
        //Create
        if txtFname.text == "" {
            Global.singleton.showWarningAlert(withMsg: "Please Enter First name")
            return
        }
        else if txtName.text == "" {
            Global.singleton.showWarningAlert(withMsg: "Please Enter Last name")
            return
        }
        else if (txtCompany.text == "") {
            Global.singleton.showWarningAlert(withMsg: "Please Enter Company name")
            return
        }
        else if (txtTitle.text == "") {
            Global.singleton.showWarningAlert(withMsg: "Please Enter Position")
            return
        }
        
        var stop : Int  = 0
        for i in (0..<arrEmails.count){
            let indexpath : IndexPath = IndexPath(row: i, section: 1)
            let cell : EmailCell? = self.tblCreateContact.cellForRow(at: indexpath) as! EmailCell?
            if (cell?.txtEmail.text != "") {
                if !Global.singleton.validateEmail(strEmail: (cell?.txtEmail.text!)!){
                    Global.singleton.showWarningAlert(withMsg: "Please Enter proper email")
                    stop = 1
                    break
                }
            }
        }
        
        if stop == 1 {
            return
        }
        
        var stopUrl : Int = 0
        
        for i in (0..<arrURLs.count){
            let indexpath : IndexPath = IndexPath(row: i, section: 2)
            let cell : URLCell? = self.tblCreateContact.cellForRow(at: indexpath) as! URLCell?
            if (cell?.txtURL.text != "") {
                
                if(self.validateUrl(stringURL: (cell?.txtURL.text)!)){
                     print("candidate is a well-formed url with")
                }
                else {
                    stopUrl = 1
                    Global.singleton.showWarningAlert(withMsg: "Please Enter proper URL")
                    break
                }
            }
           
        }
        if stopUrl == 1 {
            return
        }
        
        var stopCountry : Int = 0
        for i in (0..<arrAddress.count){
            let indexpath : IndexPath = IndexPath(row: i, section: 5)
            let cell : AddressCell? = self.tblCreateContact.cellForRow(at: indexpath) as! AddressCell?
            if cell?.txtCountry.text != "" {
                if (self.isValidCountryInput(Input: (cell?.txtCountry.text!)!)){
                    
                }
                else {
                    stopCountry = 1
                    Global.singleton.showWarningAlert(withMsg: "Please Enter proper Country Name")
                    break
                }
            }
        }
        if stopCountry == 1 {
            return
        }
        
        let contact : CNMutableContact = CNMutableContact()
        
        contact.givenName = txtName.text!
        contact.familyName = txtFname.text!
        contact.jobTitle = txtTitle.text!
        contact.organizationName = txtCompany.text!
        contact.emailAddresses = []
        contact.phoneNumbers = []
        
        for i in (0..<arrPhones.count){
            let indexpath : IndexPath = IndexPath(row: i, section: 0)
            let cell : PhoneCell? = self.tblCreateContact.cellForRow(at: indexpath) as! PhoneCell?
            
            let shrO : ContactShare = arrPhones.object(at: i) as! ContactShare
            if (cell?.txtPhone.text) != "" {
                shrO.strValue = (cell?.txtPhone.text)!
                shrO.strtype = (cell?.btnType.titleLabel?.text)!
                if (i == 0) {
                    contact.phoneNumbers.append(CNLabeledValue(
                        label:CNLabelPhoneNumberMain,
                        value:CNPhoneNumber(stringValue:(cell?.txtPhone.text)!)))
                }
                else if (i==1) {
                    contact.phoneNumbers.append(CNLabeledValue(
                        label:CNLabelPhoneNumberMobile,
                        value:CNPhoneNumber(stringValue:(cell?.txtPhone.text)!)))
                }
                else {
                    contact.phoneNumbers.append(CNLabeledValue(
                        label:CNLabelPhoneNumberiPhone,
                        value:CNPhoneNumber(stringValue:(cell?.txtPhone.text)!)))
                }
            }
        }
        
        for i in (0..<arrEmails.count){
            let indexpath : IndexPath = IndexPath(row: i, section: 1)
            let cell : EmailCell? = self.tblCreateContact.cellForRow(at: indexpath) as! EmailCell?
            if cell?.txtEmail.text != "" {
                if !Global.singleton.validateEmail(strEmail: (cell?.txtEmail.text!)!){
                    Global.singleton.showSuccessAlert(withMsg: "Please Enter proper email")
                    break
                }
            }
            
            let shrO : ContactShare = arrEmails.object(at: i) as! ContactShare
            if (cell?.txtEmail.text) != nil {
                shrO.strValue = (cell?.txtEmail.text)!
                shrO.strtype = (cell?.btnType.titleLabel?.text)!
                
                if shrO.strtype == "Work" {
                    let workEmail1 = CNLabeledValue(label:"WorkEmail", value:(cell?.txtEmail.text ?? "") as NSString)
                    contact.emailAddresses.append(workEmail1)
                }
                else{
                    let workEmail1 = CNLabeledValue(label:"Home", value:(cell?.txtEmail.text ?? "") as NSString)
                    contact.emailAddresses.append(workEmail1)
                }
            }
        }
        
        for i in (0..<arrURLs.count){
            let indexpath : IndexPath = IndexPath(row: i, section: 2)
            let cell : URLCell? = self.tblCreateContact.cellForRow(at: indexpath) as! URLCell?
            
            let shrO : ContactShare = arrURLs.object(at: i) as! ContactShare
            if (cell?.txtURL.text) != nil {
                shrO.strValue = (cell?.txtURL.text)!
                shrO.strtype = (cell?.btnType.titleLabel?.text)!
                let workURL = CNLabeledValue(label:"URL", value:(cell?.txtURL.text ?? "") as NSString)
                contact.urlAddresses.append(workURL)
            }
        }
        
        for i in (0..<arrSocials.count){
            let indexpath : IndexPath = IndexPath(row: i, section: 3)
            let cell : SocialCell? = self.tblCreateContact.cellForRow(at: indexpath) as! SocialCell?
            let shrO : ContactShare = arrSocials.object(at: i) as! ContactShare
            
            if (cell?.txtSocial.text) != nil {
                shrO.strValue = (cell?.txtSocial.text)!
                shrO.strtype = (cell?.btnType.titleLabel?.text)!
                
                if (shrO.strtype == "Facebook") {
                    let facebookProfile = CNLabeledValue(label: "Facebook", value: CNSocialProfile(urlString: shrO.strValue, username: "", userIdentifier: "", service: CNSocialProfileServiceFacebook))
                    contact.socialProfiles.append(facebookProfile)
                }
                else {
                    let twitterProfile = CNLabeledValue(label: "Twitter", value: CNSocialProfile(urlString: shrO.strValue, username: "", userIdentifier: "", service: CNSocialProfileServiceTwitter))
                    contact.socialProfiles.append(twitterProfile)
                }
            }
        }
        
        for i in (0..<arrInstantMsg.count){
            let indexpath : IndexPath = IndexPath(row: i, section: 4)
            let cell : InstantMsgCell? = self.tblCreateContact.cellForRow(at: indexpath) as! InstantMsgCell?
            
            let shrO : ContactShare = arrInstantMsg.object(at: i) as! ContactShare
            //https://www.appsfoundation.com/post/create-edit-contacts-with-ios-9-contacts-ui-framework
            if (cell?.txtMessage.text) != nil {
                shrO.strValue = (cell?.txtMessage.text)!
                shrO.strtype = (cell?.btnType.titleLabel?.text)!
                
                if (shrO.strtype == "Skype") {
                    let skypeProfile = CNLabeledValue(label: "Skype", value: CNInstantMessageAddress(username: shrO.strValue, service: CNInstantMessageServiceSkype))
                    contact.instantMessageAddresses.append(skypeProfile)
                }
                else if (shrO.strtype == "WhatsApp") {
                    let skypeProfile = CNLabeledValue(label: "WhatsApp", value: CNInstantMessageAddress(username: shrO.strValue, service: CNInstantMessageServiceFacebook))
                    contact.instantMessageAddresses.append(skypeProfile)
                }
                else  {
                    let skypeProfile = CNLabeledValue(label: "Messages", value: CNInstantMessageAddress(username: shrO.strValue, service: CNInstantMessageServiceMSN))
                    contact.instantMessageAddresses.append(skypeProfile)
                }
            }
        }
        
        for i in (0..<arrAddress.count){
            let indexpath : IndexPath = IndexPath(row: i, section: 5)
            let cell : AddressCell? = self.tblCreateContact.cellForRow(at: indexpath) as! AddressCell?
            
            let shrO : ContactAddressShare = arrAddress.object(at: i) as! ContactAddressShare
            shrO.strLine1 = (cell?.txtAddressLine1.text)!
            shrO.strLine2 = (cell?.txtAddressLine2.text)!
            shrO.strCity = (cell?.txtCity.text)!
            shrO.strState = (cell?.txtState.text)!
            shrO.strCountry = (cell?.txtCountry.text)!
            
            let homeAddress = CNMutablePostalAddress()
            homeAddress.street = "\(shrO.strLine1)"
            homeAddress.subLocality = "\(shrO.strLine2)"
            homeAddress.city = shrO.strCity
            homeAddress.state = shrO.strState
            homeAddress.postalCode = ""
            homeAddress.country = shrO.strCountry
            contact.postalAddresses = [CNLabeledValue(label:CNLabelHome, value:homeAddress)]
            
        }
        for i in (0..<arrAboutMe.count){
            if i == 0 {
                let indexpath : IndexPath = IndexPath(row: i, section: 6)
                let cell : AboutMeCell? = self.tblCreateContact.cellForRow(at: indexpath) as! AboutMeCell?
                
                let shrO : ContactAboutMeShare = arrAboutMe.object(at: i) as! ContactAboutMeShare
                if (cell?.txtAboutMe.text != "") {
                    shrO.strAboutMe = (cell?.txtAboutMe.text)!
                    contact.note = (cell?.txtAboutMe.text)!
                }
                else{
                    shrO.strAboutMe = ""
                    contact.note = ""
                }
            }
            
        }
        
        var vcard: String? = "BEGIN:VCARD\r\nVERSION:3.1"
        let strName : String = "N:\(txtName.text ?? "")\n"
        let strFullName : String = "FN:\(txtFname.text  ?? "")\n"
        let strOrgName : String = "ORG:\(txtTitle.text  ?? "")\n"
        let strposition : String = "TITLE:\(txtCompany.text ?? "")\n"
        vcard = "\(vcard ?? "")\(strName)\(strFullName)\(strOrgName)\(strposition)"
        
        for shrObjPhone in arrPhones {
            let shrO : ContactShare = shrObjPhone as! ContactShare
            vcard = "\(vcard ?? "")\n TEL;\(shrO.strtype):\(shrO.strValue)\n"
        }
        for shrObjEmail in arrEmails {
            let shrO : ContactShare = shrObjEmail as! ContactShare
            vcard = "\(vcard ?? "")\n EMAIL;\(shrO.strtype):\(shrO.strValue)\n"
        }
        
        for shrObjEmail in arrURLs {
            let shrO : ContactShare = shrObjEmail as! ContactShare
            vcard = "\(vcard ?? "")\n URL;\(shrO.strtype):\(shrO.strValue)\n"
        }
        for shrObjEmail in arrSocials {
            let shrO : ContactShare = shrObjEmail as! ContactShare
            vcard = "\(vcard ?? "")\n LABEL;TYPE=\(shrO.strtype):\(shrO.strValue)\n"
        }
        for shrObjEmail in arrInstantMsg {
            let shrO : ContactShare = shrObjEmail as! ContactShare
            vcard = "\(vcard ?? "")\n LABEL;TYPE=\(shrO.strtype):\(shrO.strValue)\n"
        }
        
        for shrObjadd in arrAddress {
            let shrO : ContactAddressShare = shrObjadd as! ContactAddressShare
            vcard = "\(vcard ?? "")\n ADR;WORK;POSTAL=\(shrO.strLine1);\(shrO.strLine2);\(shrO.strCity);\(shrO.strState);\(shrO.strCountry)\n"
        }
        for shrObjabout in arrAboutMe {
            let shrO : ContactAboutMeShare = shrObjabout as! ContactAboutMeShare
            vcard = "\(vcard ?? "")\n NOTE=\(shrO.strAboutMe)\n"
        }
        vcard = "\(vcard ?? "")END:VCARD"
        print("vcard data=\(vcard ?? "")")
        
        do {
            let saveRequest = CNSaveRequest()
            saveRequest.add(contact, toContainerWithIdentifier: contactStore.defaultContainerIdentifier())
            try contactStore.execute(saveRequest)
            // Global.singleton.setContactStoreId(contactStore.defaultContainerIdentifier())
            Global.singleton.saveToUserDefaults(value: contactStore.defaultContainerIdentifier(), forKey: "MyCardContactId")
            
           
            let vcardFromContacts =  try? CNContactVCardSerialization.data(with: [contact]) as NSData
            var vCardData: Data? = try? CNContactVCardSerialization.data(with: ([contact]))
            let vCardNote: String? = contact.note
                if vCardNote == ""  {
                    
                }
                else {
                    vCardData = CNContactVCardSerialization.vcardDataAppendingNote(vcard: vcardFromContacts! as Data, noteasString:vCardNote!)
                    
                }
           
            Global.singleton.saveToUserDefaultsWithContactObject(contact: vCardData!, forKey: Global.kQRAppSettingKeys.MyContactDetail)
        }
        catch {
            print("\(error.localizedDescription)")
            Global.singleton.showWarningAlert(withMsg:"Unable to save the new contact." )
            return
        }
        
        do {
            let vcardFromContacts = try CNContactVCardSerialization.data(with: [contact]) as NSData
            
            //var error: Error? = nil
            var vCardData: Data? = try? CNContactVCardSerialization.data(with: ([contact]))
            let vCardNote: String? = contact.note
            if vCardNote == ""  {
                
            }
            else {
                vCardData = CNContactVCardSerialization.vcardDataAppendingNote(vcard:vcardFromContacts as Data, noteasString:vCardNote!)
            }
            
            let lastSavedContact = String(data: vCardData ?? Data(), encoding: .utf8)!
            print("added contact = \(String(describing: lastSavedContact))")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController1 : CreateVCardVC = storyboard.instantiateViewController(withIdentifier :"CreateVCardVC") as! CreateVCardVC
            viewController1.lastSavedContact = lastSavedContact
            viewController1.lastSavedCON = contact
            
            Global.singleton.saveToUserDefaults(value: lastSavedContact, forKey: Global.myBusinessCard)
            Global.singleton.saveToUserDefaults(value: "1", forKey: Global.IsCreatedBusinessCard)
            
            self.navigationController?.pushViewController(viewController1 , animated: true)
            
        } catch {
            Global.singleton.showWarningAlert(withMsg:"Error \(error.localizedDescription)" )
        }
        
        /*
         ADR;TYPE=WORK,PREF:;;100 Waters Edge;Baytown;LA;30314;United States of America
         
         BEGIN:VCARD
         VERSION:2.1
         N:;Company Name
         FN:Company Name
         ORG:Company Name
         TEL;WORK;VOICE;PREF:+16045551212
         TEL;WORK;FAX:+16045551213
         TEL;type=WORK;type=pref:+1 617 555 1212
         TEL;type=CELL:+1 781 555 1212
         TEL;type=HOME:+1 202 555 1212
         TEL;type=WORK:+1 (617) 555-1234
         
         ADR;WORK;POSTAL;PARCEL;DOM;PREF:;;123 main street;vancouver;bc;v0v0v0;canada
         
         EMAIL;INTERNET;PREF:user@example.com
         EMAIL;BUSINESS;PREF:user@example.com
         
         URL;WORK;PREF:http://www.example.com/
         NOTE:http://www.example.com/
         CATEGORIES:BUSINESS,WORK
         UID:A64440FC-6545-11E0-B7A1-3214E0D72085
         REV:20110412165200
         END:VCARD
         
         */
        //self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnProfileClick(_ sender: Any) {
        self.chooseImage()
    }
    
    @objc func chooseImage() {
        if let tryPicker = imagePicker {
            self.present(tryPicker, animated: true, completion: nil)
        } else {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = false
            imagePicker = picker
            
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func createContact() -> CNContact {
        
        // Creating a mutable object to add to the contact
        let contact = CNMutableContact()
        
        contact.imageData = NSData() as Data // The profile picture as a NSData object
        
        contact.givenName = "John"
        contact.familyName = "Appleseed"
        
        
        contact.emailAddresses = [
            CNLabeledValue(label: CNLabelWork, value: "john.doe@email.com"),
            CNLabeledValue(label: CNLabelHome, value: "john.doe@email.com")
        ]
        
        contact.phoneNumbers = [CNLabeledValue(
            label:CNLabelPhoneNumberiPhone,
            value:CNPhoneNumber(stringValue:"(408) 555-0126"))]
        
        return contact
    }
}

extension CreateContactVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let lblHeader : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 320, height: 30))
        if section == 0 {
            lblHeader.text = "    Phone"
        }
        else if (section == 1){
            lblHeader.text = "    Email"
        }
        else if (section == 2){
            lblHeader.text = "    Company WebSite"
        }
        else if (section == 3){
            lblHeader.text = "    Socials"
        }
        else if (section == 4){
            lblHeader.text = "    Instant Messages"
        }
        else if (section == 5){
            lblHeader.text = "    Address"
        }
        else if (section == 6) {
            lblHeader.text = "    About Me & Other Note"
        }
        else{
            lblHeader.text = ""
            
        }
        lblHeader.font = UIFont(name: Global.kFont.SourceRegular, size: 18)
        
        return lblHeader
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrPhones.count
        }
        else if (section == 1){
            return arrEmails.count
        }
        else if (section == 2){
            return arrURLs.count
        }
        else if (section == 3){
            return arrSocials.count
        }
        else if (section == 4){
            return arrInstantMsg.count
        }
        else if (section == 5){
            return arrAddress.count
        }
        else if (section == 6) {
            return arrAboutMe.count
        }
        else{
            print("The section \(section)")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell : PhoneCell = tableView.dequeueReusableCell(withIdentifier: "PhoneCell") as! PhoneCell
            let shrObj: ContactShare = arrPhones.object(at: indexPath.row) as! ContactShare
            if shrObj.strLastPlushMinus == "0" {
                cell.btnPlushMinus.removeTarget(self, action: #selector(CreatePhoneCell), for:.touchUpInside)
                cell.btnPlushMinus.addTarget(self, action: #selector(DeletePhoneCell), for: .touchUpInside)
                cell.btnPlushMinus.setTitle("-", for: .normal)
            }
            else {
                cell.btnPlushMinus.removeTarget(self, action: #selector(DeletePhoneCell), for:.touchUpInside)
                cell.btnPlushMinus.addTarget(self, action: #selector(CreatePhoneCell), for: .touchUpInside)
                cell.btnPlushMinus.setTitle("+", for: .normal)
            }
            
            cell.btnPlushMinus.tag = indexPath.row
            cell.txtPhone.setLeftPaddingPoints(10)
            cell.txtPhone.setBorderColorandWidth()
            cell.selectionStyle = .none
//            if (indexPath.row == arrPhones.count - 1) {
//                cell.btnType.setTitle(shrObj.strtype, for: UIControlState.normal)
//                cell.txtPhone.text = ""
//            }
//            else {
                cell.btnType.setTitle(shrObj.strtype, for: UIControlState.normal)
                cell.txtPhone.text = shrObj.strValue
       //     }
            cell.btnType.addTarget(self, action: #selector(section0PhoneTypeClick), for: .touchUpInside)
            cell.btnType.tag = indexPath.row
            cell.txtPhone.delegate = self
            return cell
        }
        else if (indexPath.section == 1){
            let cell : EmailCell = tableView.dequeueReusableCell(withIdentifier: "EmailCell") as! EmailCell
            cell.selectionStyle = .none
            let shrObj: ContactShare = arrEmails.object(at: indexPath.row) as! ContactShare
            cell.txtEmail.setLeftPaddingPoints(10)
            cell.txtEmail.setBorderColorandWidth()
            
            if shrObj.strLastPlushMinus == "0" {
                cell.btnPlushMinus.removeTarget(self, action: #selector(CreateEmailCell), for:.touchUpInside)
                cell.btnPlushMinus.addTarget(self, action: #selector(DeleteEmailCell), for: .touchUpInside)
                cell.btnPlushMinus.setTitle("-", for: .normal)
            }
            else {
                cell.btnPlushMinus.removeTarget(self, action: #selector(DeleteEmailCell), for:.touchUpInside)
                cell.btnPlushMinus.addTarget(self, action: #selector(CreateEmailCell), for: .touchUpInside)
                cell.btnPlushMinus.setTitle("+", for: .normal)
            }
            
            cell.btnPlushMinus.tag = indexPath.row
            
//            if (indexPath.row == arrEmails.count - 1) {
//                cell.btnType.setTitle(shrObj.strtype, for: UIControlState.normal)
//                cell.txtEmail.text = ""
//            }
//            else {
                cell.btnType.setTitle(shrObj.strtype, for: UIControlState.normal)
                cell.txtEmail.text = shrObj.strValue
           // }
            cell.btnType.addTarget(self, action: #selector(section1EmailTypeClick), for: .touchUpInside)
            cell.btnType.tag = indexPath.row
            cell.txtEmail.delegate = self
            return cell
        }
        else if (indexPath.section == 2){
            let cell : URLCell = tableView.dequeueReusableCell(withIdentifier: "URLCell") as! URLCell
            cell.selectionStyle = .none
            let shrObj: ContactShare = arrURLs.object(at: indexPath.row) as! ContactShare
            cell.btnPlushMinus.addTarget(self, action: #selector(CreateURLCell), for: .touchUpInside)
            cell.txtURL.setLeftPaddingPoints(10)
            cell.txtURL.setBorderColorandWidth()
            if shrObj.strLastPlushMinus == "0" {
                cell.btnPlushMinus.removeTarget(self, action: #selector(CreateURLCell), for:.touchUpInside)
                cell.btnPlushMinus.addTarget(self, action: #selector(DeleteURLCell), for: .touchUpInside)
                cell.btnPlushMinus.setTitle("-", for: .normal)
            }
            else {
                cell.btnPlushMinus.removeTarget(self, action: #selector(DeleteURLCell), for:.touchUpInside)
                cell.btnPlushMinus.addTarget(self, action: #selector(CreateURLCell), for: .touchUpInside)
                cell.btnPlushMinus.setTitle("+", for: .normal)
            }
            
            cell.btnPlushMinus.tag = indexPath.row
            cell.btnPlushMinus.isHidden = true
//            if (indexPath.row == arrURLs.count - 1) {
//                cell.btnType.setTitle(shrObj.strtype, for: UIControlState.normal)
//                cell.txtURL.text = ""
//            }
//            else {
                cell.btnType.setTitle(shrObj.strtype, for: UIControlState.normal)
                cell.txtURL.text = shrObj.strValue
//            }
            cell.btnType.addTarget(self, action: #selector(section2URLTypeClick), for: .touchUpInside)
            cell.btnType.tag = indexPath.row
            cell.txtURL.delegate = self
            return cell
        }
        else if (indexPath.section == 3){
            let cell : SocialCell = tableView.dequeueReusableCell(withIdentifier: "SocialCell") as! SocialCell
            cell.selectionStyle = .none
            let shrObj: ContactShare = arrSocials.object(at: indexPath.row) as! ContactShare
            cell.btnPlushMinus.addTarget(self, action: #selector(CreateSocialCell), for: .touchUpInside)
            cell.txtSocial.setLeftPaddingPoints(10)
            cell.txtSocial.setBorderColorandWidth()
            
            if shrObj.strLastPlushMinus == "0" {
                cell.btnPlushMinus.removeTarget(self, action: #selector(CreateSocialCell), for:.touchUpInside)
                cell.btnPlushMinus.addTarget(self, action: #selector(DeleteSocialCell), for: .touchUpInside)
                cell.btnPlushMinus.setTitle("-", for: .normal)
            }
            else {
                cell.btnPlushMinus.removeTarget(self, action: #selector(DeleteSocialCell), for:.touchUpInside)
                cell.btnPlushMinus.addTarget(self, action: #selector(CreateSocialCell), for: .touchUpInside)
                cell.btnPlushMinus.setTitle("+", for: .normal)
            }
            
            cell.btnPlushMinus.tag = indexPath.row
            
//            if (indexPath.row == arrSocials.count - 1) {
//                cell.btnType.setTitle(shrObj.strtype, for: UIControlState.normal)
//                cell.txtSocial.text = ""
//            }
//            else {
                cell.btnType.setTitle(shrObj.strtype, for: UIControlState.normal)
                cell.txtSocial.text = shrObj.strValue
//            }
            cell.btnType.addTarget(self, action: #selector(section3SocialTypeClick), for: .touchUpInside)
            cell.btnType.tag = indexPath.row
            cell.txtSocial.delegate = self
            return cell
        }
        else if (indexPath.section == 4){
            let cell : InstantMsgCell = tableView.dequeueReusableCell(withIdentifier: "InstantMsgCell") as! InstantMsgCell
            cell.selectionStyle = .none
            let shrObj: ContactShare = arrInstantMsg.object(at: indexPath.row) as! ContactShare
            cell.txtMessage.setLeftPaddingPoints(10)
            cell.txtMessage.setBorderColorandWidth()
            
            if shrObj.strLastPlushMinus == "0" {
                cell.btnPlushMinus.removeTarget(self, action: #selector(CreateInstantMsgCell), for:.touchUpInside)
                cell.btnPlushMinus.addTarget(self, action: #selector(DeleteInstantMsgCell), for: .touchUpInside)
                cell.btnPlushMinus.setTitle("-", for: .normal)
            }
            else {
                cell.btnPlushMinus.removeTarget(self, action: #selector(DeleteInstantMsgCell), for:.touchUpInside)
                cell.btnPlushMinus.addTarget(self, action: #selector(CreateInstantMsgCell), for: .touchUpInside)
                cell.btnPlushMinus.setTitle("+", for: .normal)
            }
            
//            if (indexPath.row == arrInstantMsg.count - 1) {
//                cell.btnType.setTitle(shrObj.strtype, for: UIControlState.normal)
//                cell.txtMessage.text = ""
//            }
//            else {
                cell.btnType.setTitle(shrObj.strtype, for: UIControlState.normal)
                cell.txtMessage.text = shrObj.strValue
           // }
            cell.btnType.addTarget(self, action: #selector(section4MsgTypeTypeClick), for: .touchUpInside)
            cell.btnType.tag = indexPath.row
            cell.txtMessage.delegate = self
            return cell
        }
        else if (indexPath.section == 5){
            
            let cell : AddressCell = tableView.dequeueReusableCell(withIdentifier: "AddressCell") as! AddressCell
            cell.selectionStyle = .none
            if indexPath.row == 0 {
                let shrObj: ContactAddressShare = arrAddress.object(at: indexPath.row) as! ContactAddressShare
                cell.txtAddressLine1.setLeftPaddingPoints(10)
                cell.txtAddressLine1.setBorderColorandWidth()
                cell.txtAddressLine2.setLeftPaddingPoints(10)
                cell.txtAddressLine2.setBorderColorandWidth()
                cell.txtCity.setLeftPaddingPoints(10)
                cell.txtCity.setBorderColorandWidth()
                cell.txtState.setLeftPaddingPoints(10)
                cell.txtState.setBorderColorandWidth()
                cell.txtCountry.setLeftPaddingPoints(10)
                cell.txtCountry.setBorderColorandWidth()
                
                
                cell.txtAddressLine1.text = shrObj.strLine1
                cell.txtAddressLine2.text = shrObj.strLine2
                cell.txtCity.text = shrObj.strCity
                cell.txtState.text = shrObj.strState
                cell.txtCountry.text = shrObj.strCountry
            }
            
          
            cell.txtAddressLine1.delegate = self
            cell.txtAddressLine2.delegate = self
            cell.txtCity.delegate = self
            cell.txtState.delegate = self
            cell.txtCountry.delegate = self
            
            return cell
        }
        else {
            let cell : AboutMeCell = tableView.dequeueReusableCell(withIdentifier: "AboutMeCell") as! AboutMeCell
            cell.selectionStyle = .none
            let shrObj: ContactAboutMeShare = arrAboutMe.object(at: indexPath.row) as! ContactAboutMeShare
            cell.txtAboutMe.text = shrObj.strAboutMe
            // cell.btnType.setTitle(shrObj.strValue, for: UIControlState.normal)
            // cell.btnPlushMinus.addTarget(self, action: #selector(CreateEmailCell), for: .touchUpInside)
            return cell
        }
    }
    
    // MARK: -  Button Type Click
    @objc func section0PhoneTypeClick(_ sender : UIButton) {
        let frame = sender.superview?.convert(sender.frame, to: self.view)
        dropDownPhone = DropDownListView(title: "Select Type", options: arrDropdownPhone as! [Any], xy: CGPoint(x: (frame?.origin.x)! + 25, y: (frame?.origin.y)! + 25), size: CGSize(width: 285, height: 330), isMultiple: false)
        
        dropDownPhone.delegate = self
        dropDownPhone.backgroundColor = UIColor.darkGray
        dropDownPhone.show(in: self.view, animated: true)
        
        let section = 0
        let row = sender.tag
        tmpIndexPath = IndexPath(row: row, section: section)
        
    }
    
    @objc func section1EmailTypeClick(_ sender : UIButton) {
        let frame = sender.superview?.convert(sender.frame, to: self.view)
        dropDownEmail = DropDownListView(title: "Select Type", options: arrDropdownEmail as! [Any], xy: CGPoint(x: (frame?.origin.x)! + 25, y: (frame?.origin.y)! + 25), size: CGSize(width: 200, height: 250), isMultiple: false)
        
        dropDownEmail.delegate = self
        dropDownEmail.backgroundColor = UIColor.darkGray
        dropDownEmail.show(in: self.view, animated: true)
        
        let section = 1
        let row = sender.tag
        tmpIndexPath = IndexPath(row: row, section: section)
    }
    
    @objc func section2URLTypeClick(_ sender : UIButton) {
        
    }
    
    @objc func section3SocialTypeClick(_ sender : UIButton) {
        let frame = sender.superview?.convert(sender.frame, to: self.view)
        dropDownSocial = DropDownListView(title: "Select Type", options: arrDropdownSocials as! [Any], xy: CGPoint(x: (frame?.origin.x)! + 25, y: (frame?.origin.y)! + 25), size: CGSize(width: 200, height: 250), isMultiple: false)
        
        dropDownSocial.delegate = self
        dropDownSocial.backgroundColor = UIColor.darkGray
        dropDownSocial.show(in: self.view, animated: true)
        let section = 3
        let row = sender.tag
        tmpIndexPath = IndexPath(row: row, section: section)
    }
    @objc func section4MsgTypeTypeClick(_ sender : UIButton) {
        let frame = sender.superview?.convert(sender.frame, to: self.view)
        dropDownMessages = DropDownListView(title: "Select Type", options: arrDropdownMsg as! [Any], xy: CGPoint(x: (frame?.origin.x)! + 25, y: (frame?.origin.y)! + 25), size: CGSize(width: 200, height: 250), isMultiple: false)
        
        dropDownMessages.delegate = self
        dropDownMessages.backgroundColor = UIColor.darkGray
        dropDownMessages.show(in: self.view, animated: true)
        
        let section = 4
        let row = sender.tag
        tmpIndexPath = IndexPath(row: row, section: section)
    }
    
    // MARK: -  Button Delete Add Row Click
    
    @objc func CreatePhoneCell(_ sender : UIButton) {
        let indexpath : IndexPath = IndexPath(row: sender.tag, section: 0)
        let cell : PhoneCell? = self.tblCreateContact.cellForRow(at: indexpath) as! PhoneCell?
        
        let shrO : ContactShare = arrPhones.object(at: sender.tag) as! ContactShare
        if (cell?.txtPhone.text) != "" {
            if !Global.singleton.validatePhoneNumber(strPhone: (cell?.txtPhone.text)!) {
                AJNotificationView.showNotice(in: self.view, type: AJNotificationTypeRed, title: "Please Enter valid phone number", hideAfter: 1.0)
                return
            }
            shrO.strValue = (cell?.txtPhone.text)!
        }
        else {
            AJNotificationView.showNotice(in: self.view, type: AJNotificationTypeRed, title: "Please Enter phone", hideAfter: 1.0)
            return
        }
        
        for contact in arrPhones {
            let tempC : ContactShare = contact as! ContactShare
            tempC.strLastPlushMinus = "0"
        }
        let shrPhone : ContactShare = ContactShare()
        shrPhone.strValue = ""
        shrPhone.strtype = "Phone"
        shrPhone.strLastPlushMinus = "1" //1 for Plus , 0 for Minus
        self.arrPhones.add(shrPhone)
        self.tblCreateContact.reloadSections(NSIndexSet(index: 0) as IndexSet, with: UITableViewRowAnimation.automatic)
    }
    
    @objc func DeletePhoneCell(_ sender : UIButton) {
        
        arrPhones.removeObject(at: sender.tag)
        self.tblCreateContact.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
        self.updateFrameOfTableviewandScrollview()
        
    }
    
    @objc func CreateEmailCell(_ sender: UIButton) {
        
        let indexpath : IndexPath = IndexPath(row: sender.tag, section: 1)
        let cell : EmailCell? = self.tblCreateContact.cellForRow(at: indexpath) as! EmailCell?
        
        let shrO : ContactShare = arrEmails.object(at: sender.tag) as! ContactShare
        if (cell?.txtEmail.text) != "" {
            if !Global.singleton.validateEmail(strEmail: (cell?.txtEmail.text!)!){
                Global.singleton.showWarningAlert(withMsg: "Please Enter proper email")
                return
            }
            shrO.strValue = (cell?.txtEmail.text)!
        }
        else {
            Global.singleton.showWarningAlert(withMsg: "Please Enter email")
            return
        }
        
        for contact in arrEmails {
            let tempC : ContactShare = contact as! ContactShare
            tempC.strLastPlushMinus = "0"
        }
        let shrPhone : ContactShare = ContactShare()
        shrPhone.strValue = ""
        shrPhone.strtype = "Email"
        shrPhone.strLastPlushMinus = "1" //1 for Plus , 0 for Minus
        self.arrEmails.add(shrPhone)
        self.tblCreateContact.reloadSections(NSIndexSet(index: 1) as IndexSet, with: UITableViewRowAnimation.automatic)
    }
    
    @objc func DeleteEmailCell(_ sender: UIButton) {
        arrEmails.removeObject(at: sender.tag)
        self.tblCreateContact.reloadSections(NSIndexSet(index: 1) as IndexSet, with: .automatic)
        self.updateFrameOfTableviewandScrollview()
    }
    
    @objc func CreateURLCell(_ sender : UIButton) {
        
        let indexpath : IndexPath = IndexPath(row: sender.tag, section: 0)
        let cell : EmailCell? = self.tblCreateContact.cellForRow(at: indexpath) as! EmailCell?
        
        let shrO : ContactShare = arrPhones.object(at: sender.tag) as! ContactShare
        if (cell?.txtEmail.text) != nil {
            shrO.strValue = (cell?.txtEmail.text)!
        }
        
        
        for contact in arrURLs {
            let tempC : ContactShare = contact as! ContactShare
            tempC.strLastPlushMinus = "0"
        }
        let shrPhone : ContactShare = ContactShare()
        shrPhone.strValue = ""
        shrPhone.strtype = "URL"
        shrPhone.strLastPlushMinus = "1" //1 for Plus , 0 for Minus
        self.arrURLs.add(shrPhone)
        self.tblCreateContact.reloadSections(NSIndexSet(index: 2) as IndexSet, with: UITableViewRowAnimation.automatic)
    }
    
    @objc func DeleteURLCell(_ sender : UIButton) {
        arrURLs.removeObject(at: sender.tag)
        self.tblCreateContact.reloadSections(NSIndexSet(index: 2) as IndexSet, with: .automatic)
        self.updateFrameOfTableviewandScrollview()
    }
    
    @objc func CreateSocialCell(_ sender : UIButton) {
        
        let indexpath : IndexPath = IndexPath(row: sender.tag, section: 3)
        let cell : SocialCell? = self.tblCreateContact.cellForRow(at: indexpath) as! SocialCell?
        
        let shrO : ContactShare = arrSocials.object(at: sender.tag) as! ContactShare
        if (cell?.txtSocial.text) != nil {
            shrO.strValue = (cell?.txtSocial.text)!
        }
        
        for contact in arrSocials {
            let tempC : ContactShare = contact as! ContactShare
            tempC.strLastPlushMinus = "0"
        }
        let shrPhone : ContactShare = ContactShare()
        shrPhone.strValue = ""
        shrPhone.strtype = "Other"
        shrPhone.strLastPlushMinus = "1" //1 for Plus , 0 for Minus
        self.arrSocials.add(shrPhone)
        self.tblCreateContact.reloadSections(NSIndexSet(index: 3) as IndexSet, with: UITableViewRowAnimation.automatic)
        self.updateFrameOfTableviewandScrollview()
    }
    
    @objc func DeleteSocialCell(_ sender : UIButton) {
        arrSocials.removeObject(at:sender.tag)
        self.tblCreateContact.reloadSections(NSIndexSet(index: 3) as IndexSet, with: .automatic)
        self.updateFrameOfTableviewandScrollview()
        
    }
    @objc func CreateInstantMsgCell(_ sender : UIButton) {
        
        let indexpath : IndexPath = IndexPath(row: sender.tag, section: 4)
        let cell : InstantMsgCell? = self.tblCreateContact.cellForRow(at: indexpath) as! InstantMsgCell?
        
        let shrO : ContactShare = arrInstantMsg.object(at: sender.tag) as! ContactShare
        if (cell?.txtMessage.text) != "" {
            shrO.strValue = (cell?.txtMessage.text)!
        }
        
        for contact in arrInstantMsg {
            let tempC : ContactShare = contact as! ContactShare
            tempC.strLastPlushMinus = "0"
        }
        
        let shrPhone : ContactShare = ContactShare()
        shrPhone.strValue = ""
        shrPhone.strtype = "Other"
        shrPhone.strLastPlushMinus = "1" //1 for Plus , 0 for Minus
        self.arrInstantMsg.add(shrPhone)
        self.tblCreateContact.reloadSections(NSIndexSet(index: 4) as IndexSet, with: UITableViewRowAnimation.automatic)
        self.updateFrameOfTableviewandScrollview()
    }
    @objc func DeleteInstantMsgCell(_ sender : UIButton) {
        for contact in arrSocials {
            let tempC : ContactShare = contact as! ContactShare
            tempC.strtype = "WhatsApp"
        }
        arrInstantMsg.removeObject(at:sender.tag)
        self.tblCreateContact.reloadSections(NSIndexSet(index: 4) as IndexSet, with: .automatic)
        self.updateFrameOfTableviewandScrollview()
        
    }
    
    func updateFrameOfTableviewandScrollview() {
        tblCreateContact.frame = CGRect(x: tblCreateContact.frame.origin.x, y: tblCreateContact.frame.origin.y, width: tblCreateContact.contentSize.width, height: tblCreateContact.contentSize.height)
        //scrollObj.frame = tblCreateContact.frame
        scrollObj.contentSize = CGSize(width: self.view.frame.size.width, height: tblCreateContact.contentSize.height + 300)
    }
    
}

extension CreateContactVC : UITextFieldDelegate,  UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}

extension CreateContactVC : kDropDownListViewDelegate {
    func dropDownListView(_ dropdownListView: DropDownListView!, didSelectedIndex anIndex: Int) {
        if dropdownListView == dropDownPhone {
            let shrPhone : ContactShare = arrPhones.object(at: tmpIndexPath.row) as! ContactShare
            shrPhone.strtype =  arrDropdownPhone.object(at: anIndex) as! String
            self.tblCreateContact.reloadSections(NSIndexSet(index: 0) as IndexSet, with: UITableViewRowAnimation.automatic)
        }
        else if dropdownListView == dropDownEmail {
            let shrPhone : ContactShare = arrEmails.object(at: tmpIndexPath.row) as! ContactShare
            shrPhone.strtype =  arrDropdownEmail.object(at: anIndex) as! String
            self.tblCreateContact.reloadSections(NSIndexSet(index: 1) as IndexSet, with: UITableViewRowAnimation.automatic)
        }
        else if dropdownListView == dropDownSocial {
            let shrPhone : ContactShare = arrSocials.object(at: tmpIndexPath.row) as! ContactShare
            shrPhone.strtype =  arrDropdownSocials.object(at: anIndex) as! String
            self.tblCreateContact.reloadSections(NSIndexSet(index: 3) as IndexSet, with: UITableViewRowAnimation.automatic)
        }
        else if dropdownListView == dropDownMessages {
            let shrPhone : ContactShare = arrInstantMsg.object(at: tmpIndexPath.row) as! ContactShare
            shrPhone.strtype =  arrDropdownMsg.object(at: anIndex) as! String
            self.tblCreateContact.reloadSections(NSIndexSet(index: 4) as IndexSet, with: UITableViewRowAnimation.automatic)
        }
    }
    
    func dropDownListView(_ dropdownListView: DropDownListView!, datalist ArryData: NSMutableArray!) {
    }
    
    func dropDownListViewDidCancel() {
        
    }
}
extension CreateContactVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //Convert image in 1 KB
        
        btnProfile.setTitle("", for: UIControlState.normal)
        if let qrcodeImg = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // let myThumb1 = qrcodeImg.resized(withPercentage: 0.2)
            let myThumb2 = qrcodeImg.resized(toWidth: 40.0)
            btnProfile.titleLabel?.text = ""
            btnProfile.setTitle("", for: UIControlState.normal)
            btnProfile.setImage(myThumb2, for: UIControlState.normal)
            self.dismiss(animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

