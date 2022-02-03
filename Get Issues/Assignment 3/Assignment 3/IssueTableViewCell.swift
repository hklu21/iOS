//
//  IssueTableViewCell.swift
//  Assignment 3
//
//  Created by 卢恒宽 on 1/30/22.
//

import UIKit

class IssueTableViewCell: UITableViewCell {
    
    @IBOutlet var IssueTitle: UILabel!
    @IBOutlet var Username: UILabel!
    @IBOutlet var IssueState: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
