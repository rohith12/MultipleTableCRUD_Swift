//
//  TableViewCell.swift
//  rraju_Assignment3
//
//  Created by Rohith Raju on 10/4/16.
//  Copyright © 2016 Rohith Raju. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var bprice: UILabel!
    @IBOutlet weak var bname: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
