//
//  Game.swift
//  GOMOKU
//
//  Created by huang guanming on 3/12/22.
//

import Foundation

class Game{
    var board:Board
    var gameName:String
    
    /* Intilization */
    init() {
        self.board=Board()
        self.gameName=""
    }
    
    /* Intilization with given name, load setting from user default*/
    init(gameName:String){
        self.board=Board()
        self.gameName=gameName
        print(self.gameName)
        let userDefaults = UserDefaults.standard
        let encodedString=userDefaults.object(forKey: "saved_board_game_\(gameName)") as! String
        self.board.decodingBoard(encodedString)
    }
    
    /* Save the board pieces and turn to user default*/
    public func saveGame(){
        // Access Shared Defaults Object
        let userDefaults = UserDefaults.standard
        userDefaults.set(self.board.encodingBoard(),forKey: "saved_board_game_\(self.gameName)")
    }
    
    
}
