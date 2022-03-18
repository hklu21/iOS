//
//  VolumeCell.swift
//  GOMOKU
//
//  Created by 卢恒宽 on 3/9/22.
//

import UIKit

class VolumeCell: UITableViewCell {
    
    @IBOutlet var VolumeType: UILabel!
    @IBOutlet var Volume: UISlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
