//
//  LabelViewCell.swift
//  Yelp
//
//  Created by Gonzalez, Ivan on 9/27/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class LabelViewCell: UITableViewCell {

    
    @IBOutlet weak var selectionLabel: UILabel!
    
    @IBOutlet weak var selectionButton: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
