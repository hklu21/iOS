//
//  ContinueMenuController.swift
//  GOMOKU
//
//  Created by 卢恒宽 on 3/9/22.
//

import UIKit

class ContinueMenuController: UITableViewController {
    let savedGameStringPrefix="saved_board_game_"
    var SavedGameNameList = [String]()
    @IBAction func backButtonTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        backgroundSoundPlayer.stop()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getSavedGameNameList()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.SavedGameNameList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedGameCell", for: indexPath) as! SavedGameCell
        
        cell.GameName.text = SavedGameNameList[indexPath.row]
        cell.SavedTime.text = "saved just now"

        return cell
    }
    
    /* Get the savings from user default*/
    func getSavedGameNameList(){
        for key in UserDefaults.standard.dictionaryRepresentation().keys where key.starts(with: savedGameStringPrefix){
            let startIndex = key.index(key.startIndex, offsetBy: savedGameStringPrefix.count)
            let mySubstring = String(key[startIndex..<key.endIndex])
            SavedGameNameList.append(mySubstring)
        }
    }
    
    /*Handle saved game cell get clicked*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "savedGame"  {
            print("getClicked")
            if let destination = segue.destination as? BoardViewController,
               let issueIndex = tableView.indexPathForSelectedRow?.row
           {
                destination.game=Game(gameName: self.SavedGameNameList[issueIndex])
           }
        }
    }
    
    /* Swipe to delete */
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            /* Delete from user default */
            let userDefaults = UserDefaults.standard
            userDefaults.removeObject(forKey: "saved_board_game_\(self.SavedGameNameList[indexPath.row])")
            self.SavedGameNameList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
