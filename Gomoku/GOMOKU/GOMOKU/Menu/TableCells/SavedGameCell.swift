//
//  SavedGameCell.swift
//  GOMOKU
//
//  Created by 卢恒宽 on 3/9/22.
//

import UIKit

class SavedGameCell: UITableViewCell {

    @IBOutlet var GameName: UILabel!
    
    @IBOutlet var SavedTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
