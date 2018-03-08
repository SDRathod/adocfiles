//
//  PhoneCell.swift
//  App
//
//  Created by manish on 02/02/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

//Common ShareObject


class ContactShare : NSObject {
    var strtype : String = ""
    var strValue : String = ""
    var strLastPlushMinus : String = "+"
}

class PhoneCell: UITableViewCell {

    @IBOutlet weak var btnType: UIButton!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var btnPlushMinus: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

class EmailCell: UITableViewCell {
    
    @IBOutlet weak var btnType: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnPlushMinus: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

class URLCell: UITableViewCell {
    
    @IBOutlet weak var btnType: UIButton!
    @IBOutlet weak var txtURL: UITextField!
    @IBOutlet weak var btnPlushMinus: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class SocialCell: UITableViewCell {
    
    @IBOutlet weak var btnType: UIButton!
    @IBOutlet weak var txtSocial: UITextField!
    @IBOutlet weak var btnPlushMinus: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class InstantMsgCell: UITableViewCell {
    
    @IBOutlet weak var btnType: UIButton!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var btnPlushMinus: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class ContactAddressShare : NSObject {
    var strLine1 : String = ""
    var strLine2 : String = ""
    var strCity : String = ""
    var strState : String = ""
    var strCountry : String = ""
}

class AddressCell: UITableViewCell {
    @IBOutlet weak var txtAddressLine1: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtAddressLine2: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class ContactAboutMeShare : NSObject {
    var strAboutMe : String = ""
}

class AboutMeCell: UITableViewCell {
    
    @IBOutlet weak var txtAboutMe: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension UIResponder {
    
    func next<T: UIResponder>(_ type: T.Type) -> T? {
        return next as? T ?? next?.next(type)
    }
}

extension UITableViewCell {
    
    var tableView: UITableView? {
        return next(UITableView.self)
    }
    
    var indexPath: IndexPath? {
        return tableView?.indexPath(for: self)
    }
}
