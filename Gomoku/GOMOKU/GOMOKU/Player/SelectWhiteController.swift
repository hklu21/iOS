//
//  SelectWhiteController.swift
//  GOMOKU
//
//  Created by 卢恒宽 on 3/15/22.
//

import UIKit

class SelectWhiteController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var AllPlayers: [String:Int] = [:]
    var Players: [String:Int] = [:]
    var BlackPlayer: String?
    var WhitePlayer: String?
    
    @IBAction func backButtonTouched(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var PlayersView: UITableView!
    @IBAction func OkButtonClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "PartyGame", sender: "PartyGame")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.PlayersView.delegate = self
        self.PlayersView.dataSource = self
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PlayerCell
        self.WhitePlayer = cell.PlayerName.text
    }
    
    /* pass data to board view */
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        if (segue.identifier == "PartyGame") {
            let vc = segue.destination as! BoardViewController
            vc.Players = self.AllPlayers
            vc.BlackPlayer = self.BlackPlayer
            vc.WhitePlayer = self.WhitePlayer
            vc.PartyGame = true
        }
    }


}
