//
//  PartyViewController.swift
//  GOMOKU
//
//  Created by 卢恒宽 on 3/15/22.
//

import UIKit

class PartyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var Players: [String:Int] = [:]
    

    @IBAction func backButtonClicked(_ sender: UIButton) {
        // show a alert to restart or go back to main menu
        let alert = UIAlertController(title: "End the competition?", message: "", preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: "End", style: .default, handler: {action in
            
            // stop background music
            backgroundSoundPlayer.stop()
            
            // back to the main menu
            let MainMenuView = self.storyboard!.instantiateViewController(withIdentifier: "MainMenu")
            MainMenuView.modalPresentationStyle = .fullScreen
            self.present(MainMenuView, animated:true, completion:nil)
            
            }
        ))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    /* add players with name */
    @IBAction func AddPlayerButtonTouched(_ sender: UIButton) {
        var textField: UITextField?
        let alertController = UIAlertController(title: "Add Player", message: "Player Name:", preferredStyle: .alert)
          alertController.addTextField { (pTextField) in
          pTextField.placeholder = "your name"
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
            self.Players[inputValue!] = 0
            
            // sort Players by score
            let sorted = Array(self.Players).sorted{$0.1 < $1.1}
            self.Players = [:]
            for pair in sorted {
                self.Players[pair.key] = pair.value
            }
            
            // refresh PlayersView
            DispatchQueue.main.async { self.PlayersView.reloadData() }
          alertController.dismiss(animated: true, completion: nil)
        }))

        // show alert controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var PlayersView: UITableView!
    
    @IBOutlet weak var NewGameButton: UIButton!
    
    
    @IBAction func NewGameButtonClicked(_ sender: UIButton) {
        print(self.Players.count)
        if self.Players.count < 2 {
            // players not enough
            let alert = UIAlertController(title: "Please Add Players", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        } else {
            // chose players
            self.performSegue(withIdentifier: "SelectBlack", sender: "SelectBlack")
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.PlayersView.delegate = self
        self.PlayersView.dataSource = self
        self.NewGameButton.layer.cornerRadius = self.NewGameButton.frame.size.width/2
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.Players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as! PlayerCell
        
        cell.PlayerName.text = Players.keys[(Players.index(Players.startIndex, offsetBy: indexPath.row))]
        cell.PlayerScore.text = "Score: \(self.Players[cell.PlayerName.text!] ?? 0)"

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    /* pass data to selection views */
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        if (segue.identifier == "SelectBlack") {
            let vc = segue.destination as! SelectBlackController
            vc.Players = self.Players
        }
    }
    

}
