//
//  TableViewCell.swift
//  Assignment4
//
//  Created by Ashwini Shekhar Phadke on 4/14/18.
//  Copyright © 2018 Ashwini Shekhar Phadke. All rights reserved.
//

import UIKit
import Firebase
class TableViewCell: UITableViewCell {
    
    
    var reviewlabel = UILabel()
    
    var review : Review!{
        didSet {
            reviewlabel.text = review?.text
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
