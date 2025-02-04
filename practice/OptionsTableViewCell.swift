//
//  OptionsTableViewCell.swift
//  practice
//
//  Created by Reekesh Nakarmi on 2/3/25.
//

import UIKit

class OptionsTableViewCell: UITableViewCell {

    @IBOutlet weak var optionsTextLabel: UILabel!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
