//
//  BoardView.swift
//  GOMOKU
//
//  Created by 卢恒宽 on 3/11/22.
//

// modified from https://github.com/JiachenRen/Gomoku/blob/master/Gomoku/BoardView.swift
import UIKit

class BoardView: UIView {
    var boardColor: UIColor = UIColor.yellow
    var cornerOffset: CGFloat = 10
    var gridLineWidth: CGFloat = 1
    var gridColor: UIColor = UIColor.black
    var vertexRadius: CGFloat = 3
    var vertexColor: UIColor = UIColor.black
    var verticesVisible: Bool = true
    var blackPieceColor: UIColor = UIColor.black
    var whitePieceColor: UIColor = UIColor.white
    var pieceScale: CGFloat = 0.9
    
    var board = Board()
    
    var lastMove: Coordinate?
    var winningCoordinates: [Coordinate]?
    
    //this should only apply when using standard board
    static var vertices: [Coordinate] = {
       return [(3, 3), (15, 3), (3, 15), (15, 15), (9, 9), (9, 15), (15, 9), (9, 3), (3, 9)]
    }()
    
    var dummyPiece: (Piece, CGPoint)? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var pieces: [[Piece?]]?
    
    
    var pieceRadius: CGFloat {
        return gap / 2 * pieceScale
    }
    
    var dimension: Int = 19 {
        didSet {
            DispatchQueue.main.async {[unowned self] in
                self.setNeedsDisplay()
            }
        }
    }
    
    var boardWidth: CGFloat {
        return self.bounds.width - cornerOffset * 2
    }
    
    var gap: CGFloat {
        return boardWidth / CGFloat(dimension - 1)
    }
    
    var context: CGContext {
        return UIGraphicsGetCurrentContext()!
    }
    
    override func draw(_ rect: CGRect) {
        //draws the background for the board
        boardColor.setFill()
        UIBezierPath(rect: bounds).fill()
        
        //draw the grid
        gridColor.setStroke()
        pathForGrid().stroke()
        
        //draw the vertices, 19 for standard board
        if verticesVisible && dimension == 19 {
            self.drawVertices()
        }
        
        //draw pieces
        drawPieces()
        
        //draw dummy piece to help place the piece
        drawDummyPiece()
        
        //highlight the winning coordinates
        highlightWinningCos()
        
        // highlight the most recent move
        highlighRecentCo()
        
    }
    
    
    private func drawDummyPiece() {
        guard let (piece, pos) = self.dummyPiece else {
            return
        }
        let coordinate = onBoard(pos)
        if pieces?[coordinate.row][coordinate.col] != nil {
            return
        }
        let corrected = onScreen(coordinate)
        (piece == .black ? blackPieceColor : whitePieceColor).withAlphaComponent(0.5).setFill()
        CGContext.fillCircle(center: corrected, radius: pieceRadius)
    }
    
    private func pathForGrid() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: cornerOffset, y: cornerOffset))
        (0..<dimension).map{CGFloat($0)}.forEach{
            
            //draw the vertical lines
            path.move(to: CGPoint(x: cornerOffset + $0 * gap, y: cornerOffset))
            path.addLine(to: CGPoint(x: cornerOffset + $0 * gap, y: bounds.height - cornerOffset))
            
            //draw the horizontal lines
            path.move(to: CGPoint(x: cornerOffset, y: cornerOffset + $0 * gap))
            path.addLine(to: CGPoint(x: bounds.width - cornerOffset, y: cornerOffset + $0 * gap))
        }
        path.lineWidth = self.gridLineWidth
        path.lineCapStyle = .round
        return path
    }
    
    private func drawVertices() {
        self.vertexColor.setFill()
        BoardView.vertices.map{onScreen($0)}.forEach {
            CGContext.fillCircle(center: $0, radius: vertexRadius)
        }
    }
    
    private func drawPieces() {
        guard let pieces = self.pieces else {
            return
        }
        for row in 0..<pieces.count {
            for col in 0..<pieces[row].count {
                if let piece = pieces[row][col] {
                    switch piece {
                    case .black:
                        self.blackPieceColor.setFill()

                    case .white:
                        self.whitePieceColor.setFill()

                    }
                    let point = onScreen(Coordinate(col: col, row: row))
                    CGContext.fillCircle(center: point, radius: pieceRadius)
                }
            }
        }
    }
    
    /* highlight winning coordinates */
    private func highlightWinningCos() {
        if let coordinates = self.winningCoordinates, coordinates.count > 0 {
            let color = UIColor.red
            color.withAlphaComponent(1).setStroke()
            coordinates.forEach { co in
                color.setFill()
                CGContext.fillCircle(center: onScreen(co), radius: pieceRadius)
                //context.setLineWidth(pieceRadius / 8)
                //context.strokeEllipse(in: CGRect(center: onScreen(co), size: CGSize(width: pieceRadius * 2, height: pieceRadius * 2)))
            }
        }
    }
    
    /* highlight the most recent move */
    private func highlighRecentCo() {
        if let coordinates = self.lastMove {
            let color = UIColor.red
            color.withAlphaComponent(1).setStroke()
            context.setLineWidth(pieceRadius / 8)
            context.strokeEllipse(in: CGRect(center: onScreen(coordinates), size: CGSize(width: pieceRadius * 2, height: pieceRadius * 2)))
            
        }
    }
    
    
    private func onScreen(_ coordinate: Coordinate) -> CGPoint {
        return CGPoint(
            x: cornerOffset + CGFloat(coordinate.col) * gap,
            y: cornerOffset + CGFloat(coordinate.row) * gap
        )
    }
    
    public func onBoard(_ onScreen: CGPoint) -> Coordinate {
        func convert(_ n: CGFloat) -> Int {
            return Int((n - cornerOffset) / gap + 0.5)
        }
        return (convert(onScreen.x), convert(onScreen.y))
    }

}
