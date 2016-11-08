//
//  DetailTableViewCell.swift
//  SwiftUITableViewApp
//
//  Created by Ekaterina Krasnova on 03/11/2016.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
