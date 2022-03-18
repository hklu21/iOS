//
//  BoardViewController.swift
//  GOMOKU
//
//  Created by 卢恒宽 on 3/11/22.
//

import UIKit
import AVFoundation

var moveSoundPlayer = AVAudioPlayer()
var backgroundSoundPlayer = AVAudioPlayer()

class BoardViewController: UIViewController, MyBoardDelegate {
    // party game variables
    var Players: [String:Int] = [:]
    var BlackPlayer: String?
    var WhitePlayer: String?
    var PartyGame = false

    @IBOutlet weak var backButton: UIButton!
    
    /*Timer variables*/
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var whiteChessImage: UIImageView!
    @IBOutlet weak var blackChessImage: UIImageView!
    // setting variables
    var timer=Timer()
    var timeToTakeMove: Int?
    var seconds: Int?
    var isTimerEnabled: Bool?
    var lauchVolume: Float?
    var backgroundVolume: Float?
    var maxRegretStep: Int?
    
    /* The back button get clicked*/
    @IBAction func backButtonTouched(_ sender: UIButton) {
        backgroundSoundPlayer.stop()
        if !PartyGame {
            self.dismiss(animated: true, completion: nil)
        } else {
            // show a alert to back to party game view
            let alert = UIAlertController(title: "Game not ended! Still go back?", message: "", preferredStyle: .alert)
            
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
                // back to the party view
                let PartyView = self.storyboard!.instantiateViewController(withIdentifier: "PartyView") as! PartyViewController
                PartyView.Players = self.Players
                PartyView.modalPresentationStyle = .fullScreen
                self.present(PartyView, animated:true, completion:nil)
                }
            ))
            
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    @IBOutlet weak var boardView: BoardView!
    var board:Board?
    var game:Game?
    var showBackButton:Bool? /*No need to show back button in loaded game*/
    
    /* When the save button get clicked*/
    @IBAction func saveButtonClicked(_ sender: Any) {

        /*https://stackoverflow.com/questions/33996443/how-to-add-text-input-in-alertview-of-ios-8*/
        
        /* Pause the timer*/
         timer.invalidate()
        var textField: UITextField?

        // create alertController
        let alertController = UIAlertController(title: "Save game", message: "Saved game name:", preferredStyle: .alert)
          alertController.addTextField { (pTextField) in
          pTextField.placeholder = "your game name"
          pTextField.clearButtonMode = .whileEditing
          pTextField.borderStyle = .none
          textField = pTextField
        }

        // create cancel button
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (pAction) in
          alertController.dismiss(animated: true, completion: nil)
        }))

        // create Ok button
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (pAction) in
          // TODO: check input value is not blank
          let inputValue = textField?.text
            self.game!.gameName=inputValue!
            self.game!.saveGame()
          alertController.dismiss(animated: true, completion: nil)
        }))

        // show alert controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    /* When the regret button get clicked*/
    @IBAction func regretButtonClicked(_ sender: UIButton) {
        if !(self.board?.regretAvailable() ?? false) {
            // show a alert to restart or go back to main menu
            let alert = UIAlertController(title: "Can Not Regret More Steps!", message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
            self.present(alert, animated: true)
        } else{
            self.board?.regret()
        }
    }
    
    /* tap to make the move */
    @IBAction func tapOnBoard(_ sender: UITapGestureRecognizer) {
        let coordinate = self.boardView.onBoard(sender.location(in: self.boardView))
        board!.put(coordinate, self.maxRegretStep ?? 0)
        // play a sound
        let url = Bundle.main.url(forResource: "move", withExtension: "mp3")!
        moveSoundPlayer = try!AVAudioPlayer(contentsOf: url)
        moveSoundPlayer.volume = 10 * (self.lauchVolume ?? 0.5)
        moveSoundPlayer.prepareToPlay()
        moveSoundPlayer.play()
        
        //Reset timer
        if self.isTimerEnabled!{
            self.resetTimer()
        }
    }
    
    override func viewDidLoad() {
        print("view did load")
        super.viewDidLoad()
        
        if (self.game == nil){
            /* New game */
            self.game=Game()
        }else{
            /* Loaded game, hide back button*/
            backButton.isHidden=true
        }
        self.board=self.game?.board
        self.board!.delegate = self
        boardDidUpdate()
        
        /* Set the timeToTakeMove accorrding to setting*/
        loadTimeFromSetting()
        
        /* load setting variables */
        loadOtherSettings()
        
        
        /*Run Timer*/
        if self.isTimerEnabled ?? false{
            runTimer()
        }
        
        // play a background sound
        let url = Bundle.main.url(forResource: "background", withExtension: "m4a")!
        backgroundSoundPlayer = try!AVAudioPlayer(contentsOf: url)
        backgroundSoundPlayer.volume = 10 * (self.backgroundVolume ?? 0.5)
        backgroundSoundPlayer.numberOfLoops = -1
        backgroundSoundPlayer.prepareToPlay()
        backgroundSoundPlayer.play()
    }
    
    /* Load time setting */
    func loadTimeFromSetting(){
        let val=loadSetting("time_limit") as? Int
        if val==0{
            self.timeToTakeMove=15
            self.isTimerEnabled=true
            self.seconds=timeToTakeMove
        }else if val==2{
            /*No limit*/
            self.isTimerEnabled=false
            self.timeLabel.isEnabled=false
            self.timeLabel.isHidden=true
        }else{
            self.timeToTakeMove=30
            self.isTimerEnabled=true
            self.seconds=timeToTakeMove
        }
    }
    
    /* Load settings like volume */
    func loadOtherSettings(){
        // lauch volume
        let v1=loadSetting("launch_volume") as? Float
        if v1 != nil{
            self.lauchVolume = v1
        } else{
            self.lauchVolume = 0.5
        }
        
        // background volume
        let v2=loadSetting("background_volume") as? Float
        if v2 != nil{
            self.backgroundVolume = v2
        } else{
            self.backgroundVolume = 0.5
        }
        
        // maximum regeret step
        let val=loadSetting("max_regret") as? Int
        switch val{
        case 0:
            self.maxRegretStep = 1
        case 1:
            self.maxRegretStep = 2
        default:
            self.maxRegretStep = 0
            
        }
    }
    
    /* Update the board information including pieces*/
    func boardDidUpdate() {
        self.boardView.pieces = self.board!.pieces
        self.boardView.lastMove = self.board?.lastMove
        // to do: other updates
        DispatchQueue.main.async {[unowned self] in
            self.boardView.setNeedsDisplay()
        }
        if self.board?.currTurn==Piece.white{
            print("white show")
            self.blackChessImage.isHidden=true
            self.whiteChessImage.isHidden=false
        }else{
            print("black show")
            self.blackChessImage.isHidden=false
            self.whiteChessImage.isHidden=true
        }
    }
    
    /* Update the board status*/
    func boardStatusUpdated(data: Any?) {
        DispatchQueue.main.async {[unowned self] in
            if data != nil {
                if let coordinates = data as? [Coordinate] {
                    self.boardView.winningCoordinates = coordinates
                    self.boardView.setNeedsDisplay()
                }
            }
        }
        if !self.PartyGame{
            // show a alert to restart or go back to main menu
            let alert = UIAlertController(title: "\(self.board?.currTurn == .white ? "White" : "Black") Wins!", message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: {action in
                
                // replay background music
                let url = Bundle.main.url(forResource: "background", withExtension: "m4a")!
                backgroundSoundPlayer = try!AVAudioPlayer(contentsOf: url)
                backgroundSoundPlayer.volume = 10 * (self.backgroundVolume ?? 0.5)
                backgroundSoundPlayer.numberOfLoops = -1
                backgroundSoundPlayer.prepareToPlay()
                backgroundSoundPlayer.play()
                
                // restart the new game
                self.gameRestart()
                }
            ))
            
            alert.addAction(UIAlertAction(title: "Back to Main Menu", style: .default, handler: {action in
                
                // stop background music
                backgroundSoundPlayer.stop()
                
                // back to the main menu
                let MainMenuView = self.storyboard!.instantiateViewController(withIdentifier: "MainMenu")
                MainMenuView.modalPresentationStyle = .fullScreen
                self.present(MainMenuView, animated:true, completion:nil)
                
                }
            ))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {action in
                // if alert cancelled, lock the board
                self.boardView.isUserInteractionEnabled = false
            }
            ))
            self.present(alert, animated: true)
        } else {
            // show a alert to back to party game view
            let alert = UIAlertController(title: "\(self.board?.currTurn == .white ? "White" : "Black") Wins!", message: "", preferredStyle: .alert)
            self.Players[(self.board?.currTurn == .white ? self.WhitePlayer : self.BlackPlayer)!]! += 3
            
            // sort Players by score
            let sorted = Array(self.Players).sorted{$0.1 < $1.1}
            self.Players = [:]
            for pair in sorted {
                self.Players[pair.key] = pair.value
            }
            
            alert.addAction(UIAlertAction(title: "Back to Menu", style: .default, handler: {action in
                
                // stop background music
                backgroundSoundPlayer.stop()
                
                
                
                // back to the party view
                let PartyView = self.storyboard!.instantiateViewController(withIdentifier: "PartyView") as! PartyViewController
                PartyView.Players = self.Players
                PartyView.modalPresentationStyle = .fullScreen
                self.present(PartyView, animated:true, completion:nil)
                
                }
            ))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {action in
                // if alert cancelled, lock the board
                self.boardView.isUserInteractionEnabled = false
            }
            ))
            self.present(alert, animated: true)
        }
    }
    
    /* restart a game and reset the board */
    func gameRestart() {
        // to do: reset game
        self.board = Board()
        board?.delegate = self
        self.boardView.pieces = self.board?.pieces
        self.boardView.winningCoordinates?.removeAll()
        self.boardView.lastMove = nil
        DispatchQueue.main.async {[unowned self] in
            self.boardView.setNeedsDisplay()
        }
    }

    /*Timer functions*/
    func runTimer() {
         timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(BoardViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    /* Decrease the time of the timer, if runs out of time, play random move*/
    @objc func updateTimer() {
        seconds! -= 1     //This will decrement(count down)the seconds.
        self.timeLabel.text = String(self.timeString(TimeInterval(seconds!))) //This will update the label.
        if seconds!<=0{
            self.board?.randomPut(self.maxRegretStep ?? 0)
            resetTimer()
        }
    }

    /* Reset the timer to max time*/
    func resetTimer() {
         timer.invalidate()
         seconds = timeToTakeMove
        self.timeLabel.text = String(self.timeString(TimeInterval(seconds!)))
        self.runTimer()
    }
    
    /* Format the seconds into 00:00:00 */
    func timeString(_ time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    /* Reset the setting */
    func resetSetting(){
        /* Set the timeToTakeMove accorrding to setting*/
        loadTimeFromSetting()
        
        /* load setting variables */
        loadOtherSettings()
    
        backgroundSoundPlayer.volume = 10 * (self.backgroundVolume ?? 0.5)
    }
    
    /* Getting unwind segue from popup window*/
    @IBAction func unwindToSetting(segue: UIStoryboardSegue){
        self.resetSetting()
        print("notice get closed")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
