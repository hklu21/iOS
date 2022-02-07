//
//  ViewController.swift
//  TicTacToe
//
//  Created by 卢恒宽 on 2/4/22.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet var GridView: GridView!
    @IBOutlet var Squares: [UIView]!
    @IBOutlet var Square0: UIView!
    @IBOutlet var Square1: UIView!
    @IBOutlet var Square2: UIView!
    @IBOutlet var Square3: UIView!
    @IBOutlet var Square4: UIView!
    @IBOutlet var Square5: UIView!
    @IBOutlet var Square6: UIView!
    @IBOutlet var Square7: UIView!
    @IBOutlet var Square8: UIView!
    @IBOutlet var O: UILabel!
    @IBOutlet var X: UILabel!

    // MARK: - IBActions
    @IBAction func tapDragX(_ sender: UITapGestureRecognizer) {
        print("X tapped!")
        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(handlePan(_:)))
        panGesture.delegate = self
        self.X.addGestureRecognizer(panGesture)
    }
    @IBAction func tapDragO(_ sender: UITapGestureRecognizer) {
        print("O tapped!")
        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(handlePan(_:)))
        panGesture.delegate = self
        self.O.addGestureRecognizer(panGesture)
    }
    
    @IBOutlet var InfoView: InfoView!
    @IBOutlet var Info: UILabel!
    @IBOutlet var OK: UIButton!
    
    
    @IBOutlet var InfoButton: UIButton!
    
    var X_center = CGPoint()
    var O_center = CGPoint()
    var player = "X"
    let grid: Grid = Grid()
    var grids_view: [UILabel] = []
    let shapeLayer = CAShapeLayer()
    // original centers
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        for (index, g) in self.Squares.enumerated() {
            print(g.center)
            g.center.x = CGFloat((index % 3)) * (self.GridView.gridWidth + self.GridView.lineWidth) + self.GridView.gridWidth * 0.5 + self.GridView.lineWidth * 0.5 - 4
            g.center.y = 99 + CGFloat((index / 3)) * (self.GridView.gridHeight + self.GridView.lineWidth) + self.GridView.gridHeight * 0.5 +  self.GridView.lineWidth * 0.5
            g.frame.size.width = self.GridView.gridWidth
            g.frame.size.height = self.GridView.gridHeight
            //self.view.bringSubviewToFront(g)
            //g.backgroundColor = UIColor.red
            //print("center of square\(index): \(g.center)")
        }
         
        self.X.isUserInteractionEnabled = true
        self.O.isUserInteractionEnabled = true
        self.X.alpha = 0.5
        self.O.alpha = 0.5
        self.view.isUserInteractionEnabled = true
        X_center = self.X.center
        O_center = self.O.center
        print(self.X.center)
        print(self.O.center)
        self.InfoView.center = CGPoint(x:self.view.center.x, y:-1000)
        self.InfoView.Info.text = "Get 3 in a row to win!"
        
        InfoButton.addTarget(self, action: #selector(tapShowInfo), for: UIControl.Event.touchUpInside)
        OK.addTarget(self, action: #selector(tapGoBack), for: UIControl.Event.touchUpInside)
        print("State: \(grid.state)")
        print("Player: \(player)")
        if player == "X" {
            self.O.isUserInteractionEnabled = false
            self.X.alpha = 1
        } else{
            self.X.isUserInteractionEnabled = false
            self.O.alpha = 1
        }
        /*
        while grid.state == State.not_end {
            if player == "X" {
                self.O.isUserInteractionEnabled = false
                self.X.alpha = 1
            }
        }
         */
        
        
    }

    
    
    
    // MARK: - Gesture Methods
    @objc func handlePan(_ gestureRecogizer:UIPanGestureRecognizer) {
        let translation = gestureRecogizer.translation(in: self.view)
        if let view = gestureRecogizer.view {
            view.center = CGPoint(x: view.center.x + translation.x,
                                  y: view.center.y + translation.y)
            gestureRecogizer.setTranslation(CGPoint.zero, in: self.view)
        }

        if gestureRecogizer.state == .ended{
            print("Player: \(player)")
            if player == "X" {
                // place an X
                var if_placed = false
                var gridsIntersected: [Int: CGFloat] = [:]
                for (index, g) in self.Squares.enumerated() {
                    if X.frame.intersects(g.frame) {
                        gridsIntersected[index] = pow(g.center.x - X.center.x, 2) + pow(g.center.y - X.center.y, 2)
                    }
                }
                let sortedGridsIntersected = gridsIntersected.sorted{return $0.value < $1.value }
                for g in sortedGridsIntersected {
                    if !grid.O_grids.contains(g.key) && !grid.X_grids.contains(g.key) {
                        if_placed = true
                        grid.X_grids.insert(g.key)
                        let new_X = UILabel(frame : CGRect(x: 0, y: 0, width: X.frame.width, height: X.frame.height))
                        new_X.backgroundColor = X.backgroundColor
                        new_X.text = X.text
                        new_X.font = X.font
                        new_X.textAlignment = X.textAlignment
                        new_X.textColor = X.textColor
                        new_X.center = Squares[g.key].center
                        new_X.layer.borderWidth = 3
                        new_X.layer.borderColor = UIColor.white.cgColor
                        self.view.addSubview(new_X)
                        grids_view.append(new_X)
                        grid.occupied_num += 1
                        break
                    }
                }
                // check state
                var if_end = false
                if grid.ifWin(grids: grid.X_grids) {
                    if_end = true
                    let winning_grids = grid.winningGrids(grids: grid.X_grids)
                    // draw the winning line
                    let path: UIBezierPath = UIBezierPath()
                    path.move(to: CGPoint(x: Squares[winning_grids[0]].center.x, y: Squares[winning_grids[0]].center.y))
                    path.addLine(to: CGPoint(x: Squares[winning_grids[2]].center.x, y: Squares[winning_grids[2]].center.y))
                    shapeLayer.strokeColor = UIColor.orange.cgColor
                    shapeLayer.lineWidth = self.GridView.lineWidth
                    shapeLayer.path = path.cgPath
                    // animate it
                    view.layer.addSublayer(shapeLayer)
                    let animation = CABasicAnimation(keyPath: "strokeEnd")
                    animation.fromValue = 0
                    animation.duration = 3
                    shapeLayer.add(animation, forKey: "MyAnimation")
                    
                    
                    grid.state = State.X_win
                    self.view.bringSubviewToFront(self.InfoView)
                    UIView.animate(withDuration: 0.5, delay: 3) {
                        self.InfoView.center = CGPoint(x:self.view.center.x, y:self.view.center.y)
                        self.InfoView.Info.text = "Congratulations, X wins!"
                    }
                } else if grid.occupied_num >= 9 {
                    if_end = true
                    grid.state = State.Tie
                    self.view.bringSubviewToFront(self.InfoView)
                    UIView.animate(withDuration: 0.5) {
                        self.InfoView.center = CGPoint(x:self.view.center.x, y:self.view.center.y)
                        self.InfoView.Info.text = "It is a Tie!"
                    }
                }
                
                // change turn
                X.center = X_center
                if !if_end && if_placed{
                    player = "O"
                    self.X.isUserInteractionEnabled = false
                    self.X.alpha = 0.5
                    self.O.isUserInteractionEnabled = true
                    self.O.alpha = 1
                }
            } else {
                // place an O
                var if_placed = false
                var gridsIntersected: [Int: CGFloat] = [:]
                for (index, g) in self.Squares.enumerated() {
                    if O.frame.intersects(g.frame) {
                        gridsIntersected[index] = pow(g.center.x - O.center.x, 2) + pow(g.center.y - O.center.y, 2)
                    }
                }
                let sortedGridsIntersected = gridsIntersected.sorted{return $0.value < $1.value }
                for g in sortedGridsIntersected {
                    if !grid.O_grids.contains(g.key) && !grid.X_grids.contains(g.key) {
                        if_placed = true
                        grid.O_grids.insert(g.key)
                        let new_O = UILabel(frame : CGRect(x: 0, y: 0, width: X.frame.width, height: X.frame.height))
                        new_O.backgroundColor = O.backgroundColor
                        new_O.text = O.text
                        new_O.font = O.font
                        new_O.textAlignment = O.textAlignment
                        new_O.textColor = O.textColor
                        new_O.center = Squares[g.key].center
                        new_O.layer.borderWidth = 3
                        new_O.layer.borderColor = UIColor.white.cgColor
                        self.view.addSubview(new_O)
                        grids_view.append(new_O)
                        grid.occupied_num += 1
                        break
                    }
                }
                // check state
                if grid.ifWin(grids: grid.O_grids) {
                    grid.state = State.O_win
                    let winning_grids = grid.winningGrids(grids: grid.O_grids)
                    // draw the winning line
                    let path: UIBezierPath = UIBezierPath()
                    path.move(to: CGPoint(x: Squares[winning_grids[0]].center.x, y: Squares[winning_grids[0]].center.y))
                    path.addLine(to: CGPoint(x: Squares[winning_grids[2]].center.x, y: Squares[winning_grids[2]].center.y))
                    shapeLayer.strokeColor = UIColor.orange.cgColor
                    shapeLayer.lineWidth = self.GridView.lineWidth
                    shapeLayer.path = path.cgPath
                    // animate it
                    view.layer.addSublayer(shapeLayer)
                    let animation = CABasicAnimation(keyPath: "strokeEnd")
                    animation.fromValue = 0
                    animation.duration = 3
                    shapeLayer.add(animation, forKey: "MyAnimation")
                    
                    self.view.bringSubviewToFront(self.InfoView)
                    UIView.animate(withDuration: 0.5, delay: 3) {
                        self.InfoView.center = CGPoint(x:self.view.center.x, y:self.view.center.y)
                        self.InfoView.Info.text = "Congratulations, O wins!"
                    }
                } else if grid.occupied_num >= 9 {
                    grid.state = State.Tie
                    self.view.bringSubviewToFront(self.InfoView)
                    UIView.animate(withDuration: 0.5) {
                        self.InfoView.center = CGPoint(x:self.view.center.x, y:self.view.center.y)
                        self.InfoView.Info.text = "It is a Tie!"
                    }
                }
                
                // change turn
                O.center = O_center
                if if_placed {
                    player = "X"
                    self.O.isUserInteractionEnabled = false
                    self.O.alpha = 0.5
                    self.X.isUserInteractionEnabled = true
                    self.X.alpha = 1
                }
            }
        }
        
        
    }
    
    @IBAction func tapShowInfo(_ sender: UIButton) {
        self.view.bringSubviewToFront(self.InfoView)
        UIView.animate(withDuration: 0.5) {
            self.InfoView.center = CGPoint(x:self.view.center.x, y:self.view.center.y)
        }
    }
    @IBAction func tapGoBack(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.InfoView.center = CGPoint(x:self.view.center.x, y:1000)
        } completion: { (finished) in
            self.InfoView.center = CGPoint(x:self.view.center.x, y:-1000)
            // restart if game over
            if self.grid.state != State.not_end {
                self.InfoView.Info.text = "Get 3 in a row to win!"
                self.player = "X"
                
                // remove the winning line if any
                self.shapeLayer.removeFromSuperlayer()
                
                self.O.isUserInteractionEnabled = false
                self.X.alpha = 1
                self.O.alpha = 0.5
                self.grid.restart()
                for gv in self.grids_view {
                    gv.removeFromSuperview()
                }
                self.grids_view = []
            }
            self.view.sendSubviewToBack(self.InfoView)
            
        }
        
    }


}



