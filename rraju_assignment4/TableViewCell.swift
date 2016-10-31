//
//  TableViewCell.swift
//  rraju_assignment4
//
//  Created by Rohith Raju on 10/23/16.
//  Copyright © 2016 Rohith Raju. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var sponsor: UILabel!
    @IBOutlet weak var league: UILabel!
    @IBOutlet weak var goals: UILabel!
    @IBOutlet weak var point: UILabel!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
