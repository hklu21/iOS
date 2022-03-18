//
//  PlayerCell.swift
//  GOMOKU
//
//  Created by 卢恒宽 on 3/15/22.
//

import UIKit

class PlayerCell: UITableViewCell {

    @IBOutlet weak var PlayerName: UILabel!
    @IBOutlet weak var PlayerScore: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
