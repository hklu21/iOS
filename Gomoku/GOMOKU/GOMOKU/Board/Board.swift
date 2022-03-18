//
//  Board.swift
//  GOMOKU
//
//  Created by 卢恒宽 on 3/11/22.
//

import Foundation
import UIKit

public typealias Coordinate = (col: Int, row: Int)

public class Board: MyBoard{
    var delegate: MyBoardDelegate?
    var pieces: [[Piece?]]!
    var currTurn: Piece
    var blackFirst: Bool = true
    var blackLastMoves: Coordinate?
    var blackSecondLastMoves: Coordinate?
    var whiteLastMoves: Coordinate?
    var whiteSecondLastMoves: Coordinate?
    var lastMove: Coordinate?
    var availablePieces: [[Bool]]!
    
    
    required public init() {
        self.currTurn = self.blackFirst ? .black : .white
        self.availablePieces = [[Bool]](repeatElement([Bool](repeatElement(true, count: 19)), count: 19))
        self.pieces = Array<Array<Piece?>>(repeatElement([Piece?]( repeatElement(nil, count: 19)), count: 19))
    }
    
    /* put a chess */
    public func put(_ coordinate: Coordinate, _ maxRegeretStep: Int) {
        guard let _ = pieces[coordinate.row][coordinate.col] else {
            pieces[coordinate.row][coordinate.col] = currTurn
            
            // update available places
            self.availablePieces[coordinate.row][coordinate.col] = false
            
            // store last moves
            switch maxRegeretStep {
            case 2:
                switch currTurn {
                case .black:
                    self.blackSecondLastMoves = self.blackLastMoves
                    self.blackLastMoves = coordinate
                default:
                    self.whiteSecondLastMoves = self.whiteLastMoves
                    self.whiteLastMoves = coordinate
                }
            case 1:
                switch currTurn {
                case .black:
                    self.blackLastMoves = coordinate
                default:
                    self.whiteLastMoves = coordinate
                }
            default:
                break
            }

            
            lastMove = coordinate
            
            /* if winning, highlight the winning coordinates and show alert */
            let winningCos = findWinningCoordinates(co: coordinate)
            if !winningCos.isEmpty {
                print("\(currTurn) wins!\n")
                delegate?.boardStatusUpdated(data: winningCos)
            } else {
                print("not winning!\n")
            }
            
            self.currTurn = currTurn.next()
            // update BoardView
            self.delegate?.boardDidUpdate()
            return
        }
    }
    
    /* check whether a regret is available */
    public func regretAvailable() -> Bool {
        switch currTurn {
        case .white:
            return self.blackLastMoves != nil
        default:
            return self.whiteLastMoves != nil
        }
    }
    
    /* regret a move */
    public func regret() {
        if self.regretAvailable() {
            self.pieces[self.lastMove?.row ?? 0][self.lastMove?.col ?? 0] = nil
            
            // update LastMoves
            switch currTurn {
            case .white:
                self.blackLastMoves = self.blackSecondLastMoves
                self.blackSecondLastMoves = nil
                self.lastMove = self.whiteLastMoves
            default:
                self.whiteLastMoves = self.whiteSecondLastMoves
                self.whiteSecondLastMoves = nil
                self.lastMove = self.blackLastMoves
            }
            
            // update BoardView
            self.currTurn = currTurn.next()
            self.delegate?.boardDidUpdate()
            return
        }
        
    }
    
    /* judge whether a coordinate is valid on board */
    public func isValid(co: Coordinate) -> Bool {
        return co.col >= 0 && co.row >= 0 && co.col < 19 && co.row < 19
    }
    
    /* judge whether a player is winning the game.
     * If a player is winning, return the winning coordinates.
     * If not, return an empty list.
     */
    public func findWinningCoordinates(co: Coordinate) -> [Coordinate] {
        
        let currRow = co.row, currCol = co.col
        let currColor = pieces[currRow][currCol]
        
        var temp = [Coordinate]() // a temp buffer to hold possible winning cos
        // check horizontal
        for i in -4...0 {
            for q in i...(i + 4) {
                let co = Coordinate(col: currCol + q, row: currRow)
                if !isValid(co: co) || pieces[co.row][co.col] == nil || pieces[co.row][co.col] != currColor {
                    temp.removeAll()
                    break
                } else {
                    temp.append(co)
                }
            }
            if !temp.isEmpty {
                return temp
            }
        }
        
        // check vertical
        for i in -4...0 {
            for q in i...(i + 4) {
                let co = Coordinate(col: currCol, row: currRow + q)
                if !isValid(co: co) || pieces[co.row][co.col] == nil || pieces[co.row][co.col] != currColor {
                    temp.removeAll()
                    break
                } else {
                    temp.append(co)
                }
            }
            if !temp.isEmpty {
                return temp
            }
        }
        
        // check diagnol slope 1
        for i in -4...0 {
            for q in i...(i + 4) {
                let co = Coordinate(col: currCol + q, row: currRow + q)
                if !isValid(co: co) || pieces[co.row][co.col] == nil || pieces[co.row][co.col] != currColor {
                    temp.removeAll()
                    break
                } else {
                    temp.append(co)
                }
            }
            if !temp.isEmpty {
                return temp
            }
        }
        
        // check diagnol slope 2
        for i in -4...0 {
            for q in i...(i + 4) {
                let co = Coordinate(col: currCol + q, row: currRow - q)
                if !isValid(co: co) || pieces[co.row][co.col] == nil || pieces[co.row][co.col] != currColor {
                    temp.removeAll()
                    break
                } else {
                    temp.append(co)
                }
            }
            if !temp.isEmpty {
                return temp
            }
        }
        
        return [Coordinate]()
    }
    
    /* Randomly select put the chess on all available spots */
    public func randomPut(_ maxRegeretStep: Int){
        var randomCandidate=[[Int]]()
        for i in 0...18{
            for j in 0...18{
                if self.pieces[i][j]==nil{
                    randomCandidate.append([i,j])
                }
            }
        }
        let coor=randomCandidate.randomElement()
        self.put(Coordinate(coor![0],coor![1]), maxRegeretStep)
        return
    }
    
    /*Encoding the board info(turn and pieces) into string*/
    public func encodingBoard() -> String{
        var encodedString=String(currTurn.rawValue)
        for row in pieces{
            for cell in row{
                if cell==nil{
                    encodedString+="2"
                }else{
                    encodedString+=String(cell!.rawValue)
                }
            }
        }
        return encodedString
    }
    
    /*Load board from encoded string*/
    public func decodingBoard(_ encodedString:String){
        if encodedString.count != 1+19*19{
            assertionFailure("Invalid encoded string size of \(encodedString.count)")
        }
        let turn=encodedString[encodedString.index(encodedString.startIndex, offsetBy: 0)]
        if turn == "0"{
            self.currTurn=Piece.black
        }else{
            self.currTurn=Piece.white
        }
        
        for i in 0...18{
            for j in 0...18{
                let char = encodedString[encodedString.index(encodedString.startIndex, offsetBy: 1+i*19+j)]
                if char=="0"{
                    self.pieces[i][j]=Piece.black
                }else if char=="1"{
                    self.pieces[i][j]=Piece.white
                }
            }
        }
    }
}


public enum Piece: Int {
    case black = 0
    case white = 1
    
    func next() -> Piece {
        switch self {
        case .black: return .white
        default: return .black
        }
    }
}


protocol MyBoardDelegate {
    func boardDidUpdate()
    func boardStatusUpdated(data: Any?)
}

protocol MyBoard {
    var pieces: [[Piece?]]! {get}
    func put(_ : Coordinate, _ : Int)
}
