//
//  ContactCell.swift
//  App
//
//  Created by admin on 17/01/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
