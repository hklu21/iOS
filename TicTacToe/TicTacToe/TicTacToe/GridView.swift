//
//  GridView.swift
//  TicTacToe
//
//  Created by 卢恒宽 on 2/4/22.
//

import UIKit

class GridView: UIView {
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    
    // draw grid
    private var path = UIBezierPath()
    fileprivate var gridWidthMultiple: CGFloat
    {
        return 3
    }
    fileprivate var gridHeightMultiple : CGFloat
    {
        return 3
    }
    
    var lineWidth: CGFloat
    {
        return 15.0
    }

    var gridWidth: CGFloat
    {
        return (390 - 2 * lineWidth)/CGFloat(gridWidthMultiple)
    }

    var gridHeight: CGFloat
    {
        return (390 - 2 * lineWidth)/CGFloat(gridHeightMultiple)
    }

    fileprivate var gridCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }

    fileprivate func drawGrid()
    {
        path = UIBezierPath()
        path.lineWidth = lineWidth

        for index in 1...Int(gridWidthMultiple) - 1
        {
            let start = CGPoint(x: CGFloat(index) * gridWidth + (CGFloat(index) - 1) * lineWidth + 0.5 * lineWidth, y: 0)
            let end = CGPoint(x: CGFloat(index) * gridWidth + (CGFloat(index) - 1) * lineWidth + 0.5 * lineWidth, y:bounds.height)
            path.move(to: start)
            path.addLine(to: end)
        }

        for index in 1...Int(gridHeightMultiple) - 1 {
            let start = CGPoint(x: 0, y: CGFloat(index) * gridHeight + (CGFloat(index) - 1) * lineWidth + 0.5 * lineWidth)
            let end = CGPoint(x: bounds.width, y: CGFloat(index) * gridHeight + (CGFloat(index) - 1) * lineWidth + 0.5 * lineWidth)
            path.move(to: start)
            path.addLine(to: end)
        }

        //Close the path.
        path.close()

    }

    override func draw(_ rect: CGRect)
    {
        drawGrid()

        // Specify a border (stroke) color.
        UIColor.purple.setStroke()
        path.stroke()
    }

}
