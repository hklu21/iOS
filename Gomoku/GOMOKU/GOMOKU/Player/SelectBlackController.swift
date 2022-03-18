//
//  SelectBlackController.swift
//  GOMOKU
//
//  Created by 卢恒宽 on 3/15/22.
//

import UIKit

class SelectBlackController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var Players: [String:Int] = [:]
    var BlackPlayer: String?
    @IBAction func backButtonTouched(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var PlayersView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.PlayersView.delegate = self
        self.PlayersView.dataSource = self
    }
    
    @IBAction func OkButtonClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SelectWhite", sender: "SelectWhite")
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
        self.BlackPlayer = cell.PlayerName.text
    }
    
    /* pass data to selection views */
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        if (segue.identifier == "SelectWhite") {
            var UnselectedPlayers = self.Players
            UnselectedPlayers[BlackPlayer!] = nil
            let vc = segue.destination as! SelectWhiteController
            vc.Players = UnselectedPlayers
            vc.AllPlayers = self.Players
            vc.BlackPlayer = self.BlackPlayer
        }
    }

}
