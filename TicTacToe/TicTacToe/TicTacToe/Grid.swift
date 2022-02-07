//
//  Grid.swift
//  TicTacToe
//
//  Created by 卢恒宽 on 2/6/22.
//

import Foundation
import UIKit

// game state
enum State {
    case not_end
    case X_win
    case O_win
    case Tie
}



class Grid {
    var state: State
    var X_grids: Set<Int> = []
    var O_grids: Set<Int> = []
    var occupied_num: Int
    init() {
        state = State.not_end
        occupied_num = 0
    }
    
    // check if there is a winner
    func ifWin(grids: Set<Int>) -> Bool {
        return Set([0, 1, 2]).isSubset(of: grids) || Set([3, 4, 5]).isSubset(of: grids) || Set([6, 7, 8]).isSubset(of: grids) ||
        Set([0, 3, 6]).isSubset(of: grids) || Set([1, 4, 7]).isSubset(of: grids) || Set([2, 5, 8]).isSubset(of: grids) ||
        Set([0, 4, 8]).isSubset(of: grids) || Set([2, 4, 6]).isSubset(of: grids)
    }
    
    // find the winning grids places
    func winningGrids(grids: Set<Int>) -> [Int] {
        if Set([0, 1, 2]).isSubset(of: grids){
            return [0, 1, 2]
        } else if Set([3, 4, 5]).isSubset(of: grids){
            return [3, 4, 5]
        } else if Set([6, 7, 8]).isSubset(of: grids){
            return [6, 7, 8]
        } else if Set([0, 3, 6]).isSubset(of: grids){
            return [0, 3, 6]
        } else if Set([1, 4, 7]).isSubset(of: grids){
            return [1, 4, 7]
        } else if Set([2, 5, 8]).isSubset(of: grids){
            return [2, 5, 8]
        } else if Set([0, 4, 8]).isSubset(of: grids){
            return [0, 4, 8]
        } else if Set([2, 4, 6]).isSubset(of: grids){
            return [2, 4, 6]
        }
        return []
    
    }
    
    // clear the grid and restart
    func restart() {
        state = State.not_end
        occupied_num = 0
        X_grids = Set([])
        O_grids = Set([])
    }
    
}
