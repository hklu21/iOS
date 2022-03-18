//
//  TimeLimitAndRegretCell.swift
//  GOMOKU
//
//  Created by 卢恒宽 on 3/10/22.
//

import UIKit

class TimeLimitAndRegretCell: UITableViewCell {

    @IBOutlet var ControlType: UILabel!
    @IBOutlet var ControlValue: UISegmentedControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
