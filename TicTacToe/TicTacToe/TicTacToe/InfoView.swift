//
//  InfoView.swift
//  TicTacToe
//
//  Created by 卢恒宽 on 2/5/22.
//

import UIKit

class InfoView: UIView {
    @IBOutlet var Info: UILabel!
    @IBOutlet var OK: UIButton!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let path1 = UIBezierPath(roundedRect:OK.bounds,
                                byRoundingCorners:[.bottomRight, .bottomLeft],
                                cornerRadii: CGSize(width: 20, height:  20))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.path = path1.cgPath
        OK.layer.mask = maskLayer1
        OK.layer.borderColor = UIColor(white: 1.0, alpha: 0.0).cgColor
        OK.layer.borderWidth = 2.5
        OK.layer.backgroundColor = UIColor.systemIndigo.cgColor
        
        let path2 = UIBezierPath(roundedRect:Info.bounds,
                                byRoundingCorners:[.topRight, .topLeft],
                                cornerRadii: CGSize(width: 20, height:  20))
        let maskLayer2 = CAShapeLayer()
        maskLayer2.path = path2.cgPath
        Info.layer.mask = maskLayer2
        Info.layer.borderColor = UIColor(white: 1.0, alpha: 0.0).cgColor
        Info.layer.borderWidth = 2.5
        Info.layer.backgroundColor = UIColor.systemIndigo.cgColor
    
        layer.cornerRadius = 20.0
        layer.borderWidth = 5
        layer.borderColor = UIColor.white.cgColor
        layer.backgroundColor = UIColor.white.cgColor
        self.alpha = 1
    }

}
